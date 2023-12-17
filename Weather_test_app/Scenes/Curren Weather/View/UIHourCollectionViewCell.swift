//
//  UIHourCollectionViewCell.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 13.12.23.
//

import Foundation
import UIKit

final class UIHourCollectionViewCell: UICollectionViewCell {
    
    private let fontSize: CGFloat = 14
    //MARK: - VIews
    private lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: fontSize)
        view.alpha = 0.5
        view.textAlignment = .center
        return view
    }()
    
    private lazy var conditionImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tempLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: fontSize)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    //MARK: - Setup Cell
    func setupCell(content: List) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter.date(from: content.dtTxt)
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: time!)
        let url = URL(string: "https://openweathermap.org/img/w/\(content.weather.first!.icon).png")!
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error -> Void in
              guard let data = data , error == nil, let image = UIImage(data: data) else { return }
              DispatchQueue.main.async { 
                  self.conditionImage.image = image
              }
            }).resume()
        tempLabel.text = "\(Int(content.main.temp))" + "ºF".localized()
    }
    
    private func setupView() {
        addSubview(timeLabel)
        addSubview(conditionImage)
        addSubview(tempLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            conditionImage.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            conditionImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            conditionImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            conditionImage.widthAnchor.constraint(equalTo: conditionImage.heightAnchor, multiplier: 1/1),
            tempLabel.topAnchor.constraint(equalTo: conditionImage.bottomAnchor, constant: 5),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
