//
//  NetworkAdapter.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 14/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

typealias HTTPResult = Result<(Data, HTTPURLResponse), Error>

protocol NetworkAdapter {
    func load(parameters: Coordinate?, from url: String, completion: @escaping (HTTPResult) -> Void)
}
