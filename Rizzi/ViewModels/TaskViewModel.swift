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
        self.fetchTasksGroupByDay()
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
    
    func fetchTasksGroupByDay(){
        let tasks = fetchTasks()
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
        newTask.taskStatusId = "0"
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
        
        self.fetchTasksGroupByDay()
    }
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: Error while saving")
        }
    }
}
