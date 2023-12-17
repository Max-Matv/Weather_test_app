//
//  CurrentWeatherViewModel.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 8.12.23.
//

import Foundation

protocol CurrentWeatherProtocol {
    func addWeatherRequest(lat: Double, lon: Double)
    func addCurrentWeatherRequest(lat: Double, lon: Double)
    func getCurrentDay() -> [List]
    func getSortedArrayByDay() -> [[List]]
    func getOfflineData()
    func getInterval() -> String
}

final class CurrentWeatherViewModel: CurrentWeatherProtocol {
    private weak var viewController: CurrentWeatherViewController?
    // MARK: - Properties
    private var currentDay: [List] = []
    private var sortedArrayByDay = [[List]]()
    private var interval = ""
    
    
    init(viewController: CurrentWeatherViewController? = nil) {
        self.viewController = viewController
    }
    //MARK: - Functions
    func getCurrentDay() -> [List] {
        currentDay
    }
    func getInterval() -> String {
        interval
    }
    
    func getSortedArrayByDay() -> [[List]] {
        sortedArrayByDay
    }
    //MARK: - Weather request
    func addWeatherRequest(lat: Double, lon: Double) {
        let tempSystem = "imperial".localized()
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=a06b1cda623e77487cd7a016bba833cc&units=\(tempSystem)")!
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("data.json")
            do {
                try data.write(to: file)
                let weatherResponse = try JSONDecoder().decode(WeatherRequest.self, from: data)
                self.sortedArrayByDay = self.sortingRequestByDay(arr: weatherResponse.list)
                self.currentDay = self.sortedArrayByDay.first!
                DispatchQueue.main.async {
                    self.viewController?.weatherRequest(weather: weatherResponse)
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    //MARK: - Offline data
    func getOfflineData() {
        let currentfile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("CurrentData.json")
        
        let data = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("data.json")
        do {
            //current
            let currentData = try Data(contentsOf: currentfile)
            let currentWeather = try JSONDecoder().decode(CurrenWeatherRequest.self, from: currentData)
            //list
            let data = try Data(contentsOf: data)
            let weather = try JSONDecoder().decode(WeatherRequest.self, from: data)
            self.interval = calculateDate(weather: weather)
            self.sortedArrayByDay = self.sortingRequestByDay(arr: weather.list)
            self.currentDay = self.sortedArrayByDay.first!
            DispatchQueue.main.async {
                self.viewController?.currentWeatherRequest(weather: currentWeather)
                self.viewController?.weatherRequest(weather: weather)
            }
        } catch {
            print("no data")
        }
    }
    //MARK: - Current weather request
    //Due to API limitations, you have to use 2 requests
    func addCurrentWeatherRequest(lat: Double, lon: Double) {
        let tempSystem = "imperial".localized()
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=131929858189fb4fc1102e911176c19f&units=\(tempSystem)")!
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("CurrentData.json")
            do {
                try data.write(to: file)
                let weatherResponse = try JSONDecoder().decode(CurrenWeatherRequest.self, from: data)
                DispatchQueue.main.async {
                    self.viewController?.currentWeatherRequest(weather: weatherResponse)
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    private func calculateDate(weather: WeatherRequest) -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let lastDate = dateFormatter.date(from: weather.list.first!.dtTxt)
        let interval = currentDate.timeIntervalSince(lastDate!)
        let minutes = interval / 60
        let hours = interval / 3600
        let days = interval / 86400
        
        if Int(days) > 0 {
            return "\(Int(days))" + "d ago".localized()
        }
        else if Int(hours) > 0 {
            return "\(Int(hours))" + "h ago".localized()
        }
        else if Int(minutes) > 0 {
            return "\(Int(minutes))" + "m ago".localized()
        }
        else {
            return "\(Int(interval))" + "s ago".localized()
        }
    }
    
    // to sort the request
    private func sortingRequestByDay(arr: [List]) -> [[List]] {
        var array = [[List]]()
        var baseArray = [List]()
        let dateFormatter = DateFormatter()
        var lastDay: String = ""
        for (index, element) in arr.enumerated() {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: element.dtTxt)
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: date!)
            if index == 0 {
                baseArray.append(element)
                lastDay = dateFormatter.string(from: date!)
                continue
            }
            if day == lastDay {
                baseArray.append(element)
            } else {
                array.append(baseArray)
                baseArray.removeAll()
                baseArray.append(element)
            }
            lastDay = dateFormatter.string(from: date!)
        }
        return array
    }
    
}
