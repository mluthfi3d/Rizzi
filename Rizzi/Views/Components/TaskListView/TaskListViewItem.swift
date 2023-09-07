//
//  TaskListViewItem.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import SwiftUI

struct TaskListViewItem: View {
    @Binding var task: Task
    @ObservedObject var categoryViewModel: CategoryViewModel
    @State var isCategorized = false
    @State var isOn = false
    
    var body: some View {
        HStack(spacing: 0){
            Rectangle()
                .fill(isCategorized ? categoryViewModel.getColor(color: task.category?.categoryColor ?? "") : Color.listGeneral)
                .frame(width: 4)
            
            HStack{
                Toggle(isOn: $isOn, label: {
                    HStack{
                        VStack(alignment: .leading, spacing: 4){
                            if(isCategorized){
                                VStack {
                                    Text(task.category?.categoryName ?? "")
                                        .font(.system(size: 14))
                                        .foregroundColor(categoryViewModel.getColor(color: task.category?.categoryColor ?? ""))
                                }
                            }
                            
                            Text(task.taskDescription ?? "")
                                .font(.system(size: 16))
                            
                            if (task.taskDeadline!.isPassed()) {
                                VStack{
                                    Text("Overdue")
                                        .font(.system(size: 14))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.black0)
                                }
                                .padding(4)
                                .padding([.horizontal], 4)
                                .background(Color.red)
                                .cornerRadius(4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        VStack{
                            Text(task.taskDeadline?.formatTimeOnly() ?? "")
                                .font(.system(size: 14))
                                .foregroundColor(Color.black60)
                            Spacer()
                        }
                    }
                    .background(Color.white)
                    .frame(maxWidth: .infinity)
                })
                .toggleStyle(ListCheckBoxStyle(taskColor: isCategorized ? categoryViewModel.getColor(color: task.category?.categoryColor ?? "") : Color.listGeneral))
            }
            .padding([.vertical], 16)
            .padding([.leading], 12)
            .padding([.trailing], 16)
        }
        .background(Color.white)
        .cornerRadius(8)
        .frame(alignment: .top)
        
        .onAppear {
            if(task.category?.categoryName != "No Category"){
                isCategorized = true
            }
        }
    }
}

struct TaskListViewItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let tempTask = Task(context: context)
        TaskListViewItem(task: .constant(tempTask), categoryViewModel: CategoryViewModel())
    }
}
