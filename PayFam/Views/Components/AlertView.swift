//
//  AlertView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct AlertView: View {
    var msg : String
    @Binding var show : Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Text("Message")
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text(msg)
                .foregroundColor(.gray)
            
            Button {
                withAnimation {
                    show.toggle()
                }
            } label: {
                Text("Close")
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .frame(width:getScreenBounds().width - 100)
                    .background(Color.secondaryBrandColor)
                    .cornerRadius(15)
            }
            .frame(alignment: .center)

        })
        .padding()
        .background(.white)
        .cornerRadius(15)
        
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color.black.opacity(0.3).ignoresSafeArea())
    }
}

