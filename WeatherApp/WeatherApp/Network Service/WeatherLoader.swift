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
    
    init(url: URL, client: NetworkAdapter) {
        self.client = client
        self.url = url
    }
    
    func loadCurrentWeather() {
        client.load(from: url) { _ in }
    }
}
