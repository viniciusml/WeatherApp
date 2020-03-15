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
    
    func test_withNoLocation_displaysZeroOptions() {
        let sut = CurrentWeatherViewController()
        
        _ = sut.view
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
}
