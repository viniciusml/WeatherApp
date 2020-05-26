//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 16/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//  Design inspiration:  https://www.behance.net/gallery/90366995/Weather-App?tracking_source=search%7Cweather%20app

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    let client = HTTPClient()
    var loader: RemoteLoader {
        return RemoteLoader(url: "http://api.openweathermap.org/data/2.5/weather", client: client)
    }
    
    let provider = CLLocationManager()
    var service: LocationService?
    
    var locations = [UserLocation]() {
        didSet {
            if let coordinate = locations.first?.coordinate {
                getWeather(for: coordinate)
            }
        }
    }

    let mainView = MainWeatherView()
    
    var currentWeather: WeatherItem? {
        didSet {
            mainView.update(locations: locations, currentWeather: currentWeather)
        }
    }

    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getLocation()
    }
    
    func getLocation() {
        service = LocationService(provider: provider)
        
        service?.getCurrentLocation { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(location):
                self.locations = []
                self.locations.append(location)
            case let .failure(error):
                self.showBasicAlert(title: "Error", message: "There was an \(error). Please try again.")
            }
        }
    }
    
    func getWeather(for location: Coordinate?) {
        loader.load(WeatherItem.self, parameters: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let item):
                self.currentWeather = item
            case .failure(let error):
                self.showBasicAlert(title: "Error", message: "There was an \(error). Please try again.")
            }
        }
    }
}
