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
            provider.requestAuthorization()
            completion(.cannotBeLocated)
        } else {
            provider.requestLocation()
        }
    }
}

class LocationServiceTests: XCTestCase {
    
    func test_provider_init_doesNotRequestsUserAuthorization() {
        XCTAssertFalse(makeSUT().provider.isAuthorized)
    }
    
    func test_provider_requestAuthorization_requestsUserAuthorization() {
        let (_, provider) = makeSUT()
        
        provider.requestAuthorization()
        
        XCTAssertNotNil(provider.isAuthorized)
    }
    
    func test_provider_requestLocation_requestsUserLocation() {
        let (_, provider) = makeSUT()
        
        provider.requestLocation()
        
        XCTAssertTrue(provider.locationRequested)
    }
    
    func test_service_getCurrentLocation_deliversErrorWhenNotAuthorized() {
        let (sut, _) = makeSUT()
        
        var capturedError: Error?
        sut.getCurrentLocation { error in
            capturedError = error
        }
        
        XCTAssertNotNil(capturedError)
    }
    
    func test_service_getCurrentLocation_requestsAuthorizationWhenNotAuthorized() {
        let (sut, provider) = makeSUT()
        
        sut.getCurrentLocation { _ in }
        
        XCTAssertTrue(provider.isAuthorized)
    }
    
    func test_service_getCurrentLocation_doesNotRequestAuthorizationWhenPreviouslyAuthorized() {
        let (sut, provider) = makeSUT()
        
        provider.isAuthorized = true
        sut.getCurrentLocation { _ in }
        
        XCTAssertTrue(provider.isAuthorized)
    }
    
    func test_service_getCurrentLocation_requestsLocationWhenAuthorized() {
        let (sut, provider) = makeSUT()
        
        provider.isAuthorized = true
        sut.getCurrentLocation { _ in }
        
        XCTAssertTrue(provider.locationRequested)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocationService, provider: LocationProviderMock) {
        let provider = LocationProviderMock()
        let sut = LocationService(provider: provider)
        return (sut, provider)
    }
    
    private class LocationProviderMock: LocationProvider {
        
        var isAuthorized: Bool = false
        var locationRequested: Bool = false
        
        func requestAuthorization() {
            isAuthorized.toggle()
        }
        
        func requestLocation() {
            locationRequested = true
        }
    }
}
