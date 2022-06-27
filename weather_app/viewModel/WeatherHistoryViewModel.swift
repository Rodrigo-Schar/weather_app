//
//  WeatherHistoryViewModel.swift
//  weather_app
//
//  Created by admin on 6/27/22.
//

import Foundation
import CoreData

class WeatherHistoryViewModel {
    
    var history = [WeatherHistory]()
    
    var numberOfItemsInSection : Int {
        return history.count
    }
    
    var arrayHistory : [WeatherHistory] {
        return history
    }
    
    func getWeatherHistoryBy(index: Int) -> WeatherHistory {
        return history[index]
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
    
    func loadData(completion: ( () -> Void )? ) {
        let context = CoreDataManager.shared.getContext()
        
        let fetchRequest: NSFetchRequest<WeatherHistory>
        fetchRequest = WeatherHistory.fetchRequest()

        do {
            history = try context.fetch(fetchRequest)
            history = history.sorted(by: { $0.date?.compare($1.date!) == .orderedDescending })
            completion?()
        } catch(let err) {
            print("Error", err)
        }
    }
    
    func deleteHistory(withObject: WeatherHistory, withIndex: IndexPath, completion: ( () -> Void )? ){
        let context = CoreDataManager.shared.getContext()
        context.delete(withObject)
        try? context.save()
        
        if let index = history.firstIndex(where: { withObject.id == $0.id && withObject.name == $0.name && withObject.positionList == $0.positionList }) {
            history.remove(at: index)
            completion?()
        }
    }
}
