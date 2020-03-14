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
    
    init(url: URL, client: NetworkAdapter) {
        self.client = client
        self.url = url
    }
    
    func loadCurrentWeather(completion: @escaping (Error) -> Void) {
        client.load(from: url) { error, response in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
        }
    }
}
