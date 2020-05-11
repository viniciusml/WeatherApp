//
//  MainWeatherView.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 11/05/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class MainWeatherView: UIView {

    var cityLabel: UILabel = {
        return make(UILabel()) {
            $0.textAlignment = .center
        }
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return make(UICollectionView(frame: .zero, collectionViewLayout: layout)) {
            $0.backgroundColor = .appBackground
            $0.delegate = self
            $0.dataSource = self
            $0.register(WeatherCell.self)
        }
    }()

    var locations = [UserLocation]()

    var currentWeather: WeatherItem? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(locations: [UserLocation], currentWeather: WeatherItem?) {
        self.currentWeather = currentWeather
        self.locations = locations

        cityLabel.text = currentWeather?.name
        collectionView.reloadData()
    }
}

extension MainWeatherView: CodeView {

    func buildViewHierarchy() {
        addSubview(cityLabel)
        addSubview(collectionView)
    }

    func setupConstraints() {
        cityLabel.anchor(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: nil,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 80, left: 20, bottom: 0, right: 20),
            size: CGSize(width: 0, height: 80))

        collectionView.anchor(
            top: cityLabel.bottomAnchor,
            leading: self.leadingAnchor,
            bottom: nil,
            trailing: self.trailingAnchor,
            size: CGSize(width: 0, height: 200))
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .appBackground
    }

}

extension MainWeatherView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(WeatherCell.self, for: indexPath)!
        cell.currentWeather = currentWeather
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: frame.width - 50, height: 200)
    }
}
