//
//  UrlManager.swift
//  weather_app
//
//  Created by admin on 6/23/22.
//

import Foundation

class UrlManager {
    static let instance = UrlManager()
    
    func urlWeather(text: String) -> String {
        let urlStr = "https://openweathermap.org/data/2.5/find?q=\(text)&appid=439d4b804bc8187953eb36d2a8c26a02&units=metric"
        return urlStr
    }
    
    func urlWeatherImage(text: String) -> String {
        let urlStr = "https://openweathermap.org/img/wn/\(text)@2x.png"
        return urlStr
    }
    
    func urlFlag(text: String) -> String {
        let urlStr = "https://countryflagsapi.com/png/\(text)"
        return urlStr
    }
}
