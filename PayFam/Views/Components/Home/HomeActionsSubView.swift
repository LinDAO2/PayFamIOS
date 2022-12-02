//
//  HomeActionsSubView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI
import SwiftUIFontIcon

struct HomeActionsSubView: View {
    var body: some View {
        VStack{
            HStack{
                NavigationLink {
                    SendMoneyView()
                } label: {
                    HStack{
                        Image(systemName: "arrow.up.to.line")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.secondaryBrandColor)
                        
                        Text("Send Funds")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.primaryBrandColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                   
                    
                }
                
                Spacer()
                NavigationLink {
                   
                } label: {
                    HStack{
                        Image(systemName: "arrow.down.to.line")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.secondaryBrandColor)
                        
                        Text("Redeem Funds")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.primaryBrandColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                   
                    
                }
            }
            .padding()
            
            HStack{
                
                NavigationLink{
                    
                }label: {
                    VStack(alignment: .center){
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.title)
                        Text("Buy Stablecoins")
                            .font(.title2)
                        Text("Buy stablecoins with Fiat")
                            .font(.callout)
                    }
                    .padding()
                    .foregroundColor(.primary)
                    .frame(maxWidth: getScreenBounds().width / 2.3)
                    .clipShape(RoundedRectangle(cornerRadius: 10)
                    )
                    .background(Color.systemBacground)
                    .cornerRadius(10)
                    .shadow(color:.primary.opacity(0.5), radius: 5)
                    
                  
                    
                }
                
                Spacer(minLength: 0)
                
                NavigationLink{
                    
                }label: {
                    VStack(alignment: .center){
                        Image(systemName: "bitcoinsign.square.fill")
                            .font(.title)
                        
                        Text("Sell Stablecoins")
                            .font(.title2)
                        Text("Sell stablecoins instantly")
                            .font(.callout)
                    }
                    .padding()
                    .foregroundColor(.primary)
                    .frame(maxWidth: getScreenBounds().width / 2.3)
                    .clipShape(RoundedRectangle(cornerRadius: 10)
                    )
                    .background(Color.systemBacground)
                    .cornerRadius(10)
                    .shadow(color:.primary.opacity(0.5), radius: 5)
                    
                  
                    
                }
            }
            .padding()
        }
      
    }
}

struct HomeActionsSubView_Previews: PreviewProvider {
    static var previews: some View {
        HomeActionsSubView()
    }
}
