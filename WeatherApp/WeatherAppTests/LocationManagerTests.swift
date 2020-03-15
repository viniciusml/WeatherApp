//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import WeatherApp

enum LocationError: Error {
    case cannotBeLocated
}

class LocationService {
    
    let provider: LocationProvider
    
    init(provider: LocationProvider) {
        self.provider = provider
    }
    
    func getCurrentLocation(completion: (LocationError) -> Void) {
        if !provider.isAuthorized {
            completion(.cannotBeLocated)
        }
    }
}

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
    
    func test_service_requestLocation_deliversErrorWhenNotAuthorized() {
        let (sut, _) = makeSUT()
        
        var capturedError: Error?
        sut.getCurrentLocation { error in
            capturedError = error
        }
        
        XCTAssertNotNil(capturedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocationService, provider: LocationProviderMock) {
        let provider = LocationProviderMock()
        let sut = LocationService(provider: provider)
        return (sut, provider)
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
