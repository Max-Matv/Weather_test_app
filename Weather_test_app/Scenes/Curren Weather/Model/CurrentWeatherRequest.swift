//
//  CurrentWeatherRequest.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 9.12.23.
//

import Foundation

struct CurrenWeatherRequest: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let id: Int
    let name: String

    
    // MARK: - Coord
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }

    // MARK: - Main
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp = "temp"
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure = "pressure"
            case humidity = "humidity"
        }
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
}

