//
//  TaskListViewSection.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 06/09/23.
//

import SwiftUI

struct TaskListViewSection: View {
    @Binding var groupedTask: [Task]
    @Binding var selectedTask: Task
    @Binding var isShowingDetails: Bool
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        VStack(spacing: 0){
            VStack{
                if(Date.now.formatDateOnly() == groupedTask.first?.taskDeadline?.formatDateOnly() ?? "") {
                    Text("Today")
                        .font(.system(size: 14))
                } else {
                    Text(groupedTask.first?.taskDeadline?.formatDateOnly() ?? "")
                        .font(.system(size: 14))
                }
            }
            .foregroundColor(Color.black100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.bottom], 8)
            
            VStack(spacing: 8){
                ForEach($groupedTask, id: \.self) { $task in
                    TaskListViewItem(task: $task, selectedTask: $selectedTask, isShowingDetails: $isShowingDetails, categoryViewModel: categoryViewModel, taskViewModel: taskViewModel)
                }
            }
        }
    }
}

struct TaskListViewSection_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let tempTask = Task(context: context)
        TaskListViewSection(groupedTask: .constant([tempTask]), selectedTask: .constant(Task()), isShowingDetails: .constant(false), categoryViewModel: CategoryViewModel(), taskViewModel: TaskViewModel())
    }
}
