//
//  LocationResult.swift
//  WeatherApp
//
//  Created by Vinicius Leal on 02/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public enum LocationError: Error {
    case cannotBeLocated
}

public protocol UserLocation {
    var coordinate: Coordinate { get }
}

public typealias LocationResult = Result<UserLocation, LocationError>
