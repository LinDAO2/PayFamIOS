//
//  HomeBalanceSubView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct HomeBalanceSubView: View {
    
    @StateObject var profileViewModel : ProfileViewModel = ProfileViewModel()
    
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    NavigationLink{
                        MultipleWalletView()
                    }label: {
                        HStack{
                            Spacer()
                            Text("See all")
                                .font(.callout)
                                .foregroundColor(.primary.opacity(0.7))
                            Image(systemName: "chevron.right")
                                .font(.callout)
                                .foregroundColor(.primary.opacity(0.7))
                        }
                           
                    }
                    
                    if profileViewModel.isLoading {
                        ProgressView()
                    }else{
                       
                        Text(profileViewModel.profile.usdtBalance ?? 0,format:.currency(code: "USD"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                        
                        
                    }
                    
                 
                   
                  
                    
                    Text("Balance")
                        .font(.headline)
                        .padding(.bottom,20)
                }
                .padding()
                
                .frame(maxWidth: .infinity)
            }
            
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius:20,style:.continuous))
            .shadow(color:Color.primary.opacity(0.2),radius: 10,x: 0,y: 5)
        }
        .padding(.all,10)
        
    }
}

struct HomeBalanceSubView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBalanceSubView()
    }
}
