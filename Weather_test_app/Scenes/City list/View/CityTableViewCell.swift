//
//  CityTableViewCell.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 16.12.23.
//

import UIKit

final class CityTableViewCell: UITableViewCell {
    
    //MARK: - Views
    private lazy var cityLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        return view
    }()
    private lazy var tempLable: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        return view
    }()
    private lazy var conditionImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setupView() {
        addSubview(cityLabel)
        addSubview(tempLable)
        addSubview(conditionImage)
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            tempLable.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            tempLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            conditionImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            conditionImage.leadingAnchor.constraint(equalTo: tempLable.trailingAnchor, constant: 5),
            conditionImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            conditionImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            conditionImage.heightAnchor.constraint(equalTo: conditionImage.widthAnchor, multiplier: 1/1)
        ])
    }
    func setupCell(content: CurrenWeatherRequest) {
        cityLabel.text = content.name
        tempLable.text = String(content.main.temp) + "ºF".localized()
        let url = URL(string: "https://openweathermap.org/img/w/\(content.weather.first!.icon).png")!
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error -> Void in
              guard let data = data , error == nil, let image = UIImage(data: data) else { return }
              DispatchQueue.main.async {
                  self.conditionImage.image = image
              }
            }).resume()
    }
    
}
