//
//  WeatherLoader.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

class WeatherLoader {
    let client: NetworkAdapter
    let url: URL
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias WeatherResult = Result<WeatherItem, Error>
    
    init(url: URL, client: NetworkAdapter) {
        self.client = client
        self.url = url
    }
    
    func loadCurrentWeather(completion: @escaping (WeatherResult) -> Void) {
        client.load(from: url) { result in
            switch result {
            case .success:
                completion(.failure(.invalidData))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
