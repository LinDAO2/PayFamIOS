//
//  ProfleModel.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct ProfileModel : Codable  {
    @DocumentID var id: String?
    var uid: String
    var username : String
    var firstName : String
    var lastName : String
    var email : String?
    var country : String?
    var phoneNumber: String
    var query: [String]?
    var persona : ProfilePersona.RawValue?
    var status : ProfileStatus.RawValue?
    var wallets : [ProfileWallet]?
    var momoPhoneNumber : String?
    var bankAccount : ProfilePaystackBankAccount?
    var usdtBalance : Double?
    var ghsBalance : Double?
    var ngnBalance : Double?
    
}

struct ProfileWallet : Codable {
    let name :String
    let balance : Int
    
}




struct ProfilePaystackBankAccount : Codable {
    let paystack :ProfilePaystackBankAccountData
}
struct ProfilePaystackBankAccountData : Codable {
    let   accountName : String
    let   accountNumber: String
    let   bankCode : String
    let   bankName : String
    let   psrecieptCode : String

}

enum ProfilePersona : String {
    case customer = "customer"
    case mgt  = "mgt"
}

enum ProfileStatus : String {
    case active = "active"
    case inactive  = "inactive"
    case blocked  = "blocked"
}
