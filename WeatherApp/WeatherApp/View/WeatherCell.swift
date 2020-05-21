//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 16/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var currentWeather: WeatherItem? {
        didSet {
            temperatureLabel.text = currentWeather?.main.temp.description
            weatherDescriptionLabel.text = currentWeather?.weather.first?.description.capitalized
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherCell: CodeView {

    func buildViewHierarchy() {
        layer.cornerRadius = 20
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0

        addSubview(temperatureLabel)
        addSubview(weatherDescriptionLabel)
    }

    func setupConstraints() {
        temperatureLabel.anchor(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0),
            size: CGSize(width: 80, height: 80))

        weatherDescriptionLabel.anchor(
            top: nil,
            leading: nil,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10))
    }
}
