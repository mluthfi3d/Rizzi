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
    
    @State var searchText = ""
    
    var body: some View {
        NavigationStack(path: $route.path){
            VStack{
                if(!taskViewModel.groupedTasks.isEmpty){
                    ScrollView {
                        VStack(spacing: 16){
                            ForEach($taskViewModel.groupedTasks, id: \.self) { $groupedTask in
                                TaskListViewSection(groupedTask: $groupedTask, categoryViewModel: categoryViewModel)
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
            
            
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) 
            
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
                        Button(action: {
//                            isNewCategory.toggle()
                        }) {
                            Label("Filter", systemImage: "slider.horizontal.3")
                        }
                        Button(action: {
//                            isNewCategory.toggle()
                        }) {
                            Label("Archived", systemImage: "archivebox")
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
            
            .task (id: searchText){
                if searchText != "" {
                    taskViewModel.fetchTasksFilterByTaskDescription(description: searchText)
                } else {
                    taskViewModel.fetchTasks()
                }
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
