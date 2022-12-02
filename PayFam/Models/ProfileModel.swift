//
//  ProfleModel.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct ProfileModel : Identifiable, Codable  {
    @DocumentID var id: String?
    var uid: String = ""
    var username : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var email : String? = ""
    var country : String? = ""
    var phoneNumber: String = ""
    var query: [String]?  = []
    var persona : ProfilePersona.RawValue?
    var status : ProfileStatus.RawValue?
    var wallets : [ProfileWallet]?
    
    init() {
        self.uid = ""
        self.username = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.country =  ""
        self.query  = []
        self.persona = "customer"
        self.status = "active"
        
    }
    
}

struct ProfileWallet : Codable, Hashable {
    var name :String
    var balance : Int
    
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
