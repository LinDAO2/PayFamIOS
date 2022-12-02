//
//  LoginView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    @State var isSmallScreen  = UIScreen.main.bounds.height < 750
 
    @State private var path: [String] = [] // Nothing on the stack by default.

    
    
    var body: some View {
        NavigationStack(path: $path){
            ZStack{
                VStack{
                    VStack{
                        Text("Continue With phone")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                        
                        Image("LoginMobileImg")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        
                        Text("You will recieve a 6 digit code\n to verify next.")
                            .font(isSmallScreen ? .none : .title2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding()
                        
                        
                        
                        //MARK: mobile number field
                        HStack{
                            VStack(alignment: .leading, spacing:6){
                                Text("Enter Your Number")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("+ \(loginViewModel.getCountryCode()) \(loginViewModel.phNo)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                             
                            }
                            Spacer(minLength: 0)
                            
                         
                           
                                
                            Button {
                                loginViewModel.sendCode()
                                
                                path.append("verify")
                                
                            } label: {
                                Text("Continue")
                                    .foregroundColor(.white)
                                    .padding(.vertical,18)
                                    .padding(.horizontal,38)
                                    .background(Color.primaryBrandColor)
                                    .cornerRadius(15)
                            }
                            .disabled(loginViewModel.phNo == "" ? true : false)

                         
                            
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1),radius: 5, x : 0 , y : -5)
                        
                        
                    }
                    .frame(height:getScreenBounds().height / 1.8)
                    .background(.white)
                    .cornerRadius(20)
                   
                //numpad
                    Numpad(value: $loginViewModel.phNo, isVerify: false)
                }
                .background(.regularMaterial)
                .ignoresSafeArea(.all,edges: .bottom)
                
                if loginViewModel.error {
                    AlertView(msg: loginViewModel.errorMsg, show: $loginViewModel.error)
                }
            }
            .navigationDestination(for: String.self) { string in
                      VerificationView(loginData: loginViewModel)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
      
    }
       
    

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
