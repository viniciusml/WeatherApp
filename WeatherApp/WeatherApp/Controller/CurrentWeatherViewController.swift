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
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .appBackground
        cv.delegate = self
        cv.dataSource = self
        cv.register(WeatherCell.self)
        return cv
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
    
    var locations = [UserLocation]() {
        didSet {
            if let coordinate = locations.first?.coordinate {
                getWeather(for: coordinate)
            }
        }
    }
    
    var currentWeather: WeatherItem? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appBackground
        view.addSubview(headerLabel)
        view.addSubview(collectionView)
        
        headerLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 80))
        collectionView.anchor(top: headerLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)

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

extension CurrentWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(WeatherCell.self, for: indexPath)!
        cell.currentWeather = currentWeather
        return cell
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct CurrentWeatherViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let vc = CurrentWeatherViewController()
        let weather = WeatherItem(coord: Coord(lon: 200.00, lat: 200.00), weather: [Weather(main: "Weather", description: "description")], main: Main(temp: 200.00), name: "City Name")
        vc.locations = [CLLocation(latitude: 200, longitude: 200)]
        vc.currentWeather = weather
        vc.collectionView.reloadData()
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
