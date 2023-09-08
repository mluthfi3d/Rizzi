//
//  ArchivedView.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 08/09/23.
//

import SwiftUI

struct ArchivedView: View {
    @StateObject var taskViewModel: TaskViewModel
    @StateObject var categoryViewModel: CategoryViewModel
    
    @State var selectedTask = Task()
    @State var isShowingDetails = false
    
    var body: some View {
        VStack{
            if(!taskViewModel.groupedArchivedTasks.isEmpty){
                ScrollView {
                    VStack(spacing: 16){
                        ForEach($taskViewModel.groupedArchivedTasks, id: \.self) { $groupedTask in
                            TaskListViewSection(groupedTask: $groupedTask, selectedTask: $selectedTask, isShowingDetails: $isShowingDetails, categoryViewModel: categoryViewModel, taskViewModel: taskViewModel)
                                .padding([.horizontal], 16)
                                .padding([.vertical], 8)
                        }
                    }
                    .padding([.vertical], 16)
                }
            } else {
                Text("No tasks done, try to doing one")
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.colorBackground)
        .scrollContentBackground(.hidden)
        .navigationTitle("Archived Tasks")
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isShowingDetails){
            DetailTaskView(taskViewModel: taskViewModel, categoryViewModel: categoryViewModel, task: $selectedTask)
        }
    }
}

struct ArchivedView_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedView(taskViewModel: TaskViewModel(), categoryViewModel: CategoryViewModel(), isShowingDetails: false)
    }
}
