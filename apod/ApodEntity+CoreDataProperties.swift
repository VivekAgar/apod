//
//  ApodEntity+CoreDataProperties.swift
//  apod
//
//  Created by vivek on 18/07/22.
//
//

import Foundation
import CoreData


extension ApodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApodEntity> {
        return NSFetchRequest<ApodEntity>(entityName: "ApodEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var explanation: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var isFavourite: Bool

}

extension ApodEntity : Identifiable {

}
