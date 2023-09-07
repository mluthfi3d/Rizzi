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
    
    @State private var taskDescription = ""
    @State private var taskDeadline = Date().addingTimeInterval(TimeInterval(5.0*60.0))
    @State private var taskCategory: Category?
    @State private var taskReminderStatus = false
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task", text: $taskDescription)
                DatePicker("Due Date",
                           selection: $taskDeadline,
                           in: Date().addingTimeInterval(TimeInterval(5.0*60.0))...,
                           displayedComponents: [.date, .hourAndMinute])
                Toggle("Remind Me", isOn: $taskReminderStatus)
                Picker("Category", selection: $taskCategory){
                    ForEach(categoryViewModel.categories, id: \.self){category in
                        Text(category.categoryName ?? "").tag(Optional(category))
                    }
                }.pickerStyle(.menu)
            }
            
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
                        taskViewModel.insertToDatabase(
                            taskDescription: taskDescription,
                            taskDeadline: taskDeadline,
                            taskReminderStatus: taskReminderStatus,
                            category: taskCategory ?? nil)
                        dismiss()
                    }.disabled((taskDescription.isEmpty))
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            
            
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(taskViewModel: TaskViewModel(), categoryViewModel: CategoryViewModel())
    }
}
