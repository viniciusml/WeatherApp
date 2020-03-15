//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

class LocationService {
    var isAuthorized: Bool? = nil
    
    func requestAuthorization() {
        isAuthorized = true
    }
}

class LocationManagerTests: XCTestCase {
    
    func test_init_doesNotRequestsUserAuthorization() {
        let sut = LocationService()
        
        XCTAssertNil(sut.isAuthorized)
    }
    
    func test_requestAuthorization_requestsUserAuthorization() {
        let sut = LocationService()
        
        sut.requestAuthorization()
        
        XCTAssertNotNil(sut.isAuthorized)
    }
}
