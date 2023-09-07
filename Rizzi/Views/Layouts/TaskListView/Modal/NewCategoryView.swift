//
//  NewCategoryView.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 06/09/23.
//

import SwiftUI

struct NewCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var categoryViewModel: CategoryViewModel

    @State private var categoryName = ""
    @State private var categoryColor = "Blue"
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Category Name", text: $categoryName)
                Picker("Category Color", selection: $categoryColor){
                    ForEach(Array(categoryViewModel.colors.keys), id: \.self){color in
                        Text(color).tag(Optional(color))
                    }
                }.pickerStyle(.menu)
            }
            
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction){
                    Button("Done"){
                        categoryViewModel.insertToDatabase(categoryName: categoryName, categoryColor: categoryColor)
                        dismiss()
                    }.disabled((categoryName.isEmpty))
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            
        }
    }
}

struct NewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NewCategoryView(categoryViewModel: CategoryViewModel())
    }
}
