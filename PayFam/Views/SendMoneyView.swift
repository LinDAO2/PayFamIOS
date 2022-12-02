//
//  SendMoneyView.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import SwiftUI
import iPhoneNumberField


struct SendMoneyView: View {
    //    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var profileViewModel : ProfileViewModel
    
    @StateObject
    var web3InteractionViewModel : Web3InteractionViewModel = Web3InteractionViewModel()
    
    @State private  var paymentMethod : TransactionPaymethod = .mobileMobile
    @State private  var activeStep : Int = 1
    @State private  var paymentMethodTitle : String = "Mobile Money"
    @State private  var recieverName:   String = ""
    @State private  var recieverPhonenumber:   String = ""
    @State private  var currency:   String = ""
    @State private  var amount:  Int =  100
    @State private  var redemptionCode: String = ""
    @State private  var isRedeemed: Bool  = false
    @State private  var senderID:   String  = ""
    @State private  var senderName:   String = ""
    @State private  var senderPhonenumber:   String = ""
    @State private  var useBalance : Bool = false
    
    @State private  var showAlert : Bool = false
    @State private  var alertTitle : String = ""
    @State private  var alertMessage : String = ""
    
    @State private var showWalletList : Bool = false
    @State private var showWalletConnectAlert :Bool = false
    @State private var showWalletDisconnectAlert :Bool = false
    
    let nairaCurrencyFormatter: NumberFormatter
    let cedisCurrencyFormatter: NumberFormatter
    let usdtCurrencyFormatter: NumberFormatter
    
    init() {
        
        
        nairaCurrencyFormatter =  NumberFormatter()
        nairaCurrencyFormatter.numberStyle = .currency
        nairaCurrencyFormatter.currencySymbol = "₦"
        nairaCurrencyFormatter.currencyCode = "NGN"
        nairaCurrencyFormatter.maximumFractionDigits = 2
        
        cedisCurrencyFormatter =  NumberFormatter()
        cedisCurrencyFormatter.numberStyle = .currency
        cedisCurrencyFormatter.currencySymbol = "GH₵"
        cedisCurrencyFormatter.currencyCode = "GHS"
        cedisCurrencyFormatter.maximumFractionDigits = 2
        
        usdtCurrencyFormatter =  NumberFormatter()
        usdtCurrencyFormatter.numberStyle = .currency
        usdtCurrencyFormatter.currencySymbol = "₮"
        usdtCurrencyFormatter.currencyCode = "US"
        usdtCurrencyFormatter.maximumFractionDigits = 2
        
      
        
    }
    
    
    var body: some View {
        ScrollView{
            if activeStep == 0 {
                VStack(alignment:.leading){
                    
                    Text("TRANSFER TYPE")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("How do you want to transfer funds?")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary.opacity(0.5))
                    
                    VStack(spacing:20){
                        Button {
                            withAnimation(.easeInOut){
                                paymentMethod = .mobileMobile
                                activeStep = 1
                                paymentMethodTitle = "Mobile Money"
                            }
                            
                        } label: {
                            HStack(alignment: .center){
                                Text("Mobile Money")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName:"arrowtriangle.right.fill")
                                    .font(.title2)
                                    .foregroundColor( paymentMethod == .mobileMobile ?.primary : .primary.opacity(0.1))
                                
                            }
                            .padding(.all,20)
                            .background(
                                .gray.opacity( paymentMethod == .mobileMobile ?0.9:0.4)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        
                        Button {
                            withAnimation(.easeInOut){
                                paymentMethod = .cryptocurrency
                                activeStep = 1
                                paymentMethodTitle = "Cryptocurrency"
                            }
                            
                        } label: {
                            HStack(alignment: .center){
                                Text("Cryptocurrency")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName:"arrowtriangle.right.fill")
                                    .font(.title2)
                                    .foregroundColor( paymentMethod == .cryptocurrency ?.primary : .primary.opacity(0.1))
                                
                            }
                            .padding(.all,20)
                            .background(
                                .gray.opacity( paymentMethod == .cryptocurrency ?0.9:0.4)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        
                        Button {
                            withAnimation(.easeInOut){
                                paymentMethod = .bankTransfer
                                activeStep = 1
                                paymentMethodTitle = "Bank Transfer"
                            }
                        } label: {
                            HStack(alignment: .center){
                                Text("Bank Transfer")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName:"arrowtriangle.right.fill")
                                    .font(.title2)
                                    .foregroundColor( paymentMethod == .bankTransfer ?.primary : .primary.opacity(0.1))
                                
                            }
                            .padding(.all,20)
                            .background(
                                .gray.opacity( paymentMethod == .bankTransfer ?0.9:0.4)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        
                        
                    }
                    
                    
                    
                }
                .padding(.horizontal,8)
                .padding(.top,100)
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
            
            if activeStep == 1 {
                VStack(alignment:.leading){
                    HStack{
                        Button {
                            withAnimation(.easeInOut){
                                
                                activeStep = 0
                            }
                        } label: {
                            HStack{
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                Text(paymentMethodTitle)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                    }
                    
                    
                    Text("Enter your details to continue")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary.opacity(0.5))
                    Spacer(minLength: 50)
                    
                    VStack(alignment:.leading){
                        Text("Receiver’s name")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary.opacity(0.5))
                        TextField("...", text: $recieverName)
                            .padding()
                            .foregroundColor(.white)
                            .background(.primary.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    VStack(alignment:.leading){
                        Text("Receiver’s mobile number")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary.opacity(0.5))
                        iPhoneNumberField(text: $recieverPhonenumber)
                            .flagHidden(false)
                            .flagSelectable(true)
                            .defaultRegion(paymentMethod == .mobileMobile ? "GH" : paymentMethod == .bankTransfer ? "NG" : "US")
                            .padding()
                            .foregroundColor(.white)
                            .background(.primary.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    VStack(alignment:.leading){
                        Text("Enter amount")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary.opacity(0.5))
                        
                        if paymentMethod == .bankTransfer {
                            TextField("₦0.00", value: $amount, formatter: nairaCurrencyFormatter)
                                .keyboardType(.numberPad)
                                .submitLabel(.next)
                                .padding()
                                .foregroundColor(.white)
                                .background(.primary.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        if paymentMethod == .mobileMobile {
                            TextField("GH₵0.00", value: $amount, formatter: cedisCurrencyFormatter)
                                .keyboardType(.numberPad)
                                .submitLabel(.next)
                                .padding()
                                .foregroundColor(.white)
                                .background(.primary.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        if paymentMethod == .cryptocurrency {
                            TextField("₮0.00", value: $amount, formatter: usdtCurrencyFormatter)
                                .keyboardType(.numberPad)
                                .submitLabel(.next)
                                .padding()
                                .foregroundColor(.white)
                                .background(.primary.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Toggle("Use balance", isOn: $useBalance)
                            .padding()
                        Spacer()
                        

                        Button {
                           
//                            if web3InteractionViewModel.session == nil  {
//                                print("ok1")
//                                alertTitle = "Connect to Wallet"
//                                alertMessage = "You need to connect to your web3 wallet before you continue"
//                                showWalletConnectAlert.toggle()
//                            }else{
//                                print("ok")
//                                web3InteractionViewModel.getTokenName(to: "0x55c18d10ded7968Cd980AbfE0547B410DF284413")
//                            }
                            
                            
                            if recieverName.isEmpty {
                                alertTitle = "Required!"
                                alertMessage = "Enter the reciever's name"

                                showAlert.toggle()
                            }else if recieverPhonenumber.isEmpty {
                                alertTitle = "Required!"
                                alertMessage = "Enter the reciever's mobile number"

                                showAlert.toggle()
                            }else if paymentMethod == .bankTransfer && amount < 100 {
                                alertTitle = "Required!"
                                alertMessage = "Minimum amount is 100"

                                showAlert.toggle()
                            }else if paymentMethod == .mobileMobile && amount < 2 {
                                alertTitle = "Required!"
                                alertMessage = "Minimum amount is 2"

                                showAlert.toggle()
                            }else if paymentMethod == .cryptocurrency && amount < 2 {
                                alertTitle = "Required!"
                                alertMessage = "Minimum amount is 2"

                                showAlert.toggle()
                            }else{

                                if paymentMethod == .bankTransfer {

                                }

                                if paymentMethod == .cryptocurrency {

                                    if web3InteractionViewModel.session == nil  {
                                        alertTitle = "Connect to Wallet"
                                        alertMessage = "You need to connect to your web3 wallet before you continue"
                                        showWalletConnectAlert.toggle()
                                    }

                                }

                                if paymentMethod == .mobileMobile {

                                }


                            }

                            //                            print(profileViewModel.profile.firstName)
                            
                            //                            let transaction = TransactionModel(
                            //
                            ////                                 uid  = "",
                            //                                recieverName = recieverName,
                            //                                 recieverPhonenumber = recieverPhonenumber,
                            //                                 currency = currency,
                            ////                                 redeemedcurrency = "",
                            //                                 amount = amount,
                            //                                 redemptionCode = redemptionCode,
                            //                                 isRedeemed = isRedeemed,
                            //                                 paymentMethod  = paymentMethod,
                            //                                senderID = profileViewModel.profile.uid,
                            //                                senderName = "\(profileViewModel.profile.firstName) \(profileViewModel.profile.lastName)",
                            //                                senderPhonenumber = profileViewModel.profile.phoneNumber
                            //                            )
                            
                        } label: {
                            Text("Send funds".uppercased())
                                .font(.title2)
                                .foregroundColor(Color.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.primaryBrandColor)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.top,50)
                        
                    
                        
                        if paymentMethod == .cryptocurrency {
                            
                            if  web3InteractionViewModel.isConnecting {
                                HStack{
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            }
                            
                            if  web3InteractionViewModel.isReconnecting {
                                HStack{
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            }
                            
                            if web3InteractionViewModel.session != nil {
                                
                                
                                VStack(alignment:.center){
                                    Text("Connected to \(web3InteractionViewModel.walletName)")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .padding(.top, 5)
                                    
                                    Text("Address: \(web3InteractionViewModel.walletAccount ?? "")")
                                        .font(.callout)
                                        .fontWeight(.regular)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                        .padding(.top, 1)
                                        .padding(.horizontal, 20)
                                    
                                  
                                    if web3InteractionViewModel.isWrongChain {
                                        Text("Connected to wrong chain. Please connect to Polygon")
                                                .font(.system(size: 17))
                                                .fontWeight(.bold)
                                                .foregroundColor(.red)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, 30)
                                                .padding(.top, 10)
                                    }else{
                                       
                                        
                                        Button {
                                            alertTitle = "Disconnect \(web3InteractionViewModel.walletName) ?"
                                            alertMessage = "You will need to connect to a wallet to send crypto"
                                            showWalletDisconnectAlert.toggle()
                                        } label: {
                                            Text("Disconnect wallet")
                                                .font(.callout)
                                                .foregroundColor(.primary.opacity(0.5))
                                                .padding(.all,5)
                                                
                                                .background(Color.red.opacity(0.4))
                                                .cornerRadius(10)
                                                
                                        }
                                        .padding(.top,10)
                                        

                                    }
                                   
                                    
                                }
                                .frame(maxWidth: .infinity)
                                
                                
                        
                                
                            }
                        }
                        
                      
                       
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
                .transition(.slide)
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage)
                        
                    )
                }
                
            }
            
            
        }
        .onAppear {
            web3InteractionViewModel.initWalletConnect()
        }
        .alert(isPresented: $showWalletConnectAlert){
            Alert(
                title: Text(alertTitle),
                  message: Text(alertMessage),
                  primaryButton:.destructive(Text("Cancel")),
                  secondaryButton: .default(Text("Connect"),action: {
                      showWalletList.toggle()
                
            }))

           
        }
       
        .sheet(isPresented: $showWalletList){
            VStack{
                HStack{
                    Button {
                        showWalletList.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                }
                Spacer()
                WalletButtonView(
                  title: "MetaMask",
                  action: {
                      Task.init{
                          await  web3InteractionViewModel.connect(wallet: Wallets.Metamask)
                          showWalletList.toggle()
                      }

                  },
                  iconImage: Image("MetaMaskIcon")
                )
                .frame(width: 250)
                .padding(.leading)
                .padding(.trailing)

           
                
                Spacer()

               
            }
            .padding()
        }
        
        .alert(isPresented: $showWalletDisconnectAlert){
            Alert(
                title: Text(alertTitle),
                  message: Text(alertMessage),
                  primaryButton:.destructive(Text("Cancel")),
                  secondaryButton: .default(Text("Disconnect"),action: {
                      web3InteractionViewModel.disconnect()
                
            }))

           
        }
        
    }
}

struct SendMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        SendMoneyView()
    }
}
