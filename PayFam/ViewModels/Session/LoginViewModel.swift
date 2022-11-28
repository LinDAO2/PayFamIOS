//
//  LoginViewModel.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    
    @Published var phNo = ""
    @Published var code = ""
    
    
    @Published var errorMsg = ""
    @Published var error = false
    
    @Published var CODE = ""
    
    @Published var gotoVerify  = false
    
    
    func getCountryCode()->String{
        let regionCode  = Locale.current.language.region?.identifier ?? ""
        
        return countries[regionCode] ?? ""
    }
    
    //send code to user
    func sendCode(){
       
        //enable testing mode
        //disable when testing with real device
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        let number = "+\(getCountryCode())\(phNo)"
        
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil){
            (CODE,err) in
            
            if  let error  = err {
                self.errorMsg = error.localizedDescription
                self.error.toggle()
                print(error)
                return
            }
            
            self.CODE = CODE!
            self.gotoVerify = true
        }
    }
}
