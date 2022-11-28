//
//  VerificationView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct VerificationView: View {
    
    @ObservedObject var loginData : LoginViewModel
    @Environment(\.presentationMode) var presentationModel
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Button {
                        presentationModel.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    Text("Verify OTP")
                        .font(.title2.bold())
                    Spacer()

                }
                .padding()
                
                Text("OTP was sent to \(loginData.phNo)")
                    .foregroundColor(.gray)
                    .padding(.bottom)
             Spacer(minLength: 0)
                HStack(spacing:15){
                    ForEach(0..<6 , id : \.self){index in
                        
                        Code(code: getCodeAtIndex(index: index))
                        
                    }
                }
                .padding()
                .padding(.horizontal,20)
             Spacer(minLength: 0)
                
                HStack(spacing:6){
                    Text("Did not recieve code?")
                        .foregroundColor(.gray)
                    
                    Button {
                        
                    } label: {
                        Text("Request Again")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }

                }
                
                Button {
                    
                } label: {
                    Text("Get by call")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .padding(.top,6)
                
                Button {
                    
                } label: {
                    Text("Verify and Create Account")
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .frame(width: getScreenBounds().width - 30)
                        .background(Color.secondaryBrandColor)
                        .cornerRadius(15)
                    
                }
                .padding()
            }
            .frame(height:getScreenBounds().height / 1.8)
            .background(.white)
            .cornerRadius(20)
            //numpad
                Numpad(value: $loginData.code, isVerify: true)
        }
        .background(.regularMaterial)
        .ignoresSafeArea(.all,edges: .bottom)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func getCodeAtIndex(index: Int)->String{
        if loginData.code.count > index {
            let start = loginData.code.startIndex
            let current = loginData.code.index(start,offsetBy: index)
            
            return String(loginData.code[current])
        }
        
        return ""
    }
}



struct Code: View {
    var code : String
    var body: some View {
        VStack(spacing:10){
            Text(code)
                .foregroundColor(.black)
                .font(.title2)
                .fontWeight(.bold)
            
                .frame(height:45)
            
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(height: 4)
        }
    }
}
