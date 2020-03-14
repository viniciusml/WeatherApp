//
//  CurrentWeatherLoaderTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherLoader {
    let client: NetworkAdapter
    
    init(client: NetworkAdapter) {
        self.client = client
    }
    
    func loadCurrentWeather() {
        client.load(from: URL(string: "http:a-given-url.com")!) { _ in }
    }
}

class HTTPClient {
    var requestedURL: URL?
    
    func load() {
        
    }
}

class HTTPClientSpy: NetworkAdapter {

    var requestedURL: URL?
    
    func load(from url: URL, completion: @escaping (WeatherResult) -> Void) {
        requestedURL = url
    }
}

class CurrentWeatherLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = WeatherLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = WeatherLoader(client: client)
        
        sut.loadCurrentWeather()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
