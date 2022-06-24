//
//  WeatherHistory+CoreDataProperties.swift
//  weather_app
//
//  Created by admin on 6/23/22.
//
//

import Foundation
import CoreData


extension WeatherHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherHistory> {
        return NSFetchRequest<WeatherHistory>(entityName: "WeatherHistory")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var positionList: Int16

}

extension WeatherHistory : Identifiable {

}
