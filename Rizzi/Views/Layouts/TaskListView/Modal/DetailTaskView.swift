//
//  DetailTaskView.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 07/09/23.
//

import SwiftUI

struct DetailTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Binding var task: Task
    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    Text(task.taskDescription ?? "")
                    Text(task.taskDeadline?.formatDateOnly() ?? "")
                    Text(task.taskDeadline?.formatTimeOnly() ?? "")
                    Toggle("Remind Me", isOn: $task.taskReminderStatus)
                    Picker("Category", selection: $task.category){
                        ForEach(categoryViewModel.categories, id: \.self){category in
                            Text(category.categoryName ?? "").tag(Optional(category))
                        }
                    }.pickerStyle(.menu)
                }
                
                Button("Delete") {
                    
                }
            }
            
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .primaryAction){
                    Button("Done"){
                        dismiss()
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            
            
        }
    }
}

struct DetailTaskView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTaskView(taskViewModel: TaskViewModel(), categoryViewModel: CategoryViewModel(), task: .constant(Task()))
    }
}
