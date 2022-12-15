//
//  MobileMoneyViewModel.swift
//  PayFam
//
//  Created by Mattosha on 02/12/2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Firebase
import FirebaseFirestore


class MobileMoneyViewModel : ObservableObject {
    
    @Published  var isProcessing : Bool = false
    @Published  var isDone : Bool = false
    @Published  var isError : Bool = false
    @Published  var errorMsg : String = ""
    
    var session = URLSession.shared
    
    private  let db : Firestore
    
    init(){
        self.db = Firestore.firestore()
    }
    
    @MainActor
    func setMoMoPhonenumber(profileId : String,momoPhonenumber :String) async{
        isProcessing = true
            let docRef = db.collection("Profiles").document(profileId)
            do {
                try await  docRef.setData(["momoPhoneNumber":momoPhonenumber],merge: true)
                isProcessing = false
                isDone  = true
               }
               catch {
                 print(error)
                   isProcessing = false
                   isError = true
                   errorMsg = error.localizedDescription
            }
        
    }
    
    
    @MainActor
    func removeMoMoPhonenumber(profileId : String) async{
        isProcessing = true
            let docRef = db.collection("Profiles").document(profileId)
            do {
                try await  docRef.setData(["momoPhoneNumber":""],merge: true)
                isProcessing = false
                isDone  = true
               }
               catch {
                 print(error)
                   isProcessing = false
                   isError = true
                   errorMsg = error.localizedDescription
            }
        
    }
    
    func generateAccessToken() async throws -> MoMoAccessTokenResponse{
        let username = "67e467c5-69fa-4b97-92f5-1b9acdcce21a"
        let password = "409f1a1536464a6d9c60c9bd048252d1"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
   
        var request = URLRequest(url: URL(string: "https://sandbox.momodeveloper.mtn.com/collection/token/")!,timeoutInterval: Double.infinity)
        request.addValue("84a3c46c5f55425eb0db2808afd9e78a", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue("sandbox", forHTTPHeaderField: "X-Target-Environment")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        
        let (data, _) = try await session.data(for: request)
        let decoder = JSONDecoder()
        return try! decoder.decode(MoMoAccessTokenResponse.self, from: data)
        

    }
    
    func requestPay(bearerToken: String, values : RequestPayModel)async throws -> String {
        let url = URL(string: "https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        let body = ["amount": values.amount, "currency": values.currency,"externalId" : values.externalID, "payerMessage" : values.payerMessage,"payeeNote":values.payeeNote, "payer":[
            "partyIdType": values.payer.partyIDType,"partyId" : values.payer.partyID]  ] as [String : Any] as [String : Any]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        let referenceId = UUID().uuidString.lowercased()
      
        urlRequest.httpBody = bodyData
        urlRequest.setValue( "Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("84a3c46c5f55425eb0db2808afd9e78a", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        urlRequest.addValue("sandbox", forHTTPHeaderField: "X-Target-Environment")
        urlRequest.addValue(referenceId, forHTTPHeaderField: "X-Reference-Id")
        
        let (_, _) = try await session.data(for: urlRequest)
        
        return referenceId
    }
    
    func requesttoPayTransactionStatus(bearerToken: String,referenceId :String) async throws -> Bool {
        let url = URL(string: "https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay/\(referenceId)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
 
        urlRequest.setValue( "Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("84a3c46c5f55425eb0db2808afd9e78a", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        urlRequest.addValue("sandbox", forHTTPHeaderField: "X-Target-Environment")
      
        
        let (data, _) = try await session.data(for: urlRequest)
        let decoder = JSONDecoder()
        let status =  try? decoder.decode(RequesttoPayTransactionStatusModel.self, from: data)
        
        
        if status?.status == "SUCCESSFUL" {
            return true
        }else{
           
            return false
        }
        
    }
}



struct MoMoAccessTokenResponse : Codable {
    let accessToken, tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

// MARK: - RequestPayModel
struct RequestPayModel {
    let amount, currency, externalID: String
    let payer: RequestPayPayerModel
    let payerMessage, payeeNote: String
}

// MARK: - RequestPayPayerModel
struct RequestPayPayerModel {
    let partyIDType, partyID: String
}


// MARK: - RequesttoPayTransactionStatusModel
struct RequesttoPayTransactionStatusModel : Codable {
    let financialTransactionID, externalID, amount, currency: String
    let payer: RequesttoPayTransactionStatusPayerModel
    let payerMessage, payeeNote, status: String
    
    enum CodingKeys: String, CodingKey {
        case financialTransactionID = "financialTransactionId"
        case externalID = "externalId"
        case amount = "amount"
        case currency = "currency"
        case payerMessage = "payerMessage"
        case payeeNote = "payeeNote"
        case status = "status"
        case payer = "payer"
    }
}

// MARK: - RequesttoPayTransactionStatusPayerModel
struct RequesttoPayTransactionStatusPayerModel : Codable{
    let partyIDType, partyID: String
    
    enum CodingKeys: String, CodingKey {
        case partyIDType = "partyIdType"
        case partyID = "partyId"
        
    }
}


