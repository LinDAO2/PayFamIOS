//
//  WalletStorageView.swift
//  PayFam
//
//  Created by Mattosha on 03/12/2022.
//

import SwiftUI
import iPhoneNumberField


struct SelectBank : Codable {
   let active: Bool
   let  code: String
   let id: Int
   let name: String
}





struct WalletStorageView: View {
    let title : String
    let method : TransactionPaymethod
    
    @State private var momoPhonenumber : String = "233"
    
    @StateObject var mobileMoneyViewModel : MobileMoneyViewModel = MobileMoneyViewModel()
    
    @EnvironmentObject private var profileViewModel : ProfileViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private  var showAlert : Bool = false
    @State private  var alertTitle : String = ""
    @State private  var alertMessage : String = ""
    @State private var alertType : AlertType = .info
    @State private var bank : Any = ""
    
    @StateObject  var paystackRepository : PaystackRepository =  PaystackRepository()

    @State private var showBankList : Bool = false
    
    @State private var selectBank : SelectBank?
    @State private var accountNumber : String = ""
    
    @State private var isProcessing : Bool = false
    @State private var isProcessingVerifyBankAccount : Bool = false
    @State private var isProcessingAddingBankAccount : Bool = false
    @State private var isLoadingBankList : Bool = false

    
    init(title : String, method: TransactionPaymethod){
        self.title = title
        self.method = method
    }
    
  
    var body: some View {
        VStack{
           
            
            if method == .bankTransfer {
                VStack(alignment:.leading){
                    Text("Select bank")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary.opacity(0.5))
                    Button {
                        showBankList.toggle()
                    } label: {
                        HStack{
                            Text("\(selectBank?.name ?? "Bank")")
                                .font(.callout)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.callout)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Text("Enter bank account")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary.opacity(0.5))
                    TextField("...", text: $accountNumber)
                        .submitLabel(.continue)
                        .keyboardType(.numberPad)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    if paystackRepository.resolvedBankAccountInfo?.status == nil {
                        HStack{
                            Spacer()
                            Button {
                                
                                if selectBank == nil {
                                    alertTitle = "Required!"
                                    alertMessage = "Select a bank"
                                    showAlert.toggle()
                                    alertType  = .info
                                }else if accountNumber.isEmpty {
                                    alertTitle = "Required!"
                                    alertMessage = "Enter bank account"
                                    showAlert.toggle()
                                    alertType  = .info
                                }else {
                                    isProcessingVerifyBankAccount = true
                                    Task.init{
                                       
                                        await paystackRepository.resolveBankAccountDetails(accountNumber: accountNumber, bankCode: "\(selectBank?.code ?? "")")
      
                                    }
                                    isProcessingVerifyBankAccount = false
                                }
                                
                        
                                
                                
                            } label: {
                                HStack{
                                    if isProcessingVerifyBankAccount {
                                        ProgressView()
                                    }
                                    Text(isProcessingVerifyBankAccount ? "Verifying" :"Verify bank account".uppercased())
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(isProcessingVerifyBankAccount ? Color.gray.opacity(0.4) : Color.accentColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                               
                            }
                            .disabled(isProcessingVerifyBankAccount)
                            Spacer()
                        }
                        .padding(.top,20)
                    }else{
                        VStack{
                            if paystackRepository.resolvedBankAccountInfo != nil {
                                if paystackRepository.resolvedBankAccountInfo?.status == true {
                                    VStack(alignment:.center){
                                        Text("Account number")
                                            .font(.callout)
                                            .fontWeight(.bold)
                                        
                                        Text(accountNumber)
                                            .font(.title)
                                            .fontWeight(.thin)
                                        
                                        Text("Bank name")
                                            .font(.callout)
                                            .fontWeight(.bold)
                                        
                                        Text("\(selectBank?.name ?? "")")
                                            .font(.title)
                                            .fontWeight(.thin)
                                        
                                        Text("Account holder name")
                                            .font(.callout)
                                            .fontWeight(.bold)
                                        
                                        Text("\(paystackRepository.resolvedBankAccountInfo?.data?.accountName ?? "")")
                                            .font(.title)
                                            .fontWeight(.thin)
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                
                                if paystackRepository.resolvedBankAccountInfo?.status == false {
                                    VStack(alignment:.center){
                                       
                                        
                                        Text("Could not resolve account name. Check parameters or try again.")
                                            .font(.callout)
                                            .fontWeight(.thin)
                                            .padding()
                                        
                                       
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            HStack{
                               
                                Button {
                                    isProcessingAddingBankAccount = true
                                    Task{
                                        let psrecieptCode = try await paystackRepository.createTransferReceiptCode(accountName: "\(paystackRepository.resolvedBankAccountInfo?.data?.accountName ?? "")", accountNumber: accountNumber, bankCode: "\(selectBank?.code ?? "")")
                                        
                                        if psrecieptCode != nil {
                                            let status = try await profileViewModel.updateBankAccount(uid: profileViewModel.profile.uid, bankAccount: ProfilePaystackBankAccount(paystack: ProfilePaystackBankAccountData(accountName: "\(paystackRepository.resolvedBankAccountInfo?.data?.accountName ?? "")", accountNumber: accountNumber, bankCode: "\(selectBank?.code ?? "")", bankName: "\(selectBank?.name ?? "")", psrecieptCode:"\( psrecieptCode ?? "")")))
                                            
                                            
                                            if status {
                                                alertTitle = "Successful!"
                                                alertMessage = "Bank account added!"
                                                showAlert.toggle()
                                                alertType  = .infoAndBack
                                                isProcessingAddingBankAccount = false
                                            }
                                            
                                            if !status {
                                                alertTitle = "Oops!"
                                                alertMessage = "Try again!"
                                                showAlert.toggle()
                                                alertType  = .info
                                                isProcessingAddingBankAccount = false
                                            }
                                        }
                                    }
                                    
                                } label: {
                                    HStack(spacing:10){
                                        if isProcessingAddingBankAccount {
                                            ProgressView()
                                        }
                                        Text(isProcessingAddingBankAccount ? "Adding..." : "Add bank account".uppercased())
                                            .font(.callout)
                                            .foregroundColor(.white)
                                            
                                    }
                                    .padding()
                                    .background(isProcessingAddingBankAccount ? Color.gray : Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                Spacer()
                                Button {
                                    paystackRepository.resolvedBankAccountInfo = nil
                                    paystackRepository.isProcessing = false
                                    selectBank = nil
                                    accountNumber = ""
                                    
                                } label: {
                                    Text("Reset".uppercased())
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.accentColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .disabled(isProcessingAddingBankAccount)
                            }
                        }
                    }
                    
         
                  
                   


                    
                   
                }
                .onAppear(perform: {
                    Task{
                        isLoadingBankList.toggle()
                        await  paystackRepository.getBanks()
                        isLoadingBankList.toggle()
                    }
                })
                .onDisappear(perform: {
                    paystackRepository.resolvedBankAccountInfo = nil
                    paystackRepository.isProcessing = false
                })
                
                
                
            }
            
            if method == .mobileMobile {
                VStack(alignment:.leading){
                    Text("Enter your momo wallet mobile number")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary.opacity(0.5))
                    iPhoneNumberField(text: $momoPhonenumber)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .defaultRegion("GH")
                        .clearButtonMode(.whileEditing)
                        .padding()
                        .foregroundColor(.white)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Button {
                        
                        if method == .mobileMobile {
                            if momoPhonenumber.isEmpty {
                                alertTitle = "Required!"
                                alertMessage = "Enter your momo wallet mobile number"
                                showAlert.toggle()
                                alertType  = .info
                            }else{
                                Task.init{
                                   
                                    await mobileMoneyViewModel.setMoMoPhonenumber(profileId:profileViewModel.profile.uid,momoPhonenumber:momoPhonenumber.removeSpecialCharsFromString())
                                    
                                    if mobileMoneyViewModel.isDone  {
                                        momoPhonenumber = ""
                                        alertTitle = "Successful!"
                                        alertMessage = "MoMo phone number added!"
                                        showAlert.toggle()
                                        alertType  = .infoAndBack
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    } label: {
                        HStack{
                          
                            
                            if mobileMoneyViewModel.isProcessing && !mobileMoneyViewModel.isDone {
                                ProgressView()
                            }
                            Text("Submit".uppercased())
                                .font(.title2)
                                .foregroundColor(Color.white)
                                
                        }.padding()
                            .frame(maxWidth: .infinity)
                            .background(mobileMoneyViewModel.isProcessing ? Color.gray.opacity(0.3) : Color.primaryBrandColor)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                    
                    .padding(.top)
                 

                }
               
                
                
            }
            
            if method == .cryptocurrency {
                
            }
            Spacer()
        }
        .navigationTitle(title)
        .padding()
        .padding(.top,50)
        .alert(isPresented: $showAlert){
            switch alertType {
            case .info:
             return   Alert(title: Text(alertTitle),message: Text(alertMessage))
                
            case .infoAndBack:
               return Alert(title: Text(alertTitle),message: Text(alertMessage),primaryButton: .default(Text("Ok")){
                    presentationMode.wrappedValue.dismiss()
                }, secondaryButton: .cancel())
            }
           
        }
        .sheet(isPresented: $showBankList){
            VStack{
                HStack{
                    Spacer()
                    Button {
                        showBankList.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()

                }
                .padding()
                
                if isLoadingBankList {
                    HStack{
                        Spacer()
                        ProgressView()
                        Text("Loading bank list...")
                        Spacer()
                    }
                }else{
                    List{
                        ForEach(paystackRepository.bankList, id : \.id){ bank in
                            Button {
                                let _selected = SelectBank(active: bank.active, code: bank.code, id: bank.id, name: bank.name)
                                
                                selectBank = _selected
                                showBankList.toggle()
                                
                            } label: {
                                Text(bank.name)
                                    .font(.callout)
                                    .foregroundColor(.primary)
                            }

                            
                        }
                    }
                    .listStyle(.plain)
                }
                
            }
        }
    }
    
    enum AlertType {
        case info
        case infoAndBack
     
    }

}

struct WalletStorageView_Previews: PreviewProvider {
    static var previews: some View {
        WalletStorageView(title: "Add Bank Account",method: .bankTransfer)
    }
}

