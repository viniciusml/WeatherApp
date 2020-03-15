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
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), sut.locations.count)
    }
    
//    func test_withLocationFetched_displaysOptionName() {
//        let sut = CurrentWeatherViewController()
//        
//        _ = sut.view
//        
//        let indexPath = IndexPath(row: 0, section: 0)
//        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
//        
//        XCTAssertEqual(cell?.textLabel?.text, sut.locations.count)
//    }
}
