//
//  ViewController.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 8.12.23.
//

import UIKit
import CoreLocation

protocol CurrentWeatherControllerProtocol: AnyObject {
    func weatherRequest(weather: WeatherRequest)
    func currentWeatherRequest(weather: CurrenWeatherRequest)
}

final class CurrentWeatherViewController: UIViewController {
    //MARK: - View Model
    var viewModel: CurrentWeatherProtocol?
    // MARK: - Properties
    private var locationManager = CLLocationManager()
    private var isCoordinatesDetermined: Bool = false
    private var hourWeather = [List]() {
        didSet {
            collectionView.reloadData()
        }
    }
    // MARK: - Views
    private lazy var topBarView: TopBarView = {
        let view = TopBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    private lazy var currentWeatherView: CurrentWeatherView = {
        let view = CurrentWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var additionalInfoView: AdditionalInfoView = {
        let view = AdditionalInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dayForecastView: DayForecastView = {
        let view = DayForecastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewController()
    }
    //MARK: - Setup View Controller
    private func setupViewController() {
        setupCurrentLocation()
        setupTopBar()
        setupScrollView()
        setupStackView()
        setupCollectionView()
    }
    //MARK: - Setup Scroll View
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    //MARK: - Setup Stack View
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(currentWeatherView)
        stackView.addArrangedSubview(additionalInfoView)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(dayForecastView)
        stackView.spacing = 10
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            additionalInfoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    //MARK: - Setup Top Bar
    private func setupTopBar() {
        view.addSubview(topBarView)
        topBarView.delegate = self
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    //MARK: - Setup Location
    private func setupCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 1000
    }
    //MARK: - Setup Collection View
    private func setupCollectionView() {
        collectionView.register(UIHourCollectionViewCell.self, forCellWithReuseIdentifier: UIHourCollectionViewCell.reuseIdentifire)
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 120),
            collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

}
//MARK: - View Model Methods
extension CurrentWeatherViewController: CurrentWeatherControllerProtocol {
    func currentWeatherRequest(weather: CurrenWeatherRequest) {
        currentWeatherView.setupContent(content: weather)
        additionalInfoView.setupContent(content: weather)
    }
    
    func weatherRequest(weather: WeatherRequest) {
        topBarView.setupLabel(label: weather.city.name)
        hourWeather = (viewModel?.getCurrentDay())!
        dayForecastView.setupContent(content: (viewModel?.getSortedArrayByDay())!)
        if !NetworkMonitor.shared.isConnected {
            topBarView.setupIntervalLabel(label: (viewModel?.getInterval())!)
        }
    }
    
}
//MARK: - CLLocation Delegate Methods
extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let coordinates = locations.last?.coordinate else { return }
        if NetworkMonitor.shared.isConnected {
            viewModel?.addWeatherRequest(lat: coordinates.latitude, lon: coordinates.longitude)
            viewModel?.addCurrentWeatherRequest(lat: coordinates.latitude, lon: coordinates.longitude)
        } else {
            viewModel?.getOfflineData()
        }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status != .notDetermined,
               status != .denied,
               status != .restricted {
                manager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error.localizedDescription)
        }
}
//MARK: - Collection View Delegate Methods
extension CurrentWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourWeather.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIHourCollectionViewCell.reuseIdentifire, for: indexPath) as? UIHourCollectionViewCell else { fatalError() }
        cell.setupCell(content: hourWeather[indexPath.row])
        return cell
    }
    
}

extension CurrentWeatherViewController: TopBarViewDelegate {
    func searchButtonPressed() {
        let cityListViewController = CityListViewController()
        cityListViewController.viewModel = CityListViewModel(viewController: cityListViewController)
        cityListViewController.modalPresentationStyle = .fullScreen
        present(cityListViewController, animated: true)
    }
    
}

