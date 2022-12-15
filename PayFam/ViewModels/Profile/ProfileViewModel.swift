//
//  ProfileViewModel.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import Foundation
import Firebase
import FirebaseFirestore

final class ProfileViewModel : ObservableObject {
    @Published var profile : ProfileModel = ProfileModel(uid: "", username: "",firstName: "", lastName: "", phoneNumber: "")
    @Published var isLoading : Bool = false
    @Published var isError : Bool = false
    @Published var errorMsg : String = ""
    
    static let instance = ProfileViewModel()
    
    private  let db : Firestore
    
    init(){
        self.db = Firestore.firestore()
        
        Task{
            await getProfile()
        }
       
    }
    
    @MainActor
    func getProfile() async{
        self.isLoading = true
        do {

           
            let docRef = db.collection("Profiles").document("EcFen71RslfXWtV5G96n")
            let document = try await  docRef.getDocument()
            
            if document.exists {
                profile = try document.data(as: ProfileModel.self)
             
            }
            
            self.isLoading = false
        }catch{
            self.isError = true
            self.errorMsg = error.localizedDescription
            print(error)
            self.isLoading = false
        }
        

    }
    
    
    func updateNGNBalance(uid:String, amount :Double) async {
        let docRef = db.collection("Profiles").document(uid)
        do {
           try await  docRef.setData([
            "ngnBalance":  FieldValue.increment(amount)
            ],merge: true)
            
        }catch{
           
            print(error)
          
        }
    }
    
    func updateGHSBalance(uid:String, amount :Double) async {
        let docRef = db.collection("Profiles").document(uid)
        do {
           try await  docRef.setData([
            "ghsBalance":  FieldValue.increment(amount)
            ],merge: true)
            
        }catch{
           
            print(error)
          
        }
    }
    
    func updateUSDTBalance(uid:String, amount :Double) async {
        let docRef = db.collection("Profiles").document(uid)
        do {
           try await  docRef.setData([
            "usdtBalance":  FieldValue.increment(amount)
            ],merge: true)
            
        }catch{
           
            print(error)
          
        }
    }
    
    func updateBankAccount(uid:String, bankAccount : ProfilePaystackBankAccount) async throws -> Bool {
        let docRef = db.collection("Profiles").document(uid)
        let json = try JSONEncoder().encode(bankAccount)
        let jsonString = String(data: json, encoding: .utf8) ?? ""
        let dict = jsonString.convertToDictionary()

        do {
           try await  docRef.setData([
            "bankAccount": dict  as Any
            ],merge: true)
            
            return true
        }catch{
           
            print(error)
          return false
        }
    }
    
    func removeBankAccount(uid:String) async   {
        let docRef = db.collection("Profiles").document(uid)
        
        do{
            try await  docRef.updateData([
             "bankAccount": FieldValue.delete(),
             ])
             
             
        }catch{
            
            print(error)
        
        }
    }
}

