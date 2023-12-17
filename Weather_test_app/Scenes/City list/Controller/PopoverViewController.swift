//
//  PopoverViewController.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 17.12.23.
//

import Foundation
import UIKit

final class PopoverViewController: UIViewController {
    var completition: (CurrenWeatherRequest) -> Void = {_ in }
    var data: CurrenWeatherRequest?
    
    private lazy var cityLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tempLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.red, for: .normal)
        view.setTitle("Add", for: .normal)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupData()
        setupButton()
    }
    
    
    private func setupController() {
        view.addSubview(cityLabel)
        view.addSubview(tempLabel)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cityLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            tempLabel.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 10),
            tempLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tempLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupData() {
        guard let data = data else { return }
        cityLabel.text = data.name
        tempLabel.text = "\(data.main.temp)" + "ºF".localized()
    }
    
    private func setupButton() {
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    @objc
    private func addButtonPressed(_ sender: UIButton) {
        guard let data = data else { return }
        completition(data)
        dismiss(animated: true)
    }
}
