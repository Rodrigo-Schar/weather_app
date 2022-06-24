//
//  HistoryDetailViewController.swift
//  weather_app
//
//  Created by admin on 6/23/22.
//

import UIKit

class HistoryDetailViewController: UIViewController {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    //var country: Sys?
    var listDetail: list?
    //var weatherDetail: Weather?
    //var temperatureDetail: Main?
    //var windDetail: Wind?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
    
    func setupData(){
        if let country = listDetail?.sys {
            countryLabel.text = "Country: \(country.country)"
            let url = UrlManager.instance.urlFlag(text: country.country)
            flagImageView.image = ImageManager.instance.readStringUrl(urlStr: url)
        }

        if let listDetail = listDetail {
            placeLabel.text = listDetail.name
        }
        
        if let weatherDetail = listDetail?.weather[0] {
            weatherImageView.image = getWeatherImage(withUrl: weatherDetail.icon)
            descriptionLabel.text = weatherDetail.description
        }
        
        if let temperatureDetail = listDetail?.main {
            temperatureLabel.text = "\(temperatureDetail.temp) K"
        }
        
        if let windDetail = listDetail?.wind {
            windLabel.text = "Widn Speed: \(windDetail.speed) M/S"
        }
    }
    
    func getWeatherImage(withUrl: String) -> UIImage? {
        let url = URL(string:UrlManager.instance.urlWeatherImage(text: withUrl))
        let image = ImageManager.instance.readUrl(urlStr: url!)
        return image
    }
}
