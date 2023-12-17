//
//  StorageManager.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 16.12.23.
//

import Foundation
import CoreData
import UIKit

public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createCity(name: String, lat: Double, lon: Double) {
        guard let cityEntityDescription = NSEntityDescription.entity(forEntityName: "CityObj", in: context) else { return }
        let city = CityObj(entity: cityEntityDescription, insertInto: context)
        city.name = name
        city.lat = lat
        city.lon = lon
        appDelegate.saveContext()
    }
    
    public func fetchCitys() -> [CityObj] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityObj")
        do {
            return try context.fetch(fetchRequest) as! [CityObj]
        } catch {
            print("error")
        }
        return []
    }
    
    public func deleteCity(name: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityObj")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            guard let citys = try? context.fetch(fetchRequest) as? [CityObj],
                  let city = citys.first else { return }
            context.delete(city)
        }
        appDelegate.saveContext()
    }
}
