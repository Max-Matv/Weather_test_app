//
//  DayForecatsItem.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 13.12.23.
//

import Foundation
import UIKit

final class DayForecatsItem: UIView {
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tempLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var conditionImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupContent(content: [List]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: content.first!.dtTxt)
        dateFormatter.dateFormat = "yyy-MM-dd"
        dateLabel.text = dateFormatter.string(from: date!)
        tempLabel.text = "\(Int((content.first?.main.temp)!))" + " / " + "\(Int((content.last?.main.temp)!))" + "ºF".localized()
        let url = URL(string: "https://openweathermap.org/img/w/\(content.first!.weather.first!.icon).png")!
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error -> Void in
              guard let data = data , error == nil, let image = UIImage(data: data) else { return }
              DispatchQueue.main.async { 
                  self.conditionImage.image = image
              }
            }).resume()
    }
    
    private func setupView() {
        addSubview(dateLabel)
        addSubview(tempLabel)
        addSubview(conditionImage)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            conditionImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            conditionImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            conditionImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            conditionImage.widthAnchor.constraint(equalTo: conditionImage.heightAnchor, multiplier: 1/1),
            tempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            tempLabel.trailingAnchor.constraint(equalTo: conditionImage.leadingAnchor, constant: -3),
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        let seporator = UIView()
        seporator.translatesAutoresizingMaskIntoConstraints = false
        seporator.backgroundColor = .black
        addSubview(seporator)
        NSLayoutConstraint.activate([
            seporator.heightAnchor.constraint(equalToConstant: 1),
            seporator.bottomAnchor.constraint(equalTo: bottomAnchor),
            seporator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            seporator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3)
        ])
    }
    
}
