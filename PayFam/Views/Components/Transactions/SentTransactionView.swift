//
//  SentTransactionView.swift
//  PayFam
//
//  Created by Mattosha on 10/12/2022.
//

import SwiftUI

struct SentTransactionView: View {
    
    let transaction : TransactionModel
    
    init(transaction: TransactionModel) {
        self.transaction = transaction
    }
    
    var body: some View {
        HStack(alignment:.center){
           
            VStack(alignment: .leading){
               
                Text( transaction.recieverName)
                    .font(.callout)
                    .fontWeight(.bold)
                Text( transaction.recieverPhonenumber)
                    .font(.caption)
            
                    Text("You sent \(transaction.currency) \(transaction.amount) via \(transaction.paymentMethod)").font(.caption)
                
                
               
                
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
                Text("Not Redeemed".uppercased())
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.all,8)
                    .background(Color.accentColor.opacity(0.4))
                    .clipShape(Capsule())

            }
        }
        .padding()
    }
}

