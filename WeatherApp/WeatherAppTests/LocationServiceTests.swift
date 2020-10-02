//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import CoreLocation
import XCTest
@testable import WeatherApp

class LocationServiceTests: XCTestCase {
    
    func test_init_doesNotRequestsUserAuthorization() {
        let (_, provider) = makeSUT()

        XCTAssertEqual(provider.authorizationRequestCount, 0)
    }

    func test_init_configuresProvider() {
        let (sut, provider) = makeSUT()

        XCTAssertEqual(provider.desiredAccuracy, kCLLocationAccuracyHundredMeters)
        XCTAssertTrue(provider.delegate === sut)
    }
    
    func test_getCurrentLocation_requestAuthorizationWhenNotPreviouslyAuthorized() {
        let (sut, provider) = makeSUT(.spy)

        sut.getCurrentLocation { _ in }

        XCTAssertEqual(provider.authorizationRequestCount, 1)
    }

    func test_getCurrentLocation_doesNotRequestAuthorizationWhenPreviouslyAuthorized() {
        let (sut, provider) = makeSUT(.authorizedSpy)

        sut.getCurrentLocation { _ in }

        XCTAssertEqual(provider.authorizationRequestCount, 0)
    }
    
    func test_getCurrentLocation_requestsUserLocation() {
        let (sut, provider) = makeSUT()

        sut.getCurrentLocation { _ in }

        XCTAssertEqual(provider.locationRequestCount, 1)
    }

    func test_getCurrentLocationTwice_requestsUserLocationTwice() {
        let (sut, provider) = makeSUT()

        sut.getCurrentLocation { _ in }
        sut.getCurrentLocation { _ in }

        XCTAssertEqual(provider.locationRequestCount, 2)
    }
    
    func test_getCurrentLocation_deliversErrorWhenNotAuthorized() {
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

//    func test_getCurrentLocation_deliversErrorOnUpdatingLocationError() {
//        let (sut, provider) = makeSUT()
//
//        sut.locationManager(provider, didFailWithError: NSError(domain: "any", code: 1))
//
//        expect(sut, toCompleteWith: .failure(.cannotBeLocated))
//    }
    
//    func test_service_getCurrentLocation_deliversLocationOnUpdatingLocationSuccess() {
//        let (sut, provider) = makeSUT()
//
//        provider.isAuthorized = true
//        provider.locationToReturn = Coordinate(latitude: 39, longitude: 135)
//
//        expect(sut, toCompleteWith: .success(UserLocationMock()))
//    }
    
    // MARK: - Helpers
    
//    private func makeSUT() -> (sut: LocationService, provider: LocationProviderMock) {
//        let provider = LocationProviderMock()
//        let sut = LocationService(provider: provider)
//        return (sut, provider)
//    }

    private func makeSUT(_ provider: CLLocationManager.Spy = .authorizedSpy) -> (sut: LocationService, provider: CLLocationManager.Spy) {
        let sut = LocationService(provider: provider)
        return (sut, provider)
    }
    
    private func expect(_ sut: LocationService, toCompleteWith expectedResult: LocationResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for request completion")
   
        sut.getCurrentLocation { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedLocation), .success(expectedLocation)):
                XCTAssertEqual(receivedLocation.coordinate.latitude, expectedLocation.coordinate.latitude, file: file, line: line)
                XCTAssertEqual(receivedLocation.coordinate.longitude, expectedLocation.coordinate.longitude, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead.", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    struct UserLocationMock: UserLocation {
        var coordinate: Coordinate {
            return Coordinate(latitude: 39, longitude: 135)
        }
    }
}

private extension CLLocationManager {
    static var spy: Spy { Spy() }
    static var authorizedSpy: Spy { AuthorizedSpy() }

    class Spy: CLLocationManager {
        private(set) var authorizationRequestCount = 0
        private(set) var locationRequestCount = 0

        override func requestWhenInUseAuthorization() {
            authorizationRequestCount += 1
        }

        override func requestLocation() {
            locationRequestCount += 1
        }
    }

    class AuthorizedSpy: Spy {
        override func needsAuthorizationRequest() -> Bool { false }
    }
}
