//
//  Annotation+CoreDataProperties.swift
//  Places
//
//  Created by Мирас on 11/3/20.
//
//

import Foundation
import CoreData


extension Annotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Annotation> {
        return NSFetchRequest<Annotation>(entityName: "Annotation")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?

}

extension Annotation : Identifiable {

}
