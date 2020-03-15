//
//  LocationProvider.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

protocol LocationProvider {
    var isAuthorized: Bool { get }
    func requestWhenInUseAuthorization()
    func requestLocation()
}
