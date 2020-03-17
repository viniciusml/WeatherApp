//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import WeatherApp

class LocationServiceTests: XCTestCase {
    
    func test_provider_init_doesNotRequestsUserAuthorization() {
        XCTAssertFalse(makeSUT().provider.isAuthorized)
    }
    
    func test_provider_requestAuthorization_requestsUserAuthorization() {
        let (_, provider) = makeSUT()
        
        provider.requestWhenInUseAuthorization()
        
        XCTAssertNotNil(provider.isAuthorized)
    }
    
    func test_provider_requestLocation_requestsUserLocation() {
        let (_, provider) = makeSUT()
        
        provider.requestLocation()
        
        XCTAssertFalse(provider.locationRequests.isEmpty)
    }
    
    func test_service_getCurrentLocation_deliversErrorWhenNotAuthorized() {
        let (sut, _) = makeSUT()
        
        sut.getCurrentLocation { result in
            switch result {
            case let .failure(error):
                XCTAssertEqual(error, .cannotBeLocated)
            default:
                XCTFail("Expected error, but got \(result) instead")
            }
        }
    }
    
    func test_service_getCurrentLocation_requestsAuthorizationWhenNotAuthorized() {
        let (sut, provider) = makeSUT()
        
        sut.getCurrentLocation { _ in }
        
        XCTAssertEqual(provider.authorizationRequests, [true])
    }
    
    func test_service_getCurrentLocation_doesNotRequestAuthorizationWhenPreviouslyAuthorized() {
        let (sut, provider) = makeSUT()
        
        provider.isAuthorized = true
        sut.getCurrentLocation { _ in }
        
        XCTAssertEqual(provider.authorizationRequests, [])
    }
    
    func test_service_getCurrentLocation_requestsLocationWhenAuthorized() {
        let (sut, provider) = makeSUT()
        
        provider.isAuthorized = true
        sut.getCurrentLocation { _ in }
        
        XCTAssertEqual(provider.locationRequests, [true])
    }
    
    func test_service_getCurrentLocationTwice_requestsLocationTwice() {
        let (sut, provider) = makeSUT()

        provider.isAuthorized = true
        sut.getCurrentLocation { _ in }
        sut.getCurrentLocation { _ in }
        
        XCTAssertEqual(provider.locationRequests, [true, true])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocationService, provider: LocationProviderMock) {
        let provider = LocationProviderMock()
        let sut = LocationService(provider: provider)
        return (sut, provider)
    }
}
