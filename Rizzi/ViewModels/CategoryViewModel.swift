//
//  CategoryViewModel.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import Foundation
import CoreData
import SwiftUI

class CategoryViewModel: ObservableObject {
    
    private let viewContext = PersistenceController.shared.viewContext
    @Published var categories: [Category] = []
    let colors = ["Red": Color.listRed,
                  "Yellow": Color.listYellow,
                  "Green": Color.listGreen,
                  "Blue": Color.listBlue,
                  "Orange": Color.listOrange]
    
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
        self.fetchCategories()
        
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
    
    func getColor(color: String) -> Color {
        return colors[color] ?? Color.listGeneral
    }
    
}
