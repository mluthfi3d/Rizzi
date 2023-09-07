//
//  TaskViewModel.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import Foundation
import CoreData
import SwiftUI

class TaskViewModel: ObservableObject {
    
    private let viewContext = PersistenceController.shared.viewContext
    @Published var groupedTasks: [[Task]] = []
    
    init(){
        self.fetchTasks()
    }
    
    func fetchTasks(description: String? = "", category: Category? = nil, taskStatus: Bool? = false){
        var tasks: [Task] = []
        let request = NSFetchRequest<Task>(entityName: "Task")
        if description != "" {
            request.predicate = NSPredicate(format: "taskDescription contains[cd] %@", description!)
        }
        if category != nil {
            request.predicate = NSPredicate(format: "category = %@", category!)
        }
        
        do {
            let results = try viewContext.fetch(request)
            if !results.isEmpty {
                tasks = results
            }
        } catch {
            print("DEBUG: Error while Getting Category")
        }
        self.groupTasks(tasks: tasks)
    }
    
    
    func groupTasks(tasks: [Task]){
        var newGroupedTasks: [[Task]] = []
        let newTasks = Dictionary(grouping: tasks, by: {$0.taskDeadline!.formatDateOnly()})
        let sortedKeys = newTasks.keys.sorted()
        
        for key in sortedKeys {
            newGroupedTasks.append(newTasks[key]!.sorted(by: {$0.taskDeadline!.formatTimeOnly() < $1.taskDeadline!.formatTimeOnly()}))
        }
        groupedTasks = newGroupedTasks
    }
    
    
    func insertToDatabase(taskDescription: String, taskDeadline: Date, taskReminderStatus: Bool, category: Category?){
        let newTask = Task(context: viewContext)
        newTask.taskId = UUID()
        newTask.taskDescription = taskDescription
        newTask.taskDeadline = taskDeadline
        newTask.taskReminderStatus = taskReminderStatus
        newTask.taskStatus = false
        
        if category == nil {
            let request = NSFetchRequest<Category>(entityName: "Category")
            request.predicate = NSPredicate(format: "categoryName == %@", "No Category")
            
            do {
                let results = try viewContext.fetch(request)
                if !results.isEmpty {
                    newTask.category = results[0]
                }
            } catch {
                print("DEBUG: Error while Getting Category")
            }
        } else {
            newTask.category = category
        }
        
        save()
        
        self.fetchTasks()
    }
    
    func changeStatus(task: Task, value: Bool){
        task.taskStatus = value
        save()
        
        self.fetchTasks()
    }
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: Error while saving")
        }
    }
}
