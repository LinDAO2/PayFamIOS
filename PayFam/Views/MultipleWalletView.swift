//
//  MultipleWalletView.swift
//  PayFam
//
//  Created by Mattosha on 03/12/2022.
//

import SwiftUI


enum AlertType {
    case info
    case removeMomo
    case removeBankAccount
    case infoAction
    case disconnectWallet
}

enum ActionType {
    case alert
    case navigation
}

enum SheetType {
    case addBankAccount
    
}

struct ActionBtn : Identifiable {
    let id : String = UUID().uuidString
    let title :String
    let type : ActionType
}

struct MultipleWalletView: View {
    
    @StateObject var profileViewModel : ProfileViewModel = ProfileViewModel()
    
    @StateObject var web3InteractionViewModel : Web3InteractionViewModel = Web3InteractionViewModel()
    
    @State private var showWalletList : Bool = false
    
    @State private var showAlert : Bool = false
    @State private var alertTitle : String = ""
    @State private var alertMessage : String = ""
    @State private  var alertType : AlertType = .info
    @State private var sheetType : SheetType = .addBankAccount
    
    @StateObject var mobileMoneyViewModel : MobileMoneyViewModel = MobileMoneyViewModel()
    
   
    
    
    private let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]

   


    
    var body: some View {
        ScrollView{
            //MARK: Naira
            VStack{
                HStack{
                    Image("naira")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 40,height: 40)
                    Spacer()
                    Text("Available Balance")
                        .font(.caption)
                    
                    if profileViewModel.isLoading {
                        ProgressView()
                    }else{
                        
                       Text(profileViewModel.profile.ngnBalance ?? 0, format : .currency(code: "NGN"))
                    }
                 
                    
                   
                }
                .padding()
                
                if profileViewModel.profile.bankAccount != nil {
                    VStack{
                        Text("Bank account details :")
                        Text("Bank name")
                        Text("\(profileViewModel.profile.bankAccount?.paystack.bankName ?? "")")
                        Text("Account name")
                        Text("\(profileViewModel.profile.bankAccount?.paystack.accountName ?? "")")
                        Text("Account number")
                        Text("\(profileViewModel.profile.bankAccount?.paystack.accountNumber ?? "")")
                    }
                }
               
                
                LazyVGrid(columns: columns,spacing: 15){
                    
                    if profileViewModel.profile.bankAccount == nil {
                        NavigationLink{
                            WalletStorageView(title:  "Add Bank Account", method: .bankTransfer)
                        }label: {
                            ActionButton(title: "Add Bank Account")
                        }
                    }else{
                        Button {
                            showAlert.toggle()
                            alertTitle = "Are you sure"
                            alertMessage = "You are about to remove your bank account"
                            alertType = .removeBankAccount
                            
                        } label: {
                            ActionButton(title: "Remove Bank Account")
                        }
                    }
                   
                 
                    NavigationLink{
                        DepositFundsView(title:  "Deposit money" , method: .bankTransfer)
                    }label: {
                        ActionButton(title: "Deposit")
                    }
                    
                    NavigationLink{
                        SendMoneyView(paymentMethod: .bankTransfer, activeStep: 1, paymentMethodTitle: "Bank Transfer")
                    }label: {
                        ActionButton(title: "Send Funds")
                    }
                    NavigationLink{
                        WithdrawFundsView(title: "Withdraw Funds",method: .bankTransfer)
                    }label: {
                        ActionButton(title: "Withdraw")
                    }
                   
                    

                }
            }
            .padding()
            //MARK: Cedis
            VStack{
                HStack{
                    Image("cedis")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 40,height: 40)
                    Spacer()
                    Text("Available Balance")
                        .font(.caption)
                    
                    if profileViewModel.isLoading {
                        ProgressView()
                    }else{
                    
                    Text(profileViewModel.profile.ghsBalance ?? 0, format : .currency(code: "GHS"))
                    
                }
                   
                }
                .padding()
                
                HStack{
                    Text("MoMo :")
                    Text("\(profileViewModel.profile.momoPhoneNumber ?? "")")
                }
                
                LazyVGrid(columns: columns,spacing: 15){
                    
                    if "\(profileViewModel.profile.momoPhoneNumber ?? "")".isEmpty == true {
                        NavigationLink{
                            WalletStorageView(title:  "Add Mobile Number",method : .mobileMobile)
                        }label: {
                            ActionButton(title: "Add Mobile Number")
                        }
                    }else{
                        Button {
                            showAlert.toggle()
                            alertTitle = "Are you sure"
                            alertMessage = "You are about to remove your mobile number"
                            alertType = .removeMomo
                            
                        } label: {
                            ActionButton(title: "Remove Mobile Number")
                        }
                    }
                    
                   
                    
                    
                       NavigationLink{
                           DepositFundsView(title:  "Deposit money" , method: .mobileMobile)
                       }label: {
                           ActionButton(title: "Deposit")
                       }
                       
                       NavigationLink{
                           SendMoneyView(paymentMethod: .mobileMobile,
                                         activeStep: 1,paymentMethodTitle: "Mobile Number", momoPayerPhonenumber: "\(profileViewModel.profile.momoPhoneNumber ?? "")")
                       }label: {
                           ActionButton(title: "Send Funds")
                       }
                
                    
                    NavigationLink{
                        WithdrawFundsView(title: "Withdraw Funds",method: .mobileMobile)
                    }label: {
                        ActionButton(title: "Withdraw")
                    }

                   
                   
                    
                }
            }
            .padding()
            
            //MARK: Tether
            VStack{
                HStack{
                    Image("tether")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 40,height: 40)
                    Spacer()
                    Text("Available Balance")
                        .font(.caption)
                   
                    if profileViewModel.isLoading {
                        ProgressView()
                    }else{
                        Text(profileViewModel.profile.usdtBalance ?? 0, format : .currency(code: "USD"))
                        
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
                        
                        if  web3InteractionViewModel.isConnecting && !web3InteractionViewModel.isReconnecting {
                            HStack{
                                Spacer()
                                ProgressView()
                                Text("Connecting...")
                                Spacer()
                            }
                        }
                        
                        if  web3InteractionViewModel.isReconnecting && !web3InteractionViewModel.isConnecting {
                            HStack{
                                Spacer()
                                ProgressView()
                                Text("Reconnecting...")
                                Spacer()
                            }
                        }
                        if web3InteractionViewModel.isWrongChain {
                            Text("Connected to wrong chain. Please connect to Polygon")
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                                    .padding(.top, 10)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    
            
                    
                }
                else {
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.caption)
                            .foregroundColor(Color.red)
                        Text("Not connected to any wallet")
                            .font(.caption)
                       
                    } .padding()
                }
                
                LazyVGrid(columns: columns,spacing: 15){
                    
                    if web3InteractionViewModel.session != nil {
                        
                        Button {
                            showAlert.toggle()
                            alertTitle = "Are you sure"
                            alertMessage = "You are about to disconnect"
                            alertType = .disconnectWallet
                        } label: {
                            ActionButton(title: "Disconnect  wallet")
                        }
                        
                    }else{
                        Button {
                            showWalletList.toggle()
                        }label: {
                            ActionButton(title: "Connect  wallet")
                        }
                    }
                    
                    
                    NavigationLink{
                        DepositFundsView(title:  "Deposit stable coin" , method : .cryptocurrency)
                    }label: {
                        ActionButton(title: "Deposit")
                    }
                    
                    NavigationLink{
                        SendMoneyView(paymentMethod: .cryptocurrency, activeStep: 1, paymentMethodTitle: "Cryptocurrency")
                    }label: {
                        ActionButton(title: "Send Funds")
                    }
                    
                    NavigationLink{
                        WithdrawFundsView(title: "Withdraw Funds",method: .cryptocurrency)
                    }label: {
                        ActionButton(title: "Withdraw")
                    }
                    
                }
            }
            .padding()
        }
        
        .navigationBarTitle(Text("My Wallets"))
        .navigationBarTitleDisplayMode(.large)
        
        .background(Color(uiColor:  .systemBackground))
        .onAppear {
            web3InteractionViewModel.initWalletConnect()
            
            Task{
                await profileViewModel.getProfile()
            }
           
        }
        .alert(isPresented: $showAlert){
            switch alertType {
            case .removeMomo :
                return Alert(title: Text(alertTitle), message: Text(alertMessage), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Remove")){
                    Task.init{
                        await mobileMoneyViewModel.removeMoMoPhonenumber(profileId:profileViewModel.profile.uid)
                        await  profileViewModel.getProfile()
                    }
                })
            case .info:
                return Alert(title: Text(alertTitle), message: Text(alertMessage), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Remove")))
            case .removeBankAccount:
                return Alert(title: Text(alertTitle), message: Text(alertMessage), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Remove")){
                    Task.init{
                        await profileViewModel.removeBankAccount(uid:profileViewModel.profile.uid)
                        await  profileViewModel.getProfile()
                    }
                })
            case .disconnectWallet:
                return Alert(title: Text(alertTitle), message: Text(alertMessage), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Disconnect")){
                    Task.init{
                        await web3InteractionViewModel.disconnect()
                       
                    }
                })
            case .infoAction:
                return Alert(title: Text(alertTitle), message: Text(alertMessage), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Remove")))
            }
           
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
                      web3InteractionViewModel.connect(wallet: Wallets.Metamask)
                      showWalletList.toggle()

                  },
                  iconImage: Image("MetaMaskIcon")
                )
                .frame(width: 250)
                .padding(.leading)
                .padding(.trailing)
                
                
                WalletButtonView(
                  title: "TrustWallet",
                  action: {
                      web3InteractionViewModel.connect(wallet: Wallets.TrustWallet)
                      showWalletList.toggle()

                  },
                  iconImage: Image(systemName: "shield")
                )
                .frame(width: 250)
                .padding(.top,20)
                .padding(.leading)
                .padding(.trailing)


           
                
                Spacer()

               
            }
            .padding()
        }
        
    }
    
    @ViewBuilder
    func ActionButton (title : String, disable : Bool = false )->some View{
        VStack{
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 100,height:70)
        .background( disable ? Color.gray.brightness(1.1) as! Color :Color(uiColor: .tintColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

struct MultipleWalletView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleWalletView()
    }
}
