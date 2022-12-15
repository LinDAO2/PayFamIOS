//
//  TransactionListView.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import SwiftUI

struct TransactionListView: View {
   
    @State private var selectedTab : String = "Sent"
    
    let optionsList : [String] = [
        "Sent",
        "To Redeem",
        "Redeemed"
    ]
    
    
    @StateObject var transactionsViewModel : TransactionsViewModel = TransactionsViewModel()
    
    @EnvironmentObject private var profileViewModel : ProfileViewModel
    
    @State private var isLoading : Bool = false
    
    var body: some View {
        VStack{
            Text("Transactions")
                .font(.title)
                .fontWeight(.bold)
            
          
            
            Picker(
                selection: $selectedTab ,
                label:Text("picker")){
                    ForEach(0..<optionsList.count, id: \.self){ index in
                    Text(optionsList[index])
                        .tag(optionsList[index])
                    
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedTab) {
                if $0 == "Sent" {
                    isLoading = true
                    Task {
                        await transactionsViewModel.getSentTransactions(senderId: profileViewModel.profile.uid)
                        isLoading = false
                    }
                }
                if $0 == "To Redeem" {
                    isLoading = true
                    Task {
                        await transactionsViewModel.getToRedeemTransactions(profilePhonenumber: profileViewModel.profile.phoneNumber)
                        isLoading = false
                    }
                }
                
                if $0 == "Redeemed" {
                    isLoading = true
                    Task {
                        await transactionsViewModel.getRedeemedTransactions(profilePhonenumber:profileViewModel.profile.phoneNumber)
                        isLoading = false
                    }
                }
            }
            
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
                            if profileViewModel.profile.uid == transaction.senderID {
                                SentTransactionView(transaction: transaction)
                            }else if !transaction.isRedeemed && profileViewModel.profile.phoneNumber == transaction.recieverPhonenumber {
                                ToRedeemTransactions(transaction: transaction)
                            }else{
                                RedeemedTransactionView(transaction: transaction)
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
        .refreshable {
            selectedTab  = "Sent"
            
            if  selectedTab  == "Sent" {
                isLoading = true
                Task {
                    await transactionsViewModel.getSentTransactions(senderId: profileViewModel.profile.uid)
                    isLoading = false
                }
            }
            
            if  selectedTab  == "To Redeem" {
                isLoading = true
                Task {
                    await transactionsViewModel.getToRedeemTransactions(profilePhonenumber: profileViewModel.profile.phoneNumber)
                    isLoading = false
                }
            }
            
            if  selectedTab  == "Redeemed" {
                isLoading = true
                Task {
                    await transactionsViewModel.getRedeemedTransactions(profilePhonenumber:profileViewModel.profile.phoneNumber)
                    isLoading = false
                }
            }
            
        }
        .onAppear(perform: {
           
            
            isLoading = true
            Task {
                await transactionsViewModel.getSentTransactions(senderId: profileViewModel.profile.uid)
                isLoading = false
            }
            
        })
       
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
