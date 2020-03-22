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
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(WeatherCell.self)
        return tv
    }()
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Weather App"
        return label
    }()
    
    let client = HTTPClient()
    var loader: WeatherLoader {
        return WeatherLoader(url: "http://api.openweathermap.org/data/2.5/weather", client: client)
    }
    
    let provider = CLLocationManager()
    var service: LocationService?
    
    private(set) var locations = [UserLocation]() {
        didSet {
            if let coordinate = locations.first?.coordinate {
                getWeather(for: coordinate)
            }
        }
    }
    
    var currentWeather: WeatherItem? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        
        headerLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 80))
        tableView.anchor(top: headerLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        tableView.separatorStyle = .none
        
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
        loader.loadCurrentWeather(parameters: location) { [weak self] result in
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

extension CurrentWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(WeatherCell.self) {
            cell.currentWeather = currentWeather
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct CurrentWeatherViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let vc = CurrentWeatherViewController()
        let weather = WeatherItem(coord: Coord(lon: 200.00, lat: 200.00), weather: [Weather(main: "Weather", description: "description")], main: Main(temp: 200.00), name: "City Name")
        vc.currentWeather = weather
        vc.tableView.reloadData()
        return vc.view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        
    }
}

@available(iOS 13.0, *)
struct CurrentWeatherController_Preview: PreviewProvider {
    static var previews: some View {
        CurrentWeatherViewRepresentable()
    }
}
#endif
