//
//  CurrentWeatherLoaderTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import WeatherApp

class RemoteLoaderTests: XCTestCase {
    
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

    // MARK: - General Tests

    func test_init_doesNotRequestDataFromURL() {
        let url = "http:a-given-url.com"
        let (_, client) = makeSUT(url: url)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = "http:a-given-url.com"
        let (sut, client) = makeSUT(url: url)
        
        sut.load(String.self) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadsTwice_requestsDataFromURLTwice() {
        let url = "http:a-given-url.com"
        let (sut, client) = makeSUT(url: url)

        sut.load(String.self) { _ in }
        sut.load(String.self) { _ in }

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

    func test_load_usesCoordinateAsParameters() {
        let (sut, client) = makeSUT()

        let coordinates = Coordinate(latitude: 55.75578600, longitude: 37.61763300)
        sut.load(String.self, parameters: coordinates) { _ in }

        XCTAssertEqual(client.receivedParameters?.latitude, coordinates.latitude)
        XCTAssertEqual(client.receivedParameters?.longitude, coordinates.longitude)
    }

    // MARK: - Weather Item Decoding Tests
    
    func test_load_weatherItem_deliversItemsOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()
        
        let item = WeatherItem(coord: Coord(lon: 139, lat: 35), weather: [Weather(main: "Clear", description: "clear sky")], main: Main(temp: 281.52), name: "Shuzenji")
        
        expect(sut, toCompleteWith: .success(item), when: {
            let jsonData = try! JSONSerialization.data(withJSONObject: itemJSON)
            client.complete(withStatusCode: 200, data: jsonData)
        })
    }
    
    // MARK: - Helpers
        
    private func makeSUT(url: String = "http:a-given-url.com") -> (sut: RemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteLoader, toCompleteWith result: WeatherResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [WeatherResult]()
        sut.load(WeatherItem.self) { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
}
