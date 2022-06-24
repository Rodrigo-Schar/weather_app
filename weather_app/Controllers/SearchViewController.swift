//
//  SearchViewController.swift
//  weather_app
//
//  Created by admin on 6/22/22.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    var searchList: [list] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        let uiNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(uiNib, forCellReuseIdentifier: "WeatherCell")
    }
    
    func getWeatherData(withText: String){
        guard let url = URL(string:UrlManager.instance.urlWeather(text: withText)) else { return }
        
        NetworkManager.shared.get(WeatherModel.self, from: url) { result in
            switch result {
                case .success(let data):
                    self.searchList = data.list
                    self.searchTableView.reloadData()
                case .failure(let error):
                    print(error)
                    let alert = AlertManager.instance.showAlert(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getWeatherImage(withUrl: String) -> UIImage? {
        let url = URL(string:UrlManager.instance.urlWeatherImage(text: withUrl))
        let image = ImageManager.instance.readUrl(urlStr: url!)
        return image
    }
    
    func saveHistory(withIndex: Int, withName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "WeatherHistory", in: context) else { return }
        guard let history = NSManagedObject(entity: entity, insertInto: context) as? WeatherHistory else { return }
        
        history.id = Int16.random(in: 1...1000)
        history.name = withName
        history.positionList = Int16(withIndex)
        history.date = Date()
        
        do {
            try context.save()
            print("done")
            
        } catch(let err) {
            print("Error", err)
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? SearchTableViewCell ?? SearchTableViewCell()
        let list = searchList[indexPath.row]
        let weather = searchList[indexPath.row].weather[0]
        let temperature = searchList[indexPath.row].main
        
        cell.weatherImageView.image = getWeatherImage(withUrl: weather.icon)
        cell.placeLabel.text = list.name
        cell.weatherLabel.text = weather.description
        cell.temperatureLabel.text = "\(temperature.temp) K"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Detail = HistoryDetailViewController()
        let list = searchList[indexPath.row]
        Detail.listDetail = list
        
        saveHistory(withIndex: indexPath.row, withName: list.name)
        show(Detail, sender: nil)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        getWeatherData(withText: text)
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchList.removeAll()
        searchTableView.reloadData()
        self.view.endEditing(true)
    }
}
