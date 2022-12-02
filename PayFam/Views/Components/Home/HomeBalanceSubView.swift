//
//  HomeBalanceSubView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct HomeBalanceSubView: View {
    var body: some View {
        HStack{
            VStack{
                HStack{
                    Spacer()
                    Text("See all")
                        .font(.callout)
                }
                    
                Text(1000,format:.currency(code: "USD"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Balance")
                    .font(.headline)
                    .padding(.bottom,20)
            }
            .padding()
            
            .frame(maxWidth: .infinity)
        }
        
        .background(Color.systemBacground)
        .clipShape(RoundedRectangle(cornerRadius:20,style:.continuous))
        .shadow(color:Color.primary.opacity(0.2),radius: 10,x: 0,y: 5)
    }
}

struct HomeBalanceSubView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBalanceSubView()
    }
}
