//
//  LocationProviderMock.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import CoreLocation
@testable import WeatherApp

class LocationProviderMock: LocationProvider {
    
    var locationManagerDelegate: CLLocationManagerDelegate? = nil
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters
    
    var isAuthorized: Bool = false
    var locationRequests = [Bool]()
    
    func requestWhenInUseAuthorization() {
        isAuthorized.toggle()
    }
    
    func requestLocation() {
        locationRequests.append(true)
    }
}
