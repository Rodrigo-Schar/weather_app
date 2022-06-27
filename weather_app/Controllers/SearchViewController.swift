//
//  SearchViewController.swift
//  weather_app
//
//  Created by admin on 6/22/22.
//

import UIKit
import CoreData
import SVProgressHUD

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    var viewModel = WeatherViewModel()
    var viewModelHistory = WeatherHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        let uiNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(uiNib, forCellReuseIdentifier: "WeatherCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.searchBar.text = ""
        viewModel.removeListElements()
        self.searchTableView.reloadData()
    }
    
    func convertToCelsius(temp: Double) -> String {
        let celsius = temp  - 273.15
        let result  = "\(String(format: "%.2f", celsius)) C°"
        return result
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? SearchTableViewCell ?? SearchTableViewCell()
        let list = viewModel.getWeatherBy(index: indexPath.row)
        let weather = list.weather[0]
        let temperature = list.main
        
        cell.weatherImageView.image = viewModel.getWeatherImage(withUrl: weather.icon)
        cell.placeLabel.text = list.name
        cell.weatherLabel.text = weather.description
        cell.temperatureLabel.text = "\(self.convertToCelsius(temp: temperature.temp))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Detail = HistoryDetailViewController()
        let list = viewModel.getWeatherBy(index: indexPath.row)
        Detail.listDetail = list
        
        viewModelHistory.checkHistory(withIndex: indexPath.row, withName: list.name)
        show(Detail, sender: nil)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        viewModel.getWeatherData(withText: text) {
            self.searchTableView.reloadData()
            if self.viewModel.numberOfItemsInSection == 0 {
                let alert = AlertManager.instance.showAlert(title: "Error", message: "The text searched is not valid")
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.removeListElements()
        searchTableView.reloadData()
        self.view.endEditing(true)
    }
}
