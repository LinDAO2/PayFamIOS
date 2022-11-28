//
//  MainView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct MainView: View {
    
    @State var currentTab : String = "Home"
    
    @State var showSideMenu : Bool = false
    
    //Hiding native tab bar
    
    init() {
    
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack{
            
            SideMenuView(currentTab: $currentTab ,showSideMenu: $showSideMenu)
                
            
            MainTabView(currentTab: $currentTab,showSideMenu: $showSideMenu)
                .cornerRadius(showSideMenu ? 25 : 0)
                .rotation3DEffect(.init(degrees: showSideMenu ? -15 : 0), axis : (x : 0 , y : 1 , z : 0 ), anchor: .trailing)
                .offset(x: showSideMenu ? getScreenBounds().width / 2 : 0)
                .ignoresSafeArea()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
