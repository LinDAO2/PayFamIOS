//
//  ProfileViewModel.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import Foundation
import Combine
import Firebase

final class ProfileViewModel : ObservableObject {
    @Published var profile : ProfileModel = ProfileModel()
    @Published var isLoading : Bool = false
    @Published var isError : Bool = false
    @Published var errorMsg : String = ""
    
    init(){
        Task{
            await getProfile()
        }
    }
    
    @MainActor
    func getProfile() async{
        self.isLoading = true
        do {
            
            let db  = Firestore.firestore()
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
}

