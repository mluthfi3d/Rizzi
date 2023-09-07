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
    @StateObject var notificationManager = NotificationManager()
    
    @State var isNewTask = false
    @State var isNewCategory = false
    @State var isFiltering = false
    @State var isFiltered = false
    @State var isShowingDetails = false
    
    @State var selectedCategory = Category()
    @State var selectedTask = Task()
    @State var searchText = ""
    
    var body: some View {
        NavigationStack(path: $route.path){
            VStack{
                if(!taskViewModel.groupedTasks.isEmpty){
                    ScrollView {
                        VStack(spacing: 16){
                            ForEach($taskViewModel.groupedTasks, id: \.self) { $groupedTask in
                                TaskListViewSection(groupedTask: $groupedTask, selectedTask: $selectedTask, isShowingDetails: $isShowingDetails, categoryViewModel: categoryViewModel, taskViewModel: taskViewModel)
                                    .padding([.horizontal], 16)
                                    .padding([.vertical], 8)
                            }
                        }
                        .padding([.vertical], 16)
                    }
                } else {
                    if searchText != "" {
                        Text("No results for " + searchText)
                    } else {
                        Text("No tasks found, try to create one")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.colorBackground)
            .scrollContentBackground(.hidden)
            
            
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            
            .navigationTitle("To Do")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
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
                            isFiltering.toggle()
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
            .onChange (of: selectedCategory){ value in
                if value.categoryName == "No Category" {
                    taskViewModel.fetchTasks(description: searchText)
                } else {
                    taskViewModel.fetchTasks(description: searchText, category: value)
                }
                if selectedCategory.categoryName != "No Category" {
                    isFiltered = true
                } else {
                    isFiltered = false
                }
            }
            
            
            .sheet(isPresented: $isNewTask){
                NewTaskView(taskViewModel: taskViewModel, categoryViewModel: categoryViewModel)
            }
            
            .sheet(isPresented: $isNewCategory){
                NewCategoryView(categoryViewModel: categoryViewModel)
            }
            
            .sheet(isPresented: $isFiltering){
                FilterView(categoryViewModel: categoryViewModel, selectedCategory: $selectedCategory)
            }
            
            .sheet(isPresented: $isShowingDetails){
                DetailTaskView(taskViewModel: taskViewModel, categoryViewModel: categoryViewModel, task: $selectedTask)
            }
            
            .task (id: searchText){
                if isFiltered {
                    taskViewModel.fetchTasks(description: searchText, category: selectedCategory)
                } else {
                    taskViewModel.fetchTasks(description: searchText)
                }
            }
            
            .task {
                taskViewModel.fetchTasks(description: searchText)
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
