//
//  CLLocationManagerSpy.swift
//  WeatherAppTests
//
//  Created by Vinicius Leal on 02/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import CoreLocation
import WeatherApp

extension CLLocationManager {
    static var spy: Spy { Spy() }
    static var authorizedSpy: Spy { AuthorizedSpy() }

    class Spy: CLLocationManager {
        private(set) var authorizationRequestCount = 0
        private(set) var locationRequestCount = 0

        override func requestWhenInUseAuthorization() {
            authorizationRequestCount += 1
        }

        override func requestLocation() {
            locationRequestCount += 1
        }
    }

    class AuthorizedSpy: Spy {
        override func needsAuthorizationRequest() -> Bool { false }
    }
}
