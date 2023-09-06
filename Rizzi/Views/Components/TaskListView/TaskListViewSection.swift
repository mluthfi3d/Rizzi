//
//  TaskListViewSection.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 06/09/23.
//

import SwiftUI

struct TaskListViewSection: View {
    @Binding var groupedTask: [Task]
    var body: some View {
        VStack(spacing: 0){
            VStack{
                if(Date.now.formatDateOnly() == groupedTask.first?.taskDeadline?.formatDateOnly() ?? "") {
                    Text("Today")
                } else {
                    Text(groupedTask.first?.taskDeadline?.formatDateOnly() ?? "")
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom], 8)
            VStack(spacing: 8){
                ForEach($groupedTask, id: \.self) { $task in
                    TaskListViewItem(task: $task)
                }
            }
        }
    }
}

//struct TaskListViewSection_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskListViewSection()
//    }
//}
