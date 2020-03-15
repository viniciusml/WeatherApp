//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

protocol LocationProvider {
    var isAuthorized: Bool { get }
    func requestAuthorization()
    func requestLocation()
}

class LocationService: LocationProvider {
    
    var isAuthorized: Bool = false
    var locationRequested: Bool? = nil
    
    func requestAuthorization() {
        isAuthorized = true
    }
    
    func requestLocation() {
        locationRequested = true
    }
}

class LocationManagerTests: XCTestCase {
    
    func test_init_doesNotRequestsUserAuthorization() {
        let sut = LocationService()
        
        XCTAssertFalse(sut.isAuthorized)
    }
    
    func test_manager_requestsUserAuthorization() {
        let sut = LocationService()
        
        sut.requestAuthorization()
        
        XCTAssertNotNil(sut.isAuthorized)
    }
    
    func test_manager_requestsUserLocation() {
        let sut = LocationService()
        
        sut.requestLocation()
        
        XCTAssertNotNil(sut.locationRequested)
    }
}
