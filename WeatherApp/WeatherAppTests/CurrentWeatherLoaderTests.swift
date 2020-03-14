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
    let url: URL
    
    init(url: URL, client: NetworkAdapter) {
        self.client = client
        self.url = url
    }
    
    func loadCurrentWeather() {
        client.load(from: url) { _ in }
    }
}

class HTTPClient {
    var requestedURL: URL?
    
    func load() {
        
    }
}

class CurrentWeatherLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "http:a-given-url.com")!
        let (_, client) = makeSUT(url: url)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "http:a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadCurrentWeather()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http:a-given-url.com")!) -> (sut: WeatherLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = WeatherLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: NetworkAdapter {

        var requestedURL: URL?
        
        func load(from url: URL, completion: @escaping (WeatherResult) -> Void) {
            requestedURL = url
        }
    }
}
