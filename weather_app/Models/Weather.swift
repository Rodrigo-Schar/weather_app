//
//  Weather.swift
//  weather_app
//
//  Created by admin on 6/22/22.
//

import Foundation

struct WeatherModel: Decodable {
    let message: String
    let cod: String
    let count : Int
    let list: [list]
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case cod = "cod"
        case count = "count"
        case list = "list"
    }
}

struct list: Decodable {
    let id: Int
    let name: String
    let coord : Coord
    let main: Main
    let dt: Int
    let wind: Wind?
    let sys: Sys
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds?
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case coord = "coord"
        case main = "main"
        case dt = "dt"
        case wind = "wind"
        case sys = "sys"
        case rain = "rain"
        case snow = "snow"
        case clouds = "clouds"
        case weather = "weather"
    }
}

struct Coord: Decodable {
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }
}



struct Main: Decodable {
    let temp : Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feels_like = "feels_like"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
        case sea_level = "sea_level"
        case grnd_level = "grnd_level"
    }
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
}

struct Sys: Decodable {
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
    }
}

struct Rain: Decodable {
    let h1: Double?
    let h3: Double?
    
    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
        case h3 = "3h"
    }
}

struct Snow: Decodable {
    let h1: Double?
    let h3: Double?
    
    enum CodingKeys: String, CodingKey {
        case h1 = "1h"
        case h3 = "3h"
    }
}

struct Clouds: Decodable {
    let all: Int
    
    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
}
