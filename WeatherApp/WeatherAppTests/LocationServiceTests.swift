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

        sut.getCurrentLocation()

        XCTAssertEqual(provider.authorizationRequestCount, 1)
    }

    func test_getCurrentLocation_doesNotRequestAuthorizationWhenPreviouslyAuthorized() {
        let (sut, provider) = makeSUT(.authorizedSpy)

        sut.getCurrentLocation()

        XCTAssertEqual(provider.authorizationRequestCount, 0)
    }
    
    func test_getCurrentLocation_requestsUserLocation() {
        let (sut, provider) = makeSUT()

        sut.getCurrentLocation()

        XCTAssertEqual(provider.locationRequestCount, 1)
    }

    func test_getCurrentLocationTwice_requestsUserLocationTwice() {
        let (sut, provider) = makeSUT()

        sut.getCurrentLocation()
        sut.getCurrentLocation()

        XCTAssertEqual(provider.locationRequestCount, 2)
    }
    
    func test_getCurrentLocation_doesNotRequestUserLocationWhenNotAuthorized() {
        let (sut, provider) = makeSUT(.spy)

        sut.getCurrentLocation()

        XCTAssertEqual(provider.locationRequestCount, 0)
    }

    func test_getCurrentLocation_deliversErrorOnManagerError() {
        let (sut, provider) = makeSUT()

        expect(sut, toCompleteWith: .failure(.cannotBeLocated), when: {
            sut.locationManager(provider, didFailWithError: anyError())
        })
    }
    
    func test_getCurrentLocation_deliversLocationOnManagerSuccess() {
        let (sut, provider) = makeSUT()
        let expectedLocation = UserLocationMock(latitude: 39, longitude: 135)

        expect(sut, toCompleteWith: .success(expectedLocation), when: {
            sut.locationManager(provider, didCompleteWith: [expectedLocation])
        })
    }

    func test_getCurrentLocation_deliversErrorOnManagerSuccessWithNoLocation() {
        let (sut, provider) = makeSUT()

        expect(sut, toCompleteWith: .failure(.cannotBeLocated), when: {
            sut.locationManager(provider, didCompleteWith: [])
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(_ provider: CLLocationManager.Spy = .authorizedSpy) -> (sut: LocationService, provider: CLLocationManager.Spy) {
        let sut = LocationService(provider: provider)
        return (sut, provider)
    }

    private func anyError() -> NSError {
        NSError(domain: "Test", code: 1)
    }
    
    private func expect(_ sut: LocationService, toCompleteWith expectedResult: LocationResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for request completion")

        sut.getCurrentLocation()
        sut.currentLocation = { receivedResult in
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
        action()
        
        wait(for: [exp], timeout: 0.2)
    }
    
    private struct UserLocationMock: UserLocation {
        let latitude: Double
        let longitude: Double

        var coordinate: Coordinate {
            Coordinate(latitude: latitude, longitude: longitude)
        }
    }
}
