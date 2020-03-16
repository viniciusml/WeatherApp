//
//  LocationAdapter.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 16/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

protocol LocationAdapter {
    func getCurrentLocation(completion: @escaping (LocationResult) -> Void)
}

enum LocationError: Error {
    case cannotBeLocated
}

protocol UserLocation {
    var coordinate: Coordinate { get }
}

typealias LocationResult = Result<UserLocation, LocationError>

