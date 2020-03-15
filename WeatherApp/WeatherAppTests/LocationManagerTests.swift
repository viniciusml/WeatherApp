//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import WeatherApp

class LocationManagerTests: XCTestCase {
    
    func test_init_doesNotRequestsUserAuthorization() {
        let sut = LocationProviderMock()
        
        XCTAssertFalse(sut.isAuthorized)
    }
    
    func test_manager_requestsUserAuthorization() {
        let sut = LocationProviderMock()
        
        sut.requestAuthorization()
        
        XCTAssertNotNil(sut.isAuthorized)
    }
    
    func test_manager_requestsUserLocation() {
        let sut = LocationProviderMock()
        
        sut.requestLocation()
        
        XCTAssertNotNil(sut.locationRequested)
    }
    
    private class LocationProviderMock: LocationProvider {
        
        var isAuthorized: Bool = false
        var locationRequested: Bool? = nil
        
        func requestAuthorization() {
            isAuthorized = true
        }
        
        func requestLocation() {
            locationRequested = true
        }
    }
}
