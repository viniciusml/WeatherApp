//
//  CurrentWeatherViewControllerTests.swift
//  WeatherAppTests
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
@testable import WeatherApp

class CurrentWeatherViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_displaysHeaderText() {
        let sut = CurrentWeatherViewController()
        
        _ = sut.view
        
        XCTAssertEqual(sut.headerLabel.text, "Weather App")
    }
    
    func test_withLocationFetched_displaysOption() {
        let sut = CurrentWeatherViewController()
        
        _ = sut.view
        sut.getLocation()
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), sut.locations.count)
    }
}
