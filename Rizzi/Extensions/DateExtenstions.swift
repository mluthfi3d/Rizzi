//
//  DateExtenstions.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 06/09/23.
//

import Foundation

extension Date {
    
    func formatDateOnly() -> String {
        var formattedDate = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM y"
        formattedDate = formatter.string(from: self)
        return formattedDate
    }
    
    func formatTimeOnly() -> String {
        var formattedTime = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formattedTime = formatter.string(from: self)
        return formattedTime
    }
    
    func isPassed() -> Bool {
        let now = Date()
        return now > self
    }
}
