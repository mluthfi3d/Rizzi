//
//  ToggleStyle.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 07/09/23.
//

import Foundation
import SwiftUI

struct ListCheckBoxStyle: ToggleStyle {
    let taskColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.black60)
            configuration.label
        }
        .onTapGesture {
            withAnimation(.spring()){
                configuration.isOn.toggle()
            }
        }
    }
}

//struct ToggleStyle_Previews: PreviewProvider {
//    static var previews: some View {
//        ToggleStyle()
//    }
//}