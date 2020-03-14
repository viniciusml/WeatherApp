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
    
    let itemJSON: [String: Any] = [
        "coord": [ "lon": 139,"lat": 35 ],
          "weather": [
            [
              "id": 800,
              "main": "Clear",
              "description": "clear sky",
              "icon": "01n"
            ]
          ],
          "base": "stations",
          "main": [
            "temp": 281.52,
            "feels_like": 278.99,
            "temp_min": 280.15,
            "temp_max": 283.71,
            "pressure": 1016,
            "humidity": 93
          ],
          "wind": [
            "speed": 0.47,
            "deg": 107.538
          ],
          "clouds": [
            "all": 2
          ],
          "dt": 1560350192,
          "sys": [
            "type": 3,
            "id": 2019346,
            "message": 0.0065,
            "country": "JP",
            "sunrise": 1560281377,
            "sunset": 1560333478
          ],
          "timezone": 32400,
          "id": 1851632,
          "name": "Shuzenji",
          "cod": 200
    ]
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "http:a-given-url.com")!
        let (_, client) = makeSUT(url: url)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http:a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadCurrentWeather { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadsTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http:a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadCurrentWeather { _ in }
        sut.loadCurrentWeather { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 400, 300, 500]
                
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let jsonData = try! JSONSerialization.data(withJSONObject: itemJSON)
                client.complete(withStatusCode: code, data: jsonData, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("Invalid Json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        let item = WeatherItem(coord: Coord(lon: 139, lat: 35), weather: [Weather(main: "Clear", description: "clear sky")], main: Main(temp: 281.52), name: "Shuzenji")
        
        expect(sut, toCompleteWith: .success(item), when: {
            let jsonData = try! JSONSerialization.data(withJSONObject: itemJSON)
            client.complete(withStatusCode: 200, data: jsonData)
        })
    }
    
    // MARK: - Helpers
        
    private func makeSUT(url: URL = URL(string: "http:a-given-url.com")!) -> (sut: WeatherLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = WeatherLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: WeatherLoader, toCompleteWith result: WeatherLoader.WeatherResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [WeatherLoader.WeatherResult]()
        sut.loadCurrentWeather { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: NetworkAdapter {
        
        var messages = [(url: URL, completion: (HTTPResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func load(from url: URL, completion: @escaping (HTTPResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}
