//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    let provider = CLLocationManager()
    var service: LocationService?
    
    private(set) var locations = [UserLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = "Weather App"
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
}

extension CurrentWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
