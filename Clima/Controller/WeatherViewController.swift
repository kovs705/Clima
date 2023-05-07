//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    // weather icon:
    @IBOutlet weak var conditionImageView: UIImageView!
    // temperature number:
    @IBOutlet weak var temperatureLabel: UILabel!
    // name of the city:
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    // that object will be responsible for current GPS location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        // asking for location access
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        // the text field should handle the text and notify what`s happening.
        
    }
    
    
    @IBAction func updateMyLocation(_ sender: UIButton) {
        // we should request location, even if it is exactly the same as the last:
        locationManager.requestLocation()
    }
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // when user ckicls отправить
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
        // when clicking Search button, and text is "", it will show "Type something"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // use searchTextField.text to get the weather for a city:
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        // when user stop editing
        searchTextField.text = ""
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            // updating temperature label:
            self.temperatureLabel.text = weather.temperatureString
            // updating temperature icon:
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // we should stop updating location to get the user's location without any problem:
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            // stop and use these lat and long with fetchWeather function
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
