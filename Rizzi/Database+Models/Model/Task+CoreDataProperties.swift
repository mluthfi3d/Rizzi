//
//  Task+CoreDataProperties.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 07/09/23.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskDeadline: Date?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskId: UUID?
    @NSManaged public var taskReminderStatus: Bool
    @NSManaged public var taskStatus: Bool
    @NSManaged public var category: Category?

}

extension Task : Identifiable {

}
