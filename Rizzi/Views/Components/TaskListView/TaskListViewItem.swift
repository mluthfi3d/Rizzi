//
//  TaskListViewItem.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import SwiftUI

struct TaskListViewItem: View {
    @Binding var task: Task
    @Binding var selectedTask: Task
    @Binding var isShowingDetails: Bool
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var taskViewModel: TaskViewModel
    @State var isCategorized = false
    @State var isOn = false
    
    var body: some View {
        VStack {
            Button
            {
                selectedTask = task
                isShowingDetails.toggle()
            } label: {
                HStack(spacing: 0){
                    HStack{
                        if task.taskStatus {
                            Toggle(isOn: $isOn, label: {
                                HStack{
                                    VStack(alignment: .leading, spacing: 4){
                                        if(isCategorized){
                                            VStack {
                                                Text(task.category?.categoryName ?? "")
                                                    .font(.system(size: 12))
                                                    .textCase(.uppercase)
                                                    .foregroundColor(categoryViewModel.getColor(color: task.category?.categoryColor ?? ""))
                                            }
                                        }
                                        
                                        Text(task.taskDescription ?? "")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color.black100)
                                        
                                        if (task.taskDeadline!.isPassed() && !task.taskStatus) {
                                            VStack{
                                                Text("Overdue")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(Color.colorDanger)
                                                    .textCase(.uppercase)
                                            }
                                            .padding(4)
                                            .padding([.horizontal], 4)
                                            .background(Color.colorSoftDanger)
                                            .cornerRadius(4)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    VStack{
                                        Text(task.taskDeadline?.formatTimeOnly() ?? "")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.black60)
                                        Spacer()
                                    }
                                }
                                .background(Color.white)
                                .frame(maxWidth: .infinity)
                            })
                            .toggleStyle(ArchivedStyle())
                            .onChange(of: isOn){ value in
                                taskViewModel.changeStatus(task: task, value: value)
                            }
                        } else {
                            Toggle(isOn: $isOn, label: {
                                HStack{
                                    VStack(alignment: .leading, spacing: 4){
                                        if(isCategorized){
                                            VStack {
                                                Text(task.category?.categoryName ?? "")
                                                    .font(.system(size: 12))
                                                    .textCase(.uppercase)
                                                    .foregroundColor(categoryViewModel.getColor(color: task.category?.categoryColor ?? ""))
                                            }
                                        }
                                        
                                        Text(task.taskDescription ?? "")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color.black100)
                                        
                                        if (task.taskDeadline?.isPassed() ?? false && !task.taskStatus) {
                                            VStack{
                                                Text("Overdue")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(Color.colorDanger)
                                                    .textCase(.uppercase)
                                            }
                                            .padding(4)
                                            .padding([.horizontal], 4)
                                            .background(Color.colorSoftDanger)
                                            .cornerRadius(4)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    VStack{
                                        Text(task.taskDeadline?.formatTimeOnly() ?? "")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.black60)
                                        Spacer()
                                    }
                                }
                                .background(Color.white)
                                .frame(maxWidth: .infinity)
                            })
                            .toggleStyle(ListCheckBoxStyle(taskColor: categoryViewModel.getColor(color: task.category?.categoryColor ?? "")))
                            .onChange(of: isOn){ value in
                                taskViewModel.changeStatus(task: task, value: value)
                            }
                        }
                        
                    }
                    .padding([.vertical, .leading], 16)
                    .padding([.trailing], 12)
                    
                    Rectangle()
                        .fill(isCategorized ? categoryViewModel.getColor(color: task.category?.categoryColor ?? "") : Color.listGeneral)
                        .frame(width: 4)
                    
                }
                .background(Color.white)
                .cornerRadius(8)
                .frame(alignment: .top)
            }
        }
        .gesture(
            DragGesture().onChanged { value in
               if value.translation.width > 0 {
                  print("Scroll right")
               } else {
                  print("Scroll left")
               }
            }
         )
        
        .onAppear {
            if(task.category?.categoryName != "No Category"){
                isCategorized = true
            }
            isOn = task.taskStatus
        }
        
    }
}

struct TaskListViewItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let tempTask = Task(context: context)
        TaskListViewItem(task: .constant(tempTask), selectedTask: .constant(Task()), isShowingDetails: .constant(false), categoryViewModel: CategoryViewModel(), taskViewModel: TaskViewModel())
    }
}
