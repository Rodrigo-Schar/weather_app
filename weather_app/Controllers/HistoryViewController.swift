//
//  HistoryViewController.swift
//  weather_app
//
//  Created by admin on 6/23/22.
//

import UIKit
import CoreData
import Photos

class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var historyTableView: UITableView!
    var history = [WeatherHistory]()
    var historyList: [list] = []
    var availableAssets: PHFetchResult<PHAsset>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        let uiNib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        historyTableView.register(uiNib, forCellReuseIdentifier: "HistoryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<WeatherHistory>
        fetchRequest = WeatherHistory.fetchRequest()

        do {
            history = try context.fetch(fetchRequest)
            history = history.sorted(by: { $0.date?.compare($1.date!) == .orderedDescending })
            historyTableView.reloadData()
        } catch(let err) {
            print("Error", err)
        }
    }
    
    func getWeatherData(withText: String, withIndex: Int) {
        
        guard let url = URL(string:UrlManager.instance.urlWeather(text: withText)) else { return }
        
        NetworkManager.shared.get(WeatherModel.self, from: url) { result in
            switch result {
                case .success(let data):
                    self.historyList = data.list
                    self.gotoDetail(withhistory: self.historyList[withIndex])
                case .failure(let error):
                    print(error)
                    let alert = AlertManager.instance.showAlert(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func gotoDetail(withhistory: list){
        let Detail = HistoryDetailViewController()
        
        Detail.listDetail = withhistory
        show(Detail, sender: nil)
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryTableViewCell ?? HistoryTableViewCell()
        
        let histo = history[indexPath.row]
        cell.nameLabel.text = histo.name
        
        if let datefor = histo.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            let newdate = dateFormatter.string(from: datefor)
            cell.dateLabel.text = newdate
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = history[indexPath.row]
        //let Detail = HistoryDetailViewController()
        
        guard let name = history.name else { return }
        let index = Int(history.positionList)
        getWeatherData(withText: name, withIndex: index)
        //Detail.listDetail = historyList[index]
        //show(Detail, sender: nil)
    }
    
    
}
