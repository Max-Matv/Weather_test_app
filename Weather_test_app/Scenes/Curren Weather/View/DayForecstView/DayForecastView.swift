//
//  DayForecastView.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 13.12.23.
//

import Foundation
import UIKit

final class DayForecastView: UIView {
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupContent(content: [[List]]) {
        content.forEach { arr in
            let view = DayForecatsItem()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setupContent(content: arr)
            stackView.addArrangedSubview(view)
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
    
    private func setupView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
