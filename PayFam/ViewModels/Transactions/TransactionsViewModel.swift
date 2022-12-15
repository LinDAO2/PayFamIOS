//
//  TransactionsViewModel.swift
//  PayFam
//
//  Created by Mattosha on 06/12/2022.
//

import Foundation
import Firebase
import FirebaseFirestore


class TransactionsViewModel : ObservableObject {
    @Published var transactionList  =  [TransactionModel]()
    @Published var recipientList  =  [RecipientModel]()
    
    static let instance = TransactionsViewModel()
    
    private  let db : Firestore
    
    init(){
        self.db = Firestore.firestore()
    }
    
    func addTransaction(transaction:TransactionModel) async {
        if let id = transaction.id {
          let docRef = db.collection("Transactions").document(id)
          do {
            try docRef.setData(from: transaction)
          }
          catch {
            print(error)
          }
        }
    }
    
    @MainActor
    func getSentTransactions(senderId : String) async {
        let docRef =  db.collection("Transactions")
            .whereField("senderID", isEqualTo: senderId)
//            .whereField("isRedeemed", isEqualTo: false)
            .order(by: "addedOn", descending: true)
        
        do {
            let querySnapshot =  try await docRef.getDocuments()
            
          
            self.transactionList = querySnapshot.documents.compactMap{  queryDocumentSnapshot -> TransactionModel in
                return try! queryDocumentSnapshot.data(as:TransactionModel.self )
            }
//                self.transactionList = querySnapshot.documents.map{ d in
//                    return TransactionModel(uid: d.documentID, recieverName: d["recieverName"] as? String ?? "", recieverPhonenumber: d["recieverPhonenumber"] as? String ?? "", currency: d["currency"] as? String ?? "", redeemedcurrency: d["redeemedcurrency"] as? String ?? "", amount: d["amount"] as? Int ?? 0, redemptionCode: d["redemptionCode"] as? String ?? "", isRedeemed: d["isRedeemed"] as? Bool ?? false, paymentMethod: d["paymentMethod"] as? String ?? "", senderID: d["senderID"] as? String ?? "", senderName: d["senderName"] as? String ?? "", senderPhonenumber: d["senderPhonenumber"] as? String ?? "", momoReferenceId: d["momoReferenceId"] as? String ?? "")
//                }
            
          
            
        }
        catch {
          print(error)
        }
           
    }
    
    @MainActor
    func getToRedeemTransactions(profilePhonenumber : String) async {
        let docRef =  db.collection("Transactions")
            .whereField("recieverPhonenumber", isEqualTo: profilePhonenumber)
            .whereField("isRedeemed", isEqualTo: false)
            .order(by: "addedOn", descending: true)
        
        do {
            let querySnapshot =  try await docRef.getDocuments()
            
            self.transactionList = querySnapshot.documents.compactMap{  queryDocumentSnapshot -> TransactionModel in
                return try! queryDocumentSnapshot.data(as:TransactionModel.self )
            }
          
            
        }
        catch {
          print(error)
        }
           
    }
    
    @MainActor
    func getRedeemedTransactions(profilePhonenumber : String) async {
        let docRef =  db.collection("Transactions")
            .whereField("recieverPhonenumber", isEqualTo: profilePhonenumber)
            .whereField("isRedeemed", isEqualTo: true)
            .order(by: "addedOn", descending: true)
        
        do {
            let querySnapshot =  try await docRef.getDocuments()
            
            self.transactionList = querySnapshot.documents.compactMap{  queryDocumentSnapshot -> TransactionModel in
                return try! queryDocumentSnapshot.data(as:TransactionModel.self )
            }
          
            
        }
        catch {
          print(error)
        }
           
    }
    
    func generateRedeemCode() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    func getTransactionByRedemptionCode(recieverPhonenumber : String,redemptionCode:String ) async throws -> TransactionModel {
        let docRef =  db.collection("Transactions")
            .whereField("recieverPhonenumber", isEqualTo: recieverPhonenumber)
            .whereField("redemptionCode", isEqualTo: redemptionCode)
        
     
            let querySnapshot =  try await docRef.getDocuments()
            
        let list =  querySnapshot.documents.compactMap{  queryDocumentSnapshot -> TransactionModel in
            return try! queryDocumentSnapshot.data(as:TransactionModel.self )
        }
 

          return list[0]
    }
    
    func markTransactionAsRedeemed(uid: String, selectedCurrency: String) async{
        let docRef =  db.collection("Transactions").document(uid)
        
        do {
            try await  docRef.setData([
             "isRedeemed":  true,
             "redeemedcurrency": selectedCurrency
             ],merge: true)
            
        }catch{
            print(error)
        }
    }
    
    @MainActor
    func getRecipients(userId:String) async {
        let docRef =  db.collection("Recipients")
            .whereField("userId", isEqualTo: userId)
            .order(by: "addedOn", descending: true)
        
       
        do {
            let querySnapshot =  try await docRef.getDocuments()
            
            let list =  querySnapshot.documents.map{ d in
                return RecipientModel(uid: d["uid"] as? String ?? "", userId: d["userId"] as? String ?? "", recieverName:  d["recieverName"] as? String ?? "", recieverPhonenumber:  d["recieverPhonenumber"] as? String ?? "", addedOn:  d["addedOn"] as? Timestamp ?? Timestamp(date: Date()))
                }
                
            self.recipientList = list
            
        } catch{
            print(error)
        }
            
       
    }

    
    func addRecipient(recipient:RecipientModel) async {
        if let id = recipient.id {
          let docRef = db.collection("Recipients").document(id)
          do {
            try docRef.setData(from: recipient)
          }
          catch {
            print(error)
          }
        }
    }
    
}
