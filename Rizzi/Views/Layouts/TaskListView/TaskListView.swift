//
//  TaskListView.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import SwiftUI

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var route = Route()
    @StateObject var taskViewModel = TaskViewModel()
    @StateObject var categoryViewModel = CategoryViewModel()
    
    @State var isNewTask = false
    @State var isNewCategory = false
    
    var body: some View {
        NavigationStack(path: $route.path){
            VStack{
                if(!taskViewModel.groupedTasks.isEmpty){
                    ScrollView {
                        VStack(spacing: 16){
                            ForEach($taskViewModel.groupedTasks, id: \.self) { $grouppedTask in
                                TaskListViewSection(grouppedTask: $grouppedTask)
                                    .padding([.horizontal], 16)
                                    .padding([.vertical], 8)
                            }
                        }
                        .padding([.vertical], 16)
                    }
                } else {
                    Text("All tasks are done, rest easy")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.colorBackground)
            .scrollContentBackground(.hidden)
            
            .navigationTitle("To Do")
            .navigationBarTitleDisplayMode(.large).toolbar{
                ToolbarItem(placement: .primaryAction){
                    Menu(content: {
                        Button(action: {
                            isNewTask.toggle()
                        }) {
                            Label("New Task", systemImage: "checklist")
                        }
                        Button(action: {
                            isNewCategory.toggle()
                        }) {
                            Label("New Category", systemImage: "tag")
                        }
                    }, label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                    })
                }
            }
            
            .sheet(isPresented: $isNewTask){
                NewTaskView(taskViewModel: taskViewModel, categoryViewModel: categoryViewModel)
            }
            
            .sheet(isPresented: $isNewCategory){
                NewCategoryView(categoryViewModel: categoryViewModel)
            }
            
            .navigationDestination(for: String.self){item in
                switch (item){
                case "taskList":
                    TaskListView()
                case "taskDetail":
                    ContentView()
                default:
                    ContentView()
                }
                
            }
        }
        .environmentObject(route)
        
        
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
