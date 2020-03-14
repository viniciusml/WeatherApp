//
//  CurrentWeatherItem.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

struct CurrentWeatherItem {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let dt: Int
    let name: String
}

struct Main {
    let temp: Double
}

struct Coord {
    let lon, lat: Double
}

struct Weather {
    let main, weatherDescription: String
}
