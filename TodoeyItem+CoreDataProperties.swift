//
//  TodoeyItem+CoreDataProperties.swift
//  
//
//  Created by Askar on 13.03.2023.
//
//

import Foundation
import CoreData


extension TodoeyItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoeyItem> {
        return NSFetchRequest<TodoeyItem>(entityName: "TodoeyItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var isCompleted: Bool
    @NSManaged public var section: TodoeySection?

}
