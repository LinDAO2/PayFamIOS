//
//  MainTabView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct MainTabView: View {
    @Binding var currentTab : String
    @Binding var showSideMenu : Bool
    
    @EnvironmentObject var profileViewModel : ProfileViewModel
    

    var body: some View {
        //MARK: Static header for pages
        VStack{
            HStack{
                HStack{
                    Button {
                        withAnimation(.spring()){
                            showSideMenu = true
                        }
                        
                    } label: {
                    Image(systemName: "line.3.horizontal")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                    }.opacity(showSideMenu ? 0 : 1)
                    Text("Hello \(profileViewModel.isLoading ? "..." : profileViewModel.profile.username),".capitalized)
                        .font(.callout)
                       
                }
                Spacer()
                HStack{
                    Image(systemName: "bell.fill")
                        .font(.title2)
                    
                    Image(systemName: "bookmark.square")
                        .font(.title2)
                }

            }
            .padding()
            .padding([.horizontal,.top])
            .padding(.bottom,8)
            .padding(.top,getSafeArea().top)
            
           
            
            TabView (selection: $currentTab){
                HomeTabView().tag("Home")
                Text("My Wallet").tag("My Wallet")
                Text("Transactions").tag("Transactions")
                Text("Settings").tag("Settings")
            }
            
            
        }
        
        .disabled(showSideMenu)
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .overlay(
            Button {
                withAnimation(.spring()){
                    showSideMenu = false
                }
                
            } label: {
            Image(systemName: "xmark")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                    .opacity(showSideMenu ? 1 : 0)
                    .padding()
                    .padding(.top)
            },alignment: .topLeading)
        .background(Color.systemBacground)
    }
}



struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
