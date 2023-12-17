//
//  TopBarView.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 8.12.23.
//

import Foundation
import UIKit

protocol TopBarViewDelegate: AnyObject {
    func searchButtonPressed()
}

final class TopBarView: UIView {
    
    weak var delegate: TopBarViewDelegate?
    
    private lazy var iconButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        view.tintColor = .black
        return view
    }()
    private lazy var cityInfoLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var timeIntervalLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.alpha = 0.5
        view.isHidden = true
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
        addSubview(iconButton)
        addSubview(cityInfoLabel)
        addSubview(timeIntervalLabel)
        NSLayoutConstraint.activate([
            iconButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            iconButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconButton.widthAnchor.constraint(equalTo: iconButton.heightAnchor, multiplier: 1/1),
            iconButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            cityInfoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cityInfoLabel.leadingAnchor.constraint(equalTo: iconButton.trailingAnchor, constant: 10),
            cityInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            cityInfoLabel.trailingAnchor.constraint(equalTo: timeIntervalLabel.leadingAnchor, constant: -10),
            timeIntervalLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timeIntervalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            timeIntervalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        iconButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    @objc
    private func buttonPressed(_ sender: UIButton) {
        delegate?.searchButtonPressed()
    }
    
    func setupLabel(label: String) {
        cityInfoLabel.text = label
    }
    func setupIntervalLabel(label: String) {
        timeIntervalLabel.text = label
        timeIntervalLabel.isHidden = false
    }
}
