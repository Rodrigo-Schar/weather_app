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
    var searchList: [list] = []
    
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
        self.searchList.removeAll()
        self.searchTableView.reloadData()
    }
    
    func getWeatherData(withText: String){
        guard let url = URL(string:UrlManager.instance.urlWeather(text: withText)) else { return }
        SVProgressHUD.show()
        
        NetworkManager.shared.get(WeatherModel.self, from: url) { result in
            switch result {
                case .success(let data):
                    self.searchList = data.list
                    if(self.searchList.count == 0){
                        SVProgressHUD.dismiss()
                        self.searchList.removeAll()
                        self.searchTableView.reloadData()
                        let alert = AlertManager.instance.showAlert(title: "Error", message: "The text searched is not valid")
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.searchTableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                case .failure(let error):
                    print(error)
                let alert = AlertManager.instance.showAlert(title: "Error", message: error.localizedDescription)
                    SVProgressHUD.dismiss()
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
        let context = CoreDataManager.shared.getContext()
        
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
    
    func checkHistory(withIndex: Int, withName: String){
        let context = CoreDataManager.shared.getContext()
        let fetchRequest = NSFetchRequest<WeatherHistory>(entityName: "WeatherHistory")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", argumentArray:["name", withName, "positionList", withIndex])

        do {
            let results = try context.fetch(fetchRequest)
            if (results.count == 0){
                self.saveHistory(withIndex: withIndex, withName: withName)
            } else {
                print("There is an existing object")
            }
        }catch let error {
            print("Error....: \(error)")
        }
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
        cell.temperatureLabel.text = "\(self.convertToCelsius(temp: temperature.temp))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Detail = HistoryDetailViewController()
        let list = searchList[indexPath.row]
        Detail.listDetail = list
        
        checkHistory(withIndex: indexPath.row, withName: list.name)
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
