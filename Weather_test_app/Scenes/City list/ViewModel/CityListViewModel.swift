//
//  CityListViewModel.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 15.12.23.
//

import Foundation

protocol CityListProtocol {
    func addCurrentRequestForName(name: String, completition: @escaping(CurrenWeatherRequest?, Error?) -> Void)
    func preseting(list: [CityObj])
}


final class CityListViewModel: CityListProtocol {
    
    private weak var viewController: CityListViewController?
    
    init(viewController: CityListViewController? = nil){
        self.viewController = viewController
    }
    // Preseting city list
    func preseting(list: [CityObj]) {
        var dataArray: [CurrenWeatherRequest] = []
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        DispatchQueue.concurrentPerform(iterations: list.count) { index in
            group.enter()
            addCurrentRequestForName(name: list[index].name) { data, error in
                guard let response = data else {
                    group.leave()
                    return }
                semaphore.wait()
                dataArray.append(response)
                group.leave()
                semaphore.signal()
            }
        }
        group.notify(queue: .main) {
            self.viewController?.weatherRequest(list: dataArray)
        }
    }
    
    func addCurrentRequestForName(name: String, completition: @escaping (CurrenWeatherRequest?, Error?) -> Void) {
        let tempSystem = "imperial".localized()
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(name)&appid=131929858189fb4fc1102e911176c19f&units=\(tempSystem)")!
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let weatherResponse = try JSONDecoder().decode(CurrenWeatherRequest.self, from: data)
                completition(weatherResponse, nil)
            } catch {
                debugPrint(error.localizedDescription)
                completition(nil, error)
            }
        }
        dataTask.resume()
    }
}
