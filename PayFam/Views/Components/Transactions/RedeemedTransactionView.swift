//
//  RedeemedTransactionView.swift
//  PayFam
//
//  Created by Mattosha on 10/12/2022.
//

import SwiftUI

struct RedeemedTransactionView: View {
    let transaction : TransactionModel
    
    init(transaction: TransactionModel) {
        self.transaction = transaction
    }
    
    var body: some View {
        HStack(alignment:.center){
        
                    VStack(alignment: .leading){
                        Text("From").font(.callout).foregroundColor(Color.primary.opacity(0.6))
                        Text(transaction.senderName)
                            .font(.callout)
                            .fontWeight(.bold)
                        Text(transaction.senderPhonenumber)
                            .font(.caption)

                            Text("Sent \(transaction.currency) \(transaction.amount) via \(transaction.paymentMethod)").font(.caption)
                        Text("Recieved \(transaction.redeemedcurrency) \(transaction.amount)").font(.caption)


                    }
                    Spacer()
                  
                        Text("Redeemed".uppercased())
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.all,8)
                            .background(Color.green)
                            .clipShape(Capsule())
                    
              
                }
                .padding()
    }
}


