//
//  CurrentWeatherLoaderTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import WeatherApp

class CurrentWeatherLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "http:a-given-url.com")!
        let (_, client) = makeSUT(url: url)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http:a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadCurrentWeather()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadsTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http:a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadCurrentWeather()
        sut.loadCurrentWeather()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [WeatherLoader.Error]()
        sut.loadCurrentWeather { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http:a-given-url.com")!) -> (sut: WeatherLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = WeatherLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: NetworkAdapter {
        
        var messages = [(url: URL, completion: (WeatherResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func load(from url: URL, completion: @escaping (WeatherResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
}
