//
//  AdditionalInfoView.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 9.12.23.
//

import Foundation
import UIKit

final class AdditionalInfoView: UIView {
    
    private let fontSize: CGFloat = 12
    
    private lazy var windLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: fontSize)
        return view
    }()
    private lazy var pressureLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: fontSize)
        return view
    }()
    private lazy var humidityLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: fontSize)
        return view
    }()
    private lazy var visibilityLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: fontSize)
        return view
    }()
    private lazy var uvIndexLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: fontSize)
        return view
    }()
    private lazy var dewPointsLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: fontSize)
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
        let mainStackView = UIStackView()
        mainStackView.backgroundColor = .lightGray
        mainStackView.layer.cornerRadius = 6
        mainStackView.spacing = 5
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fillProportionally
        mainStackView.layoutMargins = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        let firstColumn = UIStackView()
        firstColumn.backgroundColor = .clear
        firstColumn.translatesAutoresizingMaskIntoConstraints = false
        firstColumn.axis = .vertical
        firstColumn.spacing = 10
        firstColumn.addArrangedSubview(windLabel)
        firstColumn.addArrangedSubview(pressureLabel)
        mainStackView.addArrangedSubview(firstColumn)
        let secondColumn = UIStackView()
        secondColumn.backgroundColor = .clear
        secondColumn.translatesAutoresizingMaskIntoConstraints = false
        secondColumn.axis = .vertical
        secondColumn.spacing = 10
        secondColumn.addArrangedSubview(humidityLabel)
        secondColumn.addArrangedSubview(visibilityLabel)
        mainStackView.addArrangedSubview(secondColumn)
        let thirdColumn = UIStackView()
        thirdColumn.backgroundColor = .clear
        thirdColumn.translatesAutoresizingMaskIntoConstraints = false
        thirdColumn.axis = .vertical
        thirdColumn.spacing = 10
        thirdColumn.addArrangedSubview(uvIndexLabel)
        thirdColumn.addArrangedSubview(dewPointsLabel)
        mainStackView.addArrangedSubview(thirdColumn)
        
    }
    
    func setupContent(content: CurrenWeatherRequest) {
        windLabel.text = "Wind: \(content.wind.speed)m/s"
        pressureLabel.text = "Pressure: \(content.main.pressure)hPa"
        humidityLabel.text = "Humidity: \(content.main.humidity)%"
        visibilityLabel.text = "Visibility: \(content.visibility)km"
        uvIndexLabel.text = "UV index: 0.4"
        dewPointsLabel.text = "Dew point: \(content.main.temp)"
    }
}
