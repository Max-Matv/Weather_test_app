//
//  CityObj+CoreDataProperties.swift
//  Weather_test_app
//
//  Created by Maksim Matveichuk on 16.12.23.
//
//

import Foundation
import CoreData


extension CityObj {

    @NSManaged public var name: String
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

}

extension CityObj : Identifiable {

}
