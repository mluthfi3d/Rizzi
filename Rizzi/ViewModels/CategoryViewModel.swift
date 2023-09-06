//
//  CategoryViewModel.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import Foundation
import CoreData

class CategoryViewModel: ObservableObject {
    
    private let viewContext = PersistenceController.shared.viewContext
    @Published var categories: [Category] = []
    let colors = ["Red", "Green", "Blue", "Purple"]
    
    init(){
        createNoCategory()
    }
    
    func fetchCategories(){
        let request = NSFetchRequest<Category>(entityName: "Category")
        do {
            categories = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Error while Fetching")
        }
        print(categories)
    }
    
    func createNoCategory(){
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = NSPredicate(format: "categoryName == %@", "No Category")
        
        do {
            let results = try viewContext.fetch(request)
            if results.isEmpty {
                self.insertToDatabase(categoryName: "No Category", categoryColor: "black0")
            }
        } catch {
            print("DEBUG: Error while Creating No Category")
        }
        fetchCategories()
        
    }
    
    func insertToDatabase(categoryName: String, categoryColor: String){
        let newCategory = Category(context: viewContext)
        newCategory.categoryId = UUID()
        newCategory.categoryName = categoryName
        newCategory.categoryColor = categoryColor
        save()
        
        self.fetchCategories()
    }
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: Error while saving")
        }
    }
    
}
