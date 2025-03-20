//
//  WeatherManager.swift
//  Clima
//
//  Created by Kalindu Agathisi on 2025-03-19.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

// protocol weatherManagerDelegate
// protocols are like interfaces in java
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailedWithError(error: Error)
}

struct WeatherManager {
    
    let apiKey = Secrets.apiKey

    // now weather url will be evaluated at runtime, instead of initialization
    var weatherUrl: String {
        return "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    }
    
    var delegate: WeatherManagerDelegate?
        
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(lattitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {

        // create a URL
        if let url = URL(string: urlString) {

            // create a URL Session
            let session = URLSession(configuration: .default)

            // Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailedWithError(error: error!)
                    return
                }

                // do an optional binding
                if let safeData = data {
                    if let weather = self.parseJson(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }

            // Start the task
            task.resume()
        }
    }

    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(
                WeatherData.self, from: weatherData)
            
            let conditionId = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            
            let weather = WeatherModel(conditionId: conditionId, cityName: cityName, temperature: temp)
            print(weather.conditionName)
            print(weather.tempString)
            return weather

        } catch {
            self.delegate?.didFailedWithError(error: error)
            return nil
        }

    }

    
}
