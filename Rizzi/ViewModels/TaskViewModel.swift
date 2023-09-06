//
//  TaskViewModel.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    
    private let viewContext = PersistenceController.shared.viewContext
    @Published var groupedTasks: [[Task]] = []
    
    init(){
        self.fetchTasksGropByDay()
    }
    
    func fetchTasks() -> [Task]{
        var tasks: [Task] = []
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            tasks = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Error while Fetching")
        }
        return tasks
    }
    
    func fetchTasksGropByDay(){
        let tasks = fetchTasks()
        var newGroupedTasks: [[Task]] = []
        let newTasks = Dictionary(grouping: tasks, by: {$0.taskDeadline!.formatDateOnly()})
        let sortedKeys = newTasks.keys.sorted()
        
        for key in sortedKeys {
            newGroupedTasks.append(newTasks[key]!.sorted(by: {$0.taskDeadline!.formatTimeOnly() < $1.taskDeadline!.formatTimeOnly()}))
        }
        
        groupedTasks = newGroupedTasks
    }
    
    func findCategory(categoryName: String) -> Category{
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = NSPredicate(format: "categoryName == %@", "No Category")
        
        var category = Category(context: viewContext)
        
        do {
            let results = try viewContext.fetch(request)
            if !results.isEmpty {
                category = results[0]
            }
        } catch {
            print("DEBUG: Error while Getting Category")
        }
        
        return category
    }
    
    func insertToDatabase(taskDescription: String, taskDeadline: Date, taskReminderStatus: Bool, categoryName: String){
        
        let newTask = Task(context: viewContext)
        newTask.taskId = UUID()
        newTask.taskDescription = taskDescription
        newTask.taskDeadline = taskDeadline
        newTask.taskReminderStatus = taskReminderStatus
        newTask.taskStatusId = "0"
        newTask.category = self.findCategory(categoryName: categoryName)
        save()
        
        self.fetchTasksGropByDay()
    }
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: Error while saving")
        }
    }
}
