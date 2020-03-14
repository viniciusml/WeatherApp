//
//  CurrentWeatherLoaderTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

class WeatherLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class CurrentWeatherLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = WeatherLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
