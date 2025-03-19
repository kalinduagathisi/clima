//
//  WeatherManager.swift
//  Clima
//
//  Created by Kalindu Agathisi on 2025-03-19.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    let apiKey = Secrets.apiKey

    // now weather url will be evaluated at runtime, instead of initialization
    var weatherUrl: String {
        return "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)"
    }
        
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }

    func performRequest(urlString: String) {

        // create a URL
        if let url = URL(string: urlString) {

            // create a URL Session
            let session = URLSession(configuration: .default)

            // Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }

                // do an optional binding
                if let safeData = data {
                    self.parseJson(weatherData: safeData)
                }
            }

            // Start the task
            task.resume()
        }
    }

    func parseJson(weatherData: Data) {
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

        } catch {
            print(error)
        }

    }

    
}
