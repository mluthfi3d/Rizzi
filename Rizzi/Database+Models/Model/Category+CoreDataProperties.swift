//
//  Category+CoreDataProperties.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//
//

import Foundation
import CoreData

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryId: UUID?
    @NSManaged public var categoryName: String?
    @NSManaged public var categoryColor: String?
    @NSManaged public var task: NSSet?

}

// MARK: Generated accessors for task
extension Category {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}

extension Category : Identifiable {

}
