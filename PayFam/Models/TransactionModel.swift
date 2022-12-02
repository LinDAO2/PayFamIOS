//
//  TransactionModel.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct TransactionModel :Identifiable, Codable {
    @DocumentID var id : String?
    var uid : String  = ""
    var recieverName: String  = ""
    var recieverPhonenumber: String  = ""
    var currency: TransactionCurrency.RawValue
    var redeemedcurrency: TransactionCurrency.RawValue
    var amount: Int = 0
    var redemptionCode: String  = ""
    var isRedeemed : Bool = false
    var paymentMethod : TransactionPaymethod.RawValue
    var senderID: String  = ""
    var senderName: String  = ""
    var senderPhonenumber: String  = ""
    
//    init(){
//        self.uid = ""
//        self.recieverName = ""
//        self.recieverPhonenumber = ""
//        self.currency = "NGN"
//        self.redeemedcurrency = "NGN"
//        self.amount =  0
//        self.redemptionCode =  ""
//        self.isRedeemed =  false
//        self.paymentMethod = "none"
//        self.senderID = ""
//        self.senderName = ""
//        self.senderPhonenumber = ""
//    }
}


enum TransactionCurrency : String{
    case GHS = "GHS"
    case NGN = "NGN"
    case USDT = "USDT"
}

enum TransactionPaymethod : String{
    case mobileMobile = "mobileMobile"
    case bankTransfer = "bankTransfer"
    case cryptocurrency = "cryptocurrency"
    case none = "none"
}

