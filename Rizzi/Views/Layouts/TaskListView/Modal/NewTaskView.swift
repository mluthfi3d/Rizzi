//
//  NewTaskView.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel
    
    init(taskViewModel: TaskViewModel, categoryViewModel: CategoryViewModel){
        self.taskViewModel = taskViewModel
        self.categoryViewModel = categoryViewModel
    }
    
    @State private var taskDescription = ""
    @State private var taskDeadline = Date()
    @State private var taskCategory = "No Category"
    @State private var taskReminderStatus = false
    
    //    let periods = ["One-Time", "Weekly", "Monthly"]
    //    let colors = ["Red", "Green", "Blue", "Purple"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task", text: $taskDescription)
                DatePicker("Due Date", selection: $taskDeadline, displayedComponents: [.date, .hourAndMinute])
                Toggle("Remind Me", isOn: $taskReminderStatus)
                Picker("Category", selection: $taskCategory){
                    if(!categoryViewModel.categories.isEmpty){
                        ForEach(categoryViewModel.categories, id: \.self){category in
                            Text(category.categoryName ?? "No Category").tag(Optional(category.categoryId))
                        }
                    } else {
                        Text("No Category").tag("")
                    }
                }.pickerStyle(.menu)
            }
//            .background(Color("BGColor"))
            
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction){
                    Button("Done"){
                        taskViewModel.insertToDatabase(taskDescription: taskDescription, taskDeadline: taskDeadline, taskReminderStatus: taskReminderStatus, categoryName: taskCategory)
                        dismiss()
                    }.disabled((taskDescription.isEmpty))
                }
            }
            //            .toolbarBackground(Color("ItemColor"),for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(taskViewModel: TaskViewModel(), categoryViewModel: CategoryViewModel())
    }
}
