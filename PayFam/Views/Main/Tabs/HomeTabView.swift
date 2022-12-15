//
//  HomeTabView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        ScrollView{
         
            HomeBalanceSubView()
            HomeCarouselSubView()
            HomeActionsSubView()
            HomePayFamAgain()
//            HomeTransactions()
        }
        .padding(.all,2)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .onAppear(perform: {
            NotificationManager.instance.requestAuthorization()
            UIApplication.shared.applicationIconBadgeNumber = 0
        })
       
        
    }
}


struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
