//
//  TaskListViewItem.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import SwiftUI

struct TaskListViewItem: View {
    @Binding var task: Task
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                if(task.category?.categoryName != "No Category"){
                    Text(task.category?.categoryName ?? "")
                        .font(.system(size: 14))
                }
                Text(task.taskDescription ?? "")
                    .font(.system(size: 18))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack{
                Text(task.taskDeadline?.formatTimeOnly() ?? "")
                    .font(.system(size: 14))
                Spacer()
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .frame(alignment: .top)
    }
}
//
//struct TaskListViewItem_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskListViewItem(task: .constant(Task(context: <#T##NSManagedObjectContext#>)))
//    }
//}
