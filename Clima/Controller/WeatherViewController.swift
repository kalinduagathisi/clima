//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegate property for weatherManager, Otherviwe it'll be nil
        weatherManager.delegate = self
        searchTextField.delegate = self
    }


    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // dismiss the keyboard once search/ go btn pressed
        print(searchTextField.text!)
    }
    
    // function to proceed when keyboards go btn pressed
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchTextField.endEditing(true)
//        print(searchTextField.text!)
//        return true
//    }
    
    // inform weather, that textfield should dismiss the keyboard or not
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Type something.."
            return false
        }
    }
    
    // clear the textfield once btn pressed
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }

    }
    
    func didFailedWithError(error: any Error) {
        print(error)
    }
}

