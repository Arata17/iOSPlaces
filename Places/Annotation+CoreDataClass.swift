//
//  Annotation+CoreDataClass.swift
//  Places
//
//  Created by Мирас on 11/3/20.
//
//

import Foundation
import CoreData
import MapKit

@objc(Annotation)
public class Annotation: NSManagedObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
    }
    

}
