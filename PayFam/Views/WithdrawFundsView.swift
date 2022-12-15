//
//  WithdrawFundsView.swift
//  PayFam
//
//  Created by Mattosha on 14/12/2022.
//

import SwiftUI

struct WithdrawFundsView: View {
    let title : String
    let method : TransactionPaymethod
    
    @State private var amount : Int  = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private  var showAlert : Bool = false
    @State private  var alertTitle : String = ""
    @State private  var alertMessage : String = ""
    @State private var alertType : AlertType = .info
    
    @State private var isProcessing : Bool = false
    @State private var isLoading : Bool = false
    
    

    
    @StateObject  var paystackRepository : PaystackRepository =  PaystackRepository()
    @StateObject  var profileViewModel : ProfileViewModel =  ProfileViewModel()
//    @StateObject var mobileMoneyViewModel : MobileMoneyViewModel = MobileMoneyViewModel()
//    @EnvironmentObject private var profileViewModel : ProfileViewModel
    
    
    @State private var paystackReferenceId  : String = ""
    @State private var haveInitiateTransfer : Bool = false
    
    let nairaCurrencyFormatter: NumberFormatter = {
        let nairaCurrencyFormatter =  NumberFormatter()
        nairaCurrencyFormatter.numberStyle = .currency
        nairaCurrencyFormatter.currencySymbol = "₦"
        nairaCurrencyFormatter.currencyCode = "NGN"
        nairaCurrencyFormatter.maximumFractionDigits = 2
        nairaCurrencyFormatter.currencyGroupingSeparator = ","
        return nairaCurrencyFormatter
    }()
    let cedisCurrencyFormatter: NumberFormatter = {
        
       let cedisCurrencyFormatter =  NumberFormatter()
        cedisCurrencyFormatter.numberStyle = .currency
        cedisCurrencyFormatter.currencySymbol = "GH₵"
        cedisCurrencyFormatter.currencyCode = "GHS"
        cedisCurrencyFormatter.maximumFractionDigits = 2
        cedisCurrencyFormatter.currencyGroupingSeparator = ","
        return cedisCurrencyFormatter
    }()
    
    init(title : String, method: TransactionPaymethod){
        self.title = title
        self.method = method
        
      
    }
    
    
    var body: some View {
        VStack{
            if isLoading {
                ProgressView()
            }else{
                
                if method == .bankTransfer{
                    if "\(profileViewModel.profile.bankAccount?.paystack.psrecieptCode ?? "")".isEmpty {
                        Text("Add your bank account first before you initiate a withdraw")
                            .font(.caption)
                            .foregroundColor(Color.red)
                            .padding()
                        NavigationLink{
                            WalletStorageView(title:  "Add Bank Account", method: .bankTransfer)
                        }label: {
                           Text("Add Bank Account")
                                .font(.callout)
                                .foregroundColor(.primary)
                                .padding()
                                .background(.thinMaterial)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }else{
                        TextField("₦ 0.00", value: $amount, formatter: nairaCurrencyFormatter)
                            .submitLabel(.done)
                            .padding()
                            .foregroundColor(.primary)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        
                        if Double(amount) > profileViewModel.profile.ngnBalance ?? 0 {
                            Text("This amount is more than your balance")
                                .font(.caption)
                                .foregroundColor(Color.red)
                                .padding()
                        }
                        
                        if !haveInitiateTransfer {
                            Button {
                                
                                if amount < 100 {
                                    alertTitle = "Required!"
                                    alertMessage = "Enter amount. Minimum of 100"
                                    showAlert.toggle()
                                    alertType = .info
                                }else if  Double(amount) > profileViewModel.profile.ngnBalance ?? 0{
                                    alertTitle = "Ooops!"
                                    alertMessage = "This amount is more than your balance"
                                    showAlert.toggle()
                                    alertType = .info
                                }else{
                                    paystackReferenceId =   UUID().uuidString.lowercased()
                                    
                                    print("\(profileViewModel.profile.bankAccount?.paystack.psrecieptCode ?? "")")
                                    
                                    print(paystackReferenceId)
                                    
                                    print("\(amount * 100)")
                                    
                                    isProcessing = true
                                    
                                    Task{
                                        
        //                                await profileViewModel.updateNGNBalance(uid: profileViewModel.profile.uid, amount: Double(-amount))
        //
                                        print("\(profileViewModel.profile.bankAccount?.paystack.psrecieptCode ?? "")")
                                        
                                        let initiateStatus = try await paystackRepository.initiateTransfer(recipient: "\(profileViewModel.profile.bankAccount?.paystack.psrecieptCode ?? "")", amount: amount * 100, reference: paystackReferenceId)
                                        
                                        if initiateStatus {
                                            
                                            haveInitiateTransfer.toggle()
                                            isProcessing = false
                                            
                                        }else{
                                            alertTitle = "Oops!"
                                            alertMessage = "Try again"
                                            showAlert.toggle()
                                            alertType = .info
                                            isProcessing = false
                                        }
                                    }
                                }
                                
                            } label: {
                                HStack(spacing:10){
                                    if isProcessing {
                                        ProgressView()
                                    }
                                    Text(isProcessing ? "Processing..." : "Next".uppercased())
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(isProcessing ? Color.gray : Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        if haveInitiateTransfer {
                            Button {
                                isProcessing = true
                                
                                Task{
                                    let verifyStatus = try await paystackRepository.verifyTransfer(reference: paystackReferenceId)
                                    
                                    if verifyStatus {
                                        alertTitle = "Success!"
                                        alertMessage = "Thank you for using Payfam"
                                        showAlert.toggle()
                                        alertType = .info
                                      
                                        presentationMode.wrappedValue.dismiss()
                                        
                                        isProcessing = false
                                        
                                    }else{
                                        alertTitle = "Oops!"
                                        alertMessage = "Try again"
                                        showAlert.toggle()
                                        alertType = .info
                                        
                                        isProcessing = false
                                    }
                                }
                                
                            } label: {
                                HStack(spacing:10){
                                    if isProcessing {
                                        ProgressView()
                                    }
                                    Text(isProcessing ? "Processing..." : "Verify".uppercased())
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(isProcessing ? Color.gray : Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                       
                    }
                 

                }
                
                if method == .mobileMobile{
                    TextField("GH₵ 0.00", value: $amount, formatter: cedisCurrencyFormatter)
                        .submitLabel(.done)
                        .keyboardType(.numberPad)
                        .padding()
                        .foregroundColor(.primary)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
            }
         
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert){
            switch alertType {
            case .info :
            return Alert(title: Text(alertTitle),message: Text(alertMessage))
            case .infoAndBack:
                return Alert(title: Text(alertTitle),message: Text(alertMessage))
            }
        }
        .navigationTitle(title)
        .onAppear(perform: {
            Task{
                isLoading = true
                await  profileViewModel.getProfile()
                isLoading = false
            }
        })
       
    }
    
    enum AlertType {
        case info
        case infoAndBack
     
    }
}

struct WithdrawFundsView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawFundsView(title: "Withdraw Funds",method: .bankTransfer)
    }
}
