//
//  CityListViewController.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 15.12.23.
//

import Foundation
import UIKit

protocol CityListControllerProtocol: AnyObject {
    func weatherRequest(list: [CurrenWeatherRequest])
}


final class CityListViewController: UIViewController {
    //MARK: - View Model
    var viewModel: CityListProtocol?
    //MARK: - Properties
    private var favoriteCityList: [CurrenWeatherRequest] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var filteredData: [CurrenWeatherRequest] = []
    private var searchBarIsEmpty: Bool {
            guard let text = searchBar.text else { return false }
            return text.isEmpty
        }
    private var isFiltering: Bool {
            return searchBar.isUserInteractionEnabled && !searchBarIsEmpty
        }
    //MARK: - Views
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchFieldBackgroundImage(for: .normal)
        view.backgroundImage = UIImage()
        view.placeholder = "Search"
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .black
        return view
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewController()
        viewModel?.preseting(list: CoreDataManager.shared.fetchCitys())
    }
    
    //MARK: - Setup view controller
    private func setupViewController() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            searchBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 5),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            cancelButton.widthAnchor.constraint(equalTo: cancelButton.heightAnchor, multiplier: 1/1),
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.reuseIdentifire)
        cancelButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - Filter content for text
        private func filterContentForSearchText(_ searchText: String) {
            filteredData = favoriteCityList.filter({ (weather: CurrenWeatherRequest) -> Bool in
                return weather.name.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
}

extension CityListViewController: CityListControllerProtocol {
    func weatherRequest(list: [CurrenWeatherRequest]) {
        favoriteCityList = list
    }
    
   
}
extension CityListViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel?.addCurrentRequestForName(name: text, completition: { data, error in
            DispatchQueue.main.async {
                let controller = PopoverViewController()
                controller.modalPresentationStyle = .popover
                let popoverVc = controller.popoverPresentationController
                popoverVc?.delegate = self
                popoverVc?.sourceView = searchBar
                popoverVc?.sourceRect = CGRect(x: searchBar.bounds.midX, y: searchBar.bounds.midY, width: 0, height: 0)
                controller.preferredContentSize = CGSize(width: searchBar.frame.width, height: searchBar.frame.height)
                controller.data = data
                controller.completition = { data in
                    self.searchBar.text = .none
                    self.searchBar.endEditing(true)
                    self.favoriteCityList.append(data)
                    CoreDataManager.shared.createCity(name: data.name, lat: data.coord.lat, lon: data.coord.lon)
                }
                self.present(controller, animated: true)
            }
        })
    }
    
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredData.count : favoriteCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifire, for: indexPath) as? CityTableViewCell else { fatalError() }
        var weather: CurrenWeatherRequest
        weather = isFiltering ? filteredData[indexPath.row] : favoriteCityList[indexPath.row]
        cell.setupCell(content: weather)
        return cell
    }
    
    
}

