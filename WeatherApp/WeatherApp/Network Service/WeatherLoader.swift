//
//  WeatherLoader.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

typealias WeatherResult = Result<WeatherItem, WeatherLoader.Error>

class WeatherLoader {
    let client: NetworkAdapter
    let url: String
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: String, client: NetworkAdapter) {
        self.client = client
        self.url = url
    }
    
    func loadCurrentWeather(parameters: Coordinate? = nil, completion: @escaping (WeatherResult) -> Void) {
        client.load(parameters: parameters, from: url) { result in
            switch result {
            case let .success(value):
                let (data, response) = value
                if response.statusCode == 200, let item = try? JSONDecoder().decode(WeatherItem.self, from: data) {
                    completion(.success(item))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
