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
    
    var locationProviderDelegate: LocationProviderDelegate?

    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters
    
    var isAuthorized: Bool = false
    var locationRequests = [Bool]()
    var authorizationRequests = [Bool]()
    var locationToReturn = [CLLocation]()
    
    func requestWhenInUseAuthorization() {
        authorizationRequests.append(true)
        isAuthorized.toggle()
    }
    
    func requestLocation() {
        locationRequests.append(true)
//        guard let location = locationToReturn?() else { return }
        locationProviderDelegate?.locationManager(self, didUpdateLocations: locationToReturn)
    }
}
