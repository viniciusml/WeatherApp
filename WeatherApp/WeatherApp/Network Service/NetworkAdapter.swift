//
//  NetworkAdapter.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

typealias WeatherResult = Result<HTTPURLResponse, Error>

protocol NetworkAdapter {
    func load(from url: URL, completion: @escaping (WeatherResult) -> Void)
}
