//
//  FilterView.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 07/09/23.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var categoryViewModel: CategoryViewModel
    @Binding var selectedCategory: Category
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Category", selection: $selectedCategory){
                    ForEach(categoryViewModel.categories, id: \.self){category in
                        Text(category.categoryName ?? "").tag(Optional(category))
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
                    Button("Apply"){
                        dismiss()
                    }.disabled((selectedCategory.categoryName == "No Category"))
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let tempCategory = Category(context: context)
        FilterView(categoryViewModel: CategoryViewModel(), selectedCategory: .constant(tempCategory))
    }
}
