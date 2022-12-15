//
//  PaystackRepository.swift
//  PayFam
//
//  Created by Mattosha on 03/12/2022.
//

import Foundation


class PaystackRepository : ObservableObject {
    
    static var instance = PaystackRepository()
    
    @Published var bankList : [PSBankItem] = []
    @Published var resolvedBankAccountInfo : PSResolveAccountDetails?
    @Published var resolvedCheckoutReponse : PSCheckoutReponse?
    @Published var isProcessing : Bool =  false
   
    
  
    @MainActor
    func  getBanks() async{
        let url = URL(string: "https://api.paystack.co/bank")!
        var urlRequest = URLRequest(url: url)

        urlRequest.setValue( "Bearer sk_test_ac615fa6f28fc3cf7de8be4f219bc3165c6f4167", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                print("No data")
                return
            }
            
            
            guard let psBankResponse = try? JSONDecoder().decode(PSBankResponse.self, from: content) else {
                print("Not containing JSON")
                 return
            }
            
            DispatchQueue.main.async {
                self.bankList = psBankResponse.data
            }
            
        }

        // execute the HTTP request
        task.resume()
    }
    
    @MainActor
    func resolveBankAccountDetails(accountNumber : String, bankCode : String) async {
        
        let url = URL(string: "https://api.paystack.co/bank/resolve?account_number=\(accountNumber)&bank_code=\(bankCode)")!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue( "Bearer sk_test_ac615fa6f28fc3cf7de8be4f219bc3165c6f4167", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                print("No data")
                return
            }
            
            
            guard let psBankResponse = try? JSONDecoder().decode(PSResolveAccountDetails.self, from: content) else {
                print("Not containing JSON")
                 return
            }
            

            DispatchQueue.main.async {
                self.resolvedBankAccountInfo = psBankResponse
            }
            
        }

        // execute the HTTP request
        task.resume()
        
    }
    
    
 
    func generateCheckoutUrl(email :String, amount : String, reference : String) async {
        let url = URL(string: "https://api.paystack.co/transaction/initialize")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let body = ["email": email,"amount": amount, "reference": reference]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        urlRequest.httpBody = bodyData
        urlRequest.setValue( "Bearer sk_test_ac615fa6f28fc3cf7de8be4f219bc3165c6f4167", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                print("No data")
                return
            }
            
            
            guard let psCheckoutReponse = try? JSONDecoder().decode(PSCheckoutReponse.self, from: content) else {
                print("Not containing JSON")
                 return
            }
            
            DispatchQueue.main.async {
                self.resolvedCheckoutReponse = psCheckoutReponse
            }
            
        }

        // execute the HTTP request
        task.resume()
    }
    
    
    
    
    func verifyTransaction(reference: String)async throws -> Bool {
        let url = URL(string: "https://api.paystack.co/transaction/verify/\(reference)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        urlRequest.setValue( "Bearer sk_test_ac615fa6f28fc3cf7de8be4f219bc3165c6f4167", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let response = try? JSONDecoder().decode(VerifyTransactionResponse.self, from: data)
        
        if response?.status == true && response?.data?.status == "success" {
            return true
        }else{
            return false
        }
    }
    
    
    func createTransferReceiptCode(accountName: String,accountNumber : String,bankCode : String)async throws -> String? {
        let url = URL(string: "https://api.paystack.co/transferrecipient")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let body = ["type": "nuban","name": accountName, "account_number": accountNumber,"bank_code":bankCode,"currency": "NGN"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        urlRequest.httpBody = bodyData
        urlRequest.setValue( "Bearer sk_test_ac615fa6f28fc3cf7de8be4f219bc3165c6f4167", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let response = try? JSONDecoder().decode(TransferReceiptCodeResponse.self, from: data)
        
//        print(String(data: try JSONEncoder().encode(response), encoding: .utf8) ?? "sxx")
        if response?.status == true && response?.data?.recipientCode != nil {
            return response?.data?.recipientCode
        }else{
            return nil
        }
    }
    
    
    func initiateTransfer(recipient: String,amount: Int,reference : String)async throws -> Bool {
        let url = URL(string: "https://api.paystack.co/transfer")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let body = [
            "source": "balance",
                    "reference": reference,
                    "recipient":recipient,
                    "amount":amount,
                    "reason":"Payfam cashout"
        ] as [String : Any]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        urlRequest.httpBody = bodyData
        urlRequest.setValue( "Bearer sk_test_ac615fa6f28fc3cf7de8be4f219bc3165c6f4167", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            let response = try? JSONDecoder().decode(InitiateTransferResponse.self, from: data)
            

            if response?.status == true  {
               
                return true
            }else{
               
                return false
            }
           
        }catch{
            
            print(error)
            return false
            
           
        }
    }
    
    
    func verifyTransfer(reference : String)async throws -> Bool {
        let url = URL(string: "https://api.paystack.co/transfer/verify/\(reference)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue( "Bearer sk_test_ac615fa6f28fc3cf7de8be4f219bc3165c6f4167", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let response = try? JSONDecoder().decode(VerifyTransferResponse.self, from: data)
        

        if response?.status == true  && response?.data?.status == "success"  {
            return true
        }else{
            return false
        }
    }
    
    func generateReferenceId() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<8).map{ _ in letters.randomElement()! })
    }
}



struct VerifyTransferResponse : Decodable {
    let status: Bool
    let message: String
    let data: VerifyTransferData?
}

struct VerifyTransferData : Decodable {
    let status : String
}


struct InitiateTransferResponse : Decodable {
    let status: Bool
    let message: String
}

// MARK: - TransferReceiptCodeResponse
struct TransferReceiptCodeResponse : Decodable {
    let status: Bool
    let message: String
    let data: TransferReceiptCodeData?
}

// MARK: - TransferReceiptCodeData
struct TransferReceiptCodeData : Decodable{

    let recipientCode : String
    
    enum CodingKeys : String, CodingKey {
        case recipientCode = "recipient_code"
    }

}





// MARK: - PSCheckoutReponse
struct PSCheckoutReponse : Codable {
    let status: Bool
    let message: String
    let data: PSCheckoutReponseData?
}

// MARK: - PSCheckoutURLData
struct PSCheckoutReponseData : Codable {
    let authorizationURL: String
    let accessCode, reference: String
    
    enum CodingKeys: String, CodingKey {
        case authorizationURL = "authorization_url"
        case accessCode = "access_code"
        case reference = "reference"
    }
}



// MARK: - PSResolveAccountDetails
struct PSResolveAccountDetails : Codable {
    let status: Bool
    let message: String
    let data: PSResolveAccountDetailsData?
}

// MARK: - PSResolveAccountDetailsData
struct PSResolveAccountDetailsData : Codable {
    let accountNumber, accountName: String
    let bankID: Int
    
    enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case accountName = "account_name"
        case bankID = "bank_id"
    }
}





// MARK: - PSBankResponse
struct PSBankResponse: Codable {
    let status: Bool
    let message: String
    let data: [PSBankItem]
}

// MARK: - PSBankItem
struct PSBankItem: Codable {
    let id: Int
    let name, slug, code, longcode: String
    let gateway: Gateway?
    let payWithBank, active: Bool
    let country: Country
    let currency: Currency
    let type: String?
    let isDeleted: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug, code, longcode, gateway
        case payWithBank = "pay_with_bank"
        case active, country, currency, type
        case isDeleted = "is_deleted"
        case createdAt, updatedAt
    }
}

enum Country: String, Codable {
    case nigeria = "Nigeria"
}

enum Currency: String, Codable {
    case ngn = "NGN"
}

enum Gateway: String, Codable {
    case digitalbankmandate = "digitalbankmandate"
    case emandate = "emandate"
    case empty = ""
    case ibank = "ibank"
}



// MARK: - VerifyTransactionResponse
struct VerifyTransactionResponse : Decodable {
    let status: Bool
    let message: String
    let data: VerifyTransactionData?
}

// MARK: - DataClass
struct VerifyTransactionData : Decodable {
    let id: Int
    let domain, status, reference: String
//    let amount: Int
//    let message: NSNull
//    let gatewayResponse, dataPaidAt, dataCreatedAt, channel: String
//    let currency, ipAddress, metadata: String
//    let log: Log
//    let fees: Int
//    let feesSplit: NSNull
//    let authorization: Authorization
//    let customer: Customer
//    let plan: NSNull
//    let split: AnyObject
//    let orderID: NSNull
//    let paidAt, createdAt: String
//    let requestedAmount: Int
//    let posTransactionData, source, feesBreakdown: NSNull
//    let transactionDate: String
//    let planObject, subaccount: AnyObject
}

//// MARK: - Authorization
//struct Authorization : Decodable {
//    let authorizationCode, bin, last4, expMonth: String
//    let expYear, channel, cardType, bank: String
//    let countryCode, brand: String
//    let reusable: Bool
//    let signature: String
//    let accountName: NSNull
//}
//
//// MARK: - Customer
//struct Customer : Decodable{
//    let id: Int
//    let firstName, lastName: NSNull
//    let email, customerCode: String
//    let phone, metadata: NSNull
//    let riskAction: String
//    let internationalFormatPhone: NSNull
//}
//
//// MARK: - Log
//struct Log : Decodable{
//    let startTime, timeSpent, attempts, errors: Int
//    let success, mobile: Bool
//    let input: [Any?]
//    let history: [History]
//}
//
//// MARK: - History
//struct History : Decodable {
//    let type, message: String
//    let time: Int
//}
