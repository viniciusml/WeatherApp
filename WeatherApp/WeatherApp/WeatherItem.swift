//
//  CurrentWeatherItem.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

struct WeatherItem: Equatable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let dt: Int
    let name: String
}

struct Main: Equatable {
    let temp: Double
}

struct Coord: Equatable {
    let lon, lat: Double
}

struct Weather: Equatable {
    let main, weatherDescription: String
}
