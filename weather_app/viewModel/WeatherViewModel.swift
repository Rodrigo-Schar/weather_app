//
//  WeatherViewModel.swift
//  weather_app
//
//  Created by admin on 6/27/22.
//

import Foundation
import SVProgressHUD

class WeatherViewModel {
    
    private var searchList: [list] = []
    
    var numberOfItemsInSection : Int {
        return searchList.count
    }
    
    var arrayList : [list] {
        return searchList
    }
    
    func removeListElements() {
        return searchList.removeAll()
    }
    
    func getWeatherBy(index: Int) -> list {
        return searchList[index]
    }
    
    func getWeatherData(withText: String, completion: ( () -> Void )? ){
        guard let url = URL(string:UrlManager.instance.urlWeather(text: withText)) else { return }
        SVProgressHUD.show()
        
        NetworkManager.shared.get(WeatherModel.self, from: url) { result in
            switch result {
                case .success(let data):
                    self.searchList = data.list
                    if(self.searchList.count == 0){
                        SVProgressHUD.dismiss()
                        self.searchList.removeAll()
                        completion?()
                    } else {
                        completion?()
                        SVProgressHUD.dismiss()
                    }
                case .failure(let error):
                    print(error)
                    SVProgressHUD.dismiss()
            }
        }
    }
    
    func getWeatherImage(withUrl: String) -> UIImage? {
        let url = URL(string:UrlManager.instance.urlWeatherImage(text: withUrl))
        let image = ImageManager.instance.readUrl(urlStr: url!)
        return image
    }
    
}
