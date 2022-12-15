//
//  RedeemFundsList.swift
//  PayFam
//
//  Created by Mattosha on 10/12/2022.
//

import SwiftUI

struct RedeemFundsList: View {
    @StateObject var transactionsViewModel : TransactionsViewModel = TransactionsViewModel()
    @State private var isLoading : Bool = false
    @EnvironmentObject private var profileViewModel : ProfileViewModel
    
    var body: some View {
        VStack{
            Text("Redeem funds")
                .font(.title)
                .fontWeight(.bold)
            
            if isLoading {
                HStack{
                    Spacer()
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.primary)
                    ProgressView()
                    Spacer()
                }
                .padding()
            }
            
            if transactionsViewModel.transactionList.count > 0 {
                List{
                    ForEach(transactionsViewModel.transactionList, id: \.uid ){transaction in
                        
                        VStack{
                         
                            
                            if !transaction.isRedeemed {
                                
                                NavigationLink{
                                    RedeemFunds(recieverPhonenumber: transaction.recieverPhonenumber, redemptionCode: transaction.redemptionCode)
                                }label: {
                                    HStack(alignment:.center){
                                       
                                        VStack(alignment: .leading){
                                           
                                            Text(transaction.isRedeemed == true ? transaction.senderName : transaction.recieverName)
                                                .font(.callout)
                                                .fontWeight(.bold)
                                            Text(transaction.isRedeemed == true ? transaction.senderPhonenumber : transaction.recieverPhonenumber)
                                                .font(.caption)
                                            
                                            
                                            Text("You recieved \(transaction.currency) \(transaction.amount) via \(transaction.paymentMethod)").font(.caption)
                                            
                                           
                                            
                                        }
                                        Spacer()
                                        if transaction.isRedeemed == true {
                                            Text("Redeemed".uppercased())
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                                .padding(.all,8)
                                                .background(Color.green)
                                                .clipShape(Capsule())
                                        }
                                        if transaction.isRedeemed == false {
                                            Button {
                                                
                                            } label: {
                                                Text("Redeem".uppercased())
                                                    .font(.caption2)
                                                    .foregroundColor(.white)
                                                    .padding(.all,8)
                                                    .background(Color.accentColor)
                                                    .clipShape(Capsule())
                                            }

                                        }
                                    }
                                    .padding()
                                }
                               
                            }
                        }
                       
                    }
                }
            
                
                .listStyle(.plain)
            }else {
                Text("No transaction yet!")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.top,60)
                Image("content-empty")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(Color.primary)
                    .frame(width:150,height:150)
            }
            
         
            
            Spacer()
            
            
        }
        .refreshable{
            isLoading = true
            Task {
                await transactionsViewModel.getToRedeemTransactions(profilePhonenumber: profileViewModel.profile.phoneNumber)
                isLoading = false
            }
        }
        .onAppear(perform: {
            isLoading = true
            Task {
                await transactionsViewModel.getToRedeemTransactions(profilePhonenumber: profileViewModel.profile.phoneNumber)
                isLoading = false
            }
            
        })
    }
}

struct RedeemFundsList_Previews: PreviewProvider {
    static var previews: some View {
        RedeemFundsList()
    }
}
