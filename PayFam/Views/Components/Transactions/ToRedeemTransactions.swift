//
//  ToRedeemTransactions.swift
//  PayFam
//
//  Created by Mattosha on 10/12/2022.
//

import SwiftUI

struct ToRedeemTransactions: View {
    
    
    let transaction : TransactionModel
    
    init(transaction: TransactionModel) {
        self.transaction = transaction
    }
    
    var body: some View {
        NavigationLink{
           RedeemFunds(recieverPhonenumber: transaction.recieverPhonenumber, redemptionCode: transaction.redemptionCode)
       }label: {
           HStack(alignment:.center){

               VStack(alignment: .leading){

                   Text(transaction.senderName )
                       .font(.callout)
                       .fontWeight(.bold)
                   Text(transaction.senderPhonenumber)
                       .font(.caption)


                 
                       Text("You were sent \(transaction.currency) \(transaction.amount) via \(transaction.paymentMethod)").font(.caption)
                   



               }
               Spacer()
         
             
                    Text("Redeem".uppercased())
                   .font(.caption2)
                   .foregroundColor(.white)
                   .padding(.all,8)
                   .background(Color.accentColor)
                   .clipShape(Capsule())
               
           }
           .padding()
       }
    }
}

