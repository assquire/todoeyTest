//
//  DataManager.swift
//  Todoey
//
//  Created by Yerzhan Syzdyk on 02.03.2023.
//

import Foundation
import UIKit

protocol ItemManagerDelegate {
    func didUpdate(with models: [TodoeyItem])
    func didFail(with error: Error)
}

struct ItemManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: ItemManagerDelegate?
    static var shared = ItemManager()
    
    func fetchItems(with text: String = "", section: TodoeySection, isShowingCompleted: Bool) {
        do {
            let request = TodoeyItem.fetchRequest()
            request.predicate = setPredicate(with: text, section: section, isShowingCompleted: isShowingCompleted)
            request.sortDescriptors = setSortDesc()
            let models = try context.fetch(request)
            delegate?.didUpdate(with: models)
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func createItem(name: String, desc: String, priority: Int16, section: TodoeySection) {
        let newItem = TodoeyItem(context: context)
        newItem.name = name
        newItem.desc = desc
        newItem.priority = priority
        newItem.createdAt = Date()
        newItem.isCompleted = false
        section.addToItems(newItem)
        do {
            try context.save()
            fetchItems(section: section, isShowingCompleted: false)
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func completeItem(item: TodoeyItem) {
        do {
            item.isCompleted = true
            try context.save()
            fetchItems(section: item.section!, isShowingCompleted: false)
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func deleteItem(item: TodoeyItem, section: TodoeySection) {
        do {
            context.delete(item)
            try context.save()
            fetchItems(section: section, isShowingCompleted: false)
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func editItem(item: TodoeyItem, name: String, desc: String, priority: Int16) {
        do {
            item.name = name
            item.desc = desc
            item.priority = priority
            try context.save()
            fetchItems(section: item.section!, isShowingCompleted: false)
        } catch {
            delegate?.didFail(with: error)
        }
    }
}

private extension ItemManager {
    
    func setPredicate(with searchText: String, section: TodoeySection, isShowingCompleted: Bool) -> NSPredicate? {
        
        var predicateList: [NSPredicate] = []
        
        let sectionPredicate = NSPredicate(format: "section == %@", section)
        predicateList.append(sectionPredicate)
        
        if searchText != "" {
            let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
            predicateList.append(namePredicate)
        }
        
        if !isShowingCompleted {
            let isCompletedPredicate = NSPredicate(format: "isCompleted == %@", "False")
            predicateList.append(isCompletedPredicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicateList)
        return compoundPredicate
    }
    
    func setSortDesc() -> [NSSortDescriptor] {
        let sortDescPriority = NSSortDescriptor(key: "priority", ascending: true)
        let sortDescName = NSSortDescriptor(key: "name", ascending: true)
        return [sortDescPriority, sortDescName]
    }
}

extension ItemManagerDelegate {
    
    func didFail(with error: Error){
        print("Error accured: ", error)
    }
}
