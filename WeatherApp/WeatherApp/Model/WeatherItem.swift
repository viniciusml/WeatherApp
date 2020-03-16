//
//  CurrentWeatherItem.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

struct WeatherItem: Decodable, Equatable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Main: Decodable, Equatable {
    let temp: Double
}

struct Coord: Decodable, Equatable {
    let lon, lat: Double
}

struct Weather: Decodable, Equatable {
    let main, description: String
}
