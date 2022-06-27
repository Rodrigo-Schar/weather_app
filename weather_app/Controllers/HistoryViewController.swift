//
//  HistoryViewController.swift
//  weather_app
//
//  Created by admin on 6/23/22.
//

import UIKit
import CoreData
import Photos
import SVProgressHUD

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    var viewModel = WeatherViewModel()
    var viewModelHistory = WeatherHistoryViewModel()
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
        viewModelHistory.loadData() {
            self.historyTableView.reloadData()
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
        return viewModelHistory.numberOfItemsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryTableViewCell ?? HistoryTableViewCell()
        
        let histo = viewModelHistory.getWeatherHistoryBy(index: indexPath.row)
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
        let history = viewModelHistory.getWeatherHistoryBy(index: indexPath.row)
        
        guard let text = history.name else { return }
        let index = Int(history.positionList)
        viewModel.getWeatherData(withText: text) {
            self.gotoDetail(withhistory: self.viewModel.getWeatherBy(index: index))
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let history = viewModelHistory.getWeatherHistoryBy(index: indexPath.row)
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in success(true)
            let dialogMessage = UIAlertController(title: "Delete", message: "Are you sure you want to delete this history?", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                self.viewModelHistory.deleteHistory(withObject: history, withIndex: indexPath) {
                    let index = IndexPath(row: indexPath.row, section: 0)
                    self.historyTableView.deleteRows(at: [index], with: .automatic)
                }
            })
                
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Canceled")
            }
                
            dialogMessage.addAction(confirm)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        })
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}
