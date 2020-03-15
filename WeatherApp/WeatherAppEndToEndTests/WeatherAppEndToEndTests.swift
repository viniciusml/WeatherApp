//
//  WeatherAppEndToEndTests.swift
//  WeatherAppEndToEndTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppEndToEndTests: XCTestCase {

    func test_endToEndGETCurrentWeather_matchesFixedTestData() {
        
        switch getCurrentWeather() {
        case let .success(item):
            XCTAssertEqual(item.coord, Coord(lon: 139, lat: 35))
            XCTAssertEqual(item.name, "Shuzenji")
            
        case let .failure(error):
            XCTFail("Expected successful current weather result, got \(error) instead")
            
        default:
            XCTFail("Expected successful current weather result, got no instead")
        }
    }

    // MARK: - Helpers
    
    private func getCurrentWeather() -> WeatherResult? {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather")!
        let client = HTTPClient()
        let loader = WeatherLoader(url: url, client: client)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: WeatherResult?
        
        loader.loadCurrentWeather { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
}
