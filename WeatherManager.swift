//
//  WeatherManager.swift
//  MapKitProject
//
//  Created by Adam R. Brown on 12/2/24.
//

import Foundation
import WeatherKit
import MapKit

class WeatherManager : ObservableObject {
    
    let weatherService = WeatherService()
    
    var weather: Weather?
    
    func findWeather(location: CLLocationCoordinate2D) async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {[weak self] in
                return try await self?.weatherService.weather(for: .init(latitude: location.latitude, longitude: location.longitude))
            }.value
        } catch {
            print("Failed to find data.")
        }
    }
    
    var symbol: String {
        guard let symbolName = weather?.currentWeather.symbolName else {return "None"}
        return symbolName
    }
    
    var temp: String {
        guard let temperature = weather?.currentWeather.temperature.value else {return "0"}
        return String(Int(temperature))
    }
    
    var condition: String {
        guard let cond = weather?.currentWeather.condition.description else {return "nonexistient"}
        return cond
    }
    
    var humidity: String {
        guard let humidity = weather?.currentWeather.humidity.description else {return "0"}
        return humidity
    }
}
