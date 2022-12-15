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

extension String {
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    func removeSpecialCharsFromString() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_")
        return String(self.filter {okayChars.contains($0) }).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "")
    }

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

