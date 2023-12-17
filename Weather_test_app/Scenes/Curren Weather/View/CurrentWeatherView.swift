//
//  CurrentWeatherView.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 9.12.23.
//

import Foundation
import UIKit

final class CurrentWeatherView: UIView {
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var mainWeatherLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.alpha = 0.5
        return view
    }()
    private lazy var mainBlock: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()
    
    private lazy var tempLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 90, weight: .ultraLight)
        view.textAlignment = .center
        return view
    }()
    private lazy var fellsTempLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .center
        view.alpha = 0.5
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        setupMainBlock()
        setupTempView()
    }
    
    private func setupMainBlock() {
        addSubview(mainBlock)
        mainBlock.addArrangedSubview(icon)
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(mainWeatherLabel)
        stackView.addArrangedSubview(descriptionLabel)
        mainBlock.addArrangedSubview(stackView)
    }
    
    private func setupTempView() {
        addSubview(tempLabel)
        addSubview(fellsTempLabel)
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor, multiplier: 1/1),
            mainBlock.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: mainBlock.bottomAnchor),
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            fellsTempLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 5),
            fellsTempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            fellsTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupContent(content: CurrenWeatherRequest) {
        let localizable = "ºF".localized()
        tempLabel.text = "\(Int(content.main.temp))\(localizable)"
        fellsTempLabel.text = "Feels like".localized() + " \(Int(content.main.feelsLike))\(localizable)"
        mainWeatherLabel.text = content.weather.first?.main
        descriptionLabel.text = content.weather.first?.description
        let url = URL(string: "https://openweathermap.org/img/w/\(content.weather.first!.icon).png")!
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error -> Void in
              guard let data = data , error == nil, let image = UIImage(data: data) else { return }
              DispatchQueue.main.async { 
                  self.icon.image = image
              }
            }).resume()
    }
    
}
