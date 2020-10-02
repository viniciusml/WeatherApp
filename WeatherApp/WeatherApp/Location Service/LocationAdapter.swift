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

public enum LocationError: Error {
    case cannotBeLocated
}

public protocol UserLocation {
    var coordinate: Coordinate { get }
}

public typealias LocationResult = Result<UserLocation, LocationError>

