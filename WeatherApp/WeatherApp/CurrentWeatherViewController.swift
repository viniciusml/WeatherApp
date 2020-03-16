//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 16/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    let client = HTTPClient()
    var loader: WeatherLoader {
        return WeatherLoader(url: "http://api.openweathermap.org/data/2.5/weather", client: client)
    }
    
    let provider = CLLocationManager()
    var service: LocationService?
    
    private(set) var locations = [UserLocation]() {
        didSet {
            getWeather(for: locations.first?.coordinate)
        }
    }
    
    private(set) var currentWeather: WeatherItem? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = "Weather App"
        getLocation()
    }
    
    func getLocation() {
        service = LocationService(provider: provider)
        
        service?.getCurrentLocation { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(location):
                self.locations.append(location)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getWeather(for location: Coordinate?) {
        loader.loadCurrentWeather(parameters: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let item):
                print(item)
                self.currentWeather = item
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CurrentWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherCell
        cell.cityNameLabel.text = currentWeather?.name
        
        return cell
    }
}
