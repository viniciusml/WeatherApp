//
//  LocationManagerTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import CoreLocation
import XCTest
import WeatherApp

class LocationServiceTests: XCTestCase {
    
    func test_init_doesNotRequestsUserAuthorization() {
        let (_, manager) = makeSUT()

        XCTAssertEqual(manager.authorizationRequestCount, 0)
    }

    func test_init_configuresManager() {
        let (sut, manager) = makeSUT()

        XCTAssertEqual(manager.desiredAccuracy, kCLLocationAccuracyHundredMeters)
        XCTAssertTrue(manager.delegate === sut)
    }
    
    func test_getCurrentLocation_requestAuthorizationWhenNotPreviouslyAuthorized() {
        let (sut, manager) = makeSUT(.spy)

        sut.getCurrentLocation()

        XCTAssertEqual(manager.authorizationRequestCount, 1)
    }

    func test_getCurrentLocation_doesNotRequestAuthorizationWhenPreviouslyAuthorized() {
        let (sut, manager) = makeSUT(.authorizedSpy)

        sut.getCurrentLocation()

        XCTAssertEqual(manager.authorizationRequestCount, 0)
    }
    
    func test_getCurrentLocation_requestsUserLocation() {
        let (sut, manager) = makeSUT()

        sut.getCurrentLocation()

        XCTAssertEqual(manager.locationRequestCount, 1)
    }

    func test_getCurrentLocationTwice_requestsUserLocationTwice() {
        let (sut, manager) = makeSUT()

        sut.getCurrentLocation()
        sut.getCurrentLocation()

        XCTAssertEqual(manager.locationRequestCount, 2)
    }
    
    func test_getCurrentLocation_doesNotRequestUserLocationWhenNotAuthorized() {
        let (sut, manager) = makeSUT(.spy)

        sut.getCurrentLocation()

        XCTAssertEqual(manager.locationRequestCount, 0)
    }

    func test_getCurrentLocation_deliversErrorOnManagerError() {
        let (sut, manager) = makeSUT()

        expect(sut, toCompleteWith: .failure(.cannotBeLocated), when: {
            sut.locationManager(manager, didFailWithError: anyError())
        })
    }
    
    func test_getCurrentLocation_deliversLocationOnManagerSuccess() {
        let (sut, manager) = makeSUT()
        let expectedLocation = UserLocationMock(latitude: 39, longitude: 135)

        expect(sut, toCompleteWith: .success(expectedLocation), when: {
            sut.locationManager(manager, didCompleteWith: [expectedLocation])
        })
    }

    func test_getCurrentLocation_deliversErrorOnManagerSuccessWithNoLocation() {
        let (sut, manager) = makeSUT()

        expect(sut, toCompleteWith: .failure(.cannotBeLocated), when: {
            sut.locationManager(manager, didCompleteWith: [])
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(_ manager: CLLocationManager.Spy = .authorizedSpy) -> (sut: LocationService, manager: CLLocationManager.Spy) {
        let sut = LocationService(manager: manager)
        return (sut, manager)
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
