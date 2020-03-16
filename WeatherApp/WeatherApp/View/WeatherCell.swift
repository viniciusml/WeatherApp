//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 16/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    var currentWeather: WeatherItem? {
        didSet {
            cityNameLabel.text = currentWeather?.name
            temperatureLabel.text = currentWeather?.main.temp.description
            weatherDescriptionLabel.text = currentWeather?.weather.first?.description.capitalized
        }
    }
}
