//
//  HomeTransactions.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct HomeTransactions: View {
    @State var currentTab : String = "sent"
    
    var body: some View {
        VStack{
            HStack{
                TabThumbs(title: "Sent",name:"sent")
                Spacer()
                TabThumbs( title: "To  Redeem",name:"toRedeem")
                Spacer()
                TabThumbs(title: "Redeemed",name:"redeemed")



            }
            .padding()
            
            
            TabView (selection: $currentTab){
               
                TransactionListView().tag("sent")
                TransactionListView().tag("toRedeem")
                TransactionListView().tag("redeemed")
            }
        }
   
    }
    
    @ViewBuilder
    
    func TabThumbs(title: String, name : String)-> some View {
                    
        
                    Button {
                        withAnimation(.spring()){
                            currentTab = name
                        }
                    } label: {
                        Text(title)
                            .padding(.all, currentTab == name ? 15 : 0)
                            .padding(.horizontal,currentTab == name ? 2 : 0)
                            .frame(width:currentTab == name ? 150 : nil )
                            .font(.callout.bold())
                            .foregroundColor( currentTab == name ? Color.primaryBrandColor : Color.primary )
                            .background(currentTab == name ? Color.white : nil)
                            .clipShape( RoundedRectangle(cornerRadius: 20) 
                                )
                            .shadow(radius: 10)

        
                    }

       
    }
}



struct HomeTransactions_Previews: PreviewProvider {
    static var previews: some View {
        HomeTransactions()
    }
}
