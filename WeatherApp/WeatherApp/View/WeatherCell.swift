//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 16/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    var cityNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
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
            cityNameLabel.text = currentWeather?.name
            temperatureLabel.text = currentWeather?.main.temp.description
            weatherDescriptionLabel.text = currentWeather?.weather.first?.description.capitalized
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(temperatureLabel)
        temperatureLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, size: CGSize(width: 80, height: 80))
        
        let hStack = HorizontalStackView(arrangedSubviews: [cityNameLabel, weatherDescriptionLabel], alignment: .fill)
        addSubview(hStack)
        hStack.anchor(top: temperatureLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
}
