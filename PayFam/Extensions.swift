//
//  Extensions.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import Foundation
import SwiftUI

extension Color{
    static let primaryBrandColor = Color("PrimaryBrandColor")
    static let secondaryBrandColor = Color("SecondaryBrandColor")
    static let systemBacground = Color(uiColor: .systemBackground)
}


extension View {
    func getScreenBounds()-> CGRect{
        return UIScreen.main.bounds
    }
    
    func getSafeArea()->UIEdgeInsets {
        guard let screen  = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero}
        
        guard let safeArea  = screen.windows.first?.safeAreaInsets else {return .zero}
        
        return safeArea
    }
}
