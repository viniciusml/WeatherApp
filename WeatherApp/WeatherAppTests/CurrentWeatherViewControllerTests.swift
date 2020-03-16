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
        let sut = makeSUT()
        
        XCTAssertEqual(sut.headerLabel.text, "Weather App")
    }
    
    func test_withLocationFetched_displaysOption() {
        let sut = makeSUT()
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), sut.locations.count)
    }
    
    func test_withLocationFetched_displaysOptionName() {
        let sut = makeSUT()

        let cell = sut.tableView.cell(at: 0) as? WeatherCell

        XCTAssertEqual(cell?.cityNameLabel?.text, sut.currentWeather?.name)
    }
    
    func test_withLocationFetched_displaysOptionTemperatureAndWeather() {
        let sut = makeSUT()

        let cell = sut.tableView.cell(at: 0) as? WeatherCell

        XCTAssertEqual(cell?.temperatureLabel.text, sut.currentWeather?.main.temp.description)
        XCTAssertEqual(cell?.weatherLabel.text, sut.currentWeather?.weather.first?.main)
        XCTAssertEqual(cell?.weatherDescriptionLabel.text, sut.currentWeather?.weather.first?.description)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> CurrentWeatherViewController {
        let storyboard = UIStoryboard(name: "CurrentWeather", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        controller?.loadViewIfNeeded()
        return controller as! CurrentWeatherViewController
    }
}

private extension UITableView {
    func cell(at row: Int) -> UITableViewCell? {
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }
}
