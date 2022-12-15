//
//  TransactionModel.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct TransactionModel : Codable {
    @DocumentID var id: String?
    let uid : String
    let recieverName: String
    let recieverPhonenumber: String
    let currency:String
    let redeemedcurrency:String
    let amount: Int
    let redemptionCode: String
    let isRedeemed : Bool
    let paymentMethod : String
    let senderID: String
    let senderName: String
    let senderPhonenumber: String
    let momoReferenceId : String?
    @ServerTimestamp var addedOn : Timestamp?
    
}

struct RecipientModel : Codable {
    @DocumentID var id: String?
    let uid : String
    let userId : String
    let recieverName : String
    let recieverPhonenumber : String
    @ServerTimestamp var addedOn : Timestamp?
 
}

struct RecipientInputModel : Codable {
    @DocumentID var id: String?
    let uid : String
    let userId : String
    let recieverName : String
    let recieverPhonenumber : String
    var addedOn : Timestamp
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

