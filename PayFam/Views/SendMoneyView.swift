//
//  SendMoneyView.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import SwiftUI
import iPhoneNumberField
import FirebaseFirestore

struct SendMoneyView: View {
    //    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var profileViewModel : ProfileViewModel
    
    @StateObject
    var web3InteractionViewModel : Web3InteractionViewModel = Web3InteractionViewModel()
    
   
   
    @StateObject var mobileMoneyViewModel : MobileMoneyViewModel = MobileMoneyViewModel()
    @StateObject var transactionsViewModel : TransactionsViewModel = TransactionsViewModel()
    @StateObject  var paystackRepository : PaystackRepository =  PaystackRepository()
    
    let momoProviderList : [String] = [
        "MTN",
        "Airtel",
        "Vodafone"
    ]
    
    @State private var selectedMoMoProvider : String = "MTN"
    
    @State   var paymentMethod : TransactionPaymethod = .none
    @State   var activeStep : Int  = 0
    @State   var paymentMethodTitle : String = ""
    @State   var recieverPhonenumber:   String = ""
    @State   var momoPayerPhonenumber:   String = "233"
    @State   var recieverName:   String = ""
    @State var selectedRecipient : RecipientModel? = nil
    
    @FocusState private var recieverNameInFocus : Bool
   
    @FocusState private var recieverPhonenumberInFocus : Bool
  
    @FocusState private var momoPayerPhonenumberInFocus : Bool
    @State private  var currency:   String = ""
    @State private  var amount:  Int =  0
    @FocusState private var amountInFocus : Bool
    @State private  var redemptionCode: String = ""
    @State private  var isRedeemed: Bool  = false
    @State private  var senderID:   String  = ""
    @State private  var senderName:   String = ""
    @State private  var senderPhonenumber:   String = ""
    
    @State private  var useBalance : Bool = false
    
    
    @State private  var showAlert : Bool = false
    @State private  var alertTitle : String = ""
    @State private  var alertMessage : String = ""
    @State private  var alertType : AlertType = .info
    

    @State private var processing : Bool = false
    @State private var processingRequesttoPayTransactionStatus : Bool = false
    
    @State private var loadingRecipients : Bool  = false
    
    @State private var showWalletList : Bool = false
    @State private var showRecieptientList : Bool = false
    @State private var showAddRecipient : Bool = false
    
    @State private var paystackReferenceId  : String = ""
    @State private var haveOpenedPayStackWebview : Bool = false
    @State private var isProcessing : Bool = false
    
    @State private var showCheckOutWebView : Bool = false
    
    @State private var requestToPayResponseReferenceId : String = ""
    

    
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
    
    let usdtCurrencyFormatter: NumberFormatter  = {
        let    usdtCurrencyFormatter =  NumberFormatter()
        usdtCurrencyFormatter.numberStyle = .currency
        usdtCurrencyFormatter.currencySymbol = "₮"
        usdtCurrencyFormatter.currencyCode = "US"
        usdtCurrencyFormatter.maximumFractionDigits = 2
        usdtCurrencyFormatter.currencyGroupingSeparator = ","
        return usdtCurrencyFormatter
    }()

    init(paymentMethod : TransactionPaymethod,activeStep : Int,paymentMethodTitle : String,momoPayerPhonenumber : String? = "233" ,selectedRecipient : RecipientModel? = nil) {
        
        _paymentMethod = State(wrappedValue: paymentMethod)
        _activeStep = State(wrappedValue: activeStep)
        _paymentMethodTitle = State(wrappedValue: paymentMethodTitle)
        _momoPayerPhonenumber = State(wrappedValue: momoPayerPhonenumber ?? "233")
        _selectedRecipient =  State(wrappedValue: selectedRecipient ?? nil)
        
        
    }
    
    
    var body: some View {
        if #available(iOS 16.0, *) {
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
                                momoPayerPhonenumber = profileViewModel.profile.momoPhoneNumber ?? ""
                                recieverPhonenumber = "233"
                                
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
                                recieverPhonenumber = "1"
                                
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
                                recieverPhonenumber = "234"
                                paystackReferenceId = paystackRepository.generateReferenceId()
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
                        
                        
                        HStack{
                            
                            
                            HStack{
                                Text("Add new recipient")
                                    .font(.callout)
                                    .foregroundColor(.primary.opacity(0.5))
                                    .fontWeight(.semibold)
                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(showAddRecipient ? Color.primaryBrandColor.opacity(0.3) : Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                withAnimation{
                                    showAddRecipient.toggle()
                                    showRecieptientList = false
                                }
                                selectedRecipient = nil
                            }
                            
                            Spacer()
                            
                            HStack{
                                Text("Payfam again")
                                    .font(.callout)
                                    .foregroundColor(.primary.opacity(0.5))
                                    .fontWeight(.semibold)
                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(showRecieptientList ? Color.primaryBrandColor.opacity(0.3) : Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                showRecieptientList.toggle()
                                showAddRecipient = false
                            }
                        }
                        
                        if selectedRecipient != nil {
                            VStack(alignment:.leading){
                                Text("Receiver’s name")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary.opacity(0.5))
                                Text("\(selectedRecipient?.recieverName ?? "")")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .frame(maxWidth: .infinity,alignment:.leading)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text("Receiver’s mobile number")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary.opacity(0.5))
                                Text("\(selectedRecipient?.recieverPhonenumber ?? "")")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .frame(maxWidth: .infinity,alignment:.leading)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        if showAddRecipient {
                            VStack(alignment:.leading){
                                Text("Receiver’s name")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary.opacity(0.5))
                                TextField("...", text: $recieverName)
                                    .focused($recieverNameInFocus)
                                    .submitLabel(.next)
                                    .padding()
                                    .foregroundColor(.primary)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            VStack(alignment:.leading){
                                Text("Receiver’s mobile number")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary.opacity(0.5))
                                iPhoneNumberField(nil, text: $recieverPhonenumber)
                                
                                    .flagHidden(false)
                                    .flagSelectable(false)
                                    .defaultRegion(paymentMethod == .mobileMobile ? "GH" : paymentMethod == .bankTransfer ? "NG" : "US")
                                    .maximumDigits(15)
                                    .prefixHidden(false)
                                    .padding()
                                    .foregroundColor(.primary)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .focused($recieverPhonenumberInFocus)
                            }
                            
                            
                        }
                        
                        if paymentMethod == .mobileMobile {
                            VStack(alignment:.leading){
                                Text("Payer’s mobile number ")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary.opacity(0.5))
                                Text("(The MoMo number that will be debited)")
                                    .font(.caption)
                                    .fontWeight(.thin)
                                    .foregroundColor(.primary)
                                iPhoneNumberField(nil,text: $momoPayerPhonenumber )
                                
                                    .flagHidden(false)
                                    .flagSelectable(false)
                                    .defaultRegion("GH")
                                    .formatted(true)
                                    .prefixHidden(false)
                                    .maximumDigits(12)
                                    .padding()
                                    .foregroundColor(.primary)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .focused($momoPayerPhonenumberInFocus)
                                
                                Text("Select MoMo provider")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary.opacity(0.5))
                                
                                Picker(
                                    selection: $selectedMoMoProvider ,
                                    label:Text("picker")){
                                        ForEach(0..<momoProviderList.count, id: \.self){ index in
                                        Text(momoProviderList[index])
                                            .tag(momoProviderList[index])
                                        
                                    }
                                }
                                .pickerStyle(.segmented)
                                
                                if selectedMoMoProvider != "MTN" {
                                    Text("We support only MTN Mobile money!")
                                        .font(.caption)
                                        .foregroundColor(Color.red)
                                        .padding()
                                }
                            }
                        }
                        
                        
                        
                        
                        VStack(alignment:.leading){
                            Text("Enter amount")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary.opacity(0.5))
                            
                            if paymentMethod == .bankTransfer {
                                TextField("₦ 0.00", value: $amount, formatter: nairaCurrencyFormatter)
                                    .focused($amountInFocus)
                                    .submitLabel(.done)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .foregroundColor(.primary)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            if paymentMethod == .mobileMobile {
                                TextField("GH₵ 0.00", value: $amount, formatter: cedisCurrencyFormatter)
                                    .focused($amountInFocus)
                                    .submitLabel(.done)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .foregroundColor(.primary)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            if paymentMethod == .cryptocurrency {
                                TextField("₮ 0.00", value: $amount, formatter: usdtCurrencyFormatter)
                                    .focused($amountInFocus)
                                    .submitLabel(.done)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .foregroundColor(.primary)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Toggle("Use balance", isOn: $useBalance)
                                .padding()
                          
                            if useBalance == true {
                                if paymentMethod == .mobileMobile {
                                    if profileViewModel.profile.ghsBalance ?? 0 < Double(amount){
                                        Text("You do not enough money in balance to complete this transaction!")
                                            .font(.caption)
                                            .foregroundColor(Color.red)
                                            .padding()
                                    }
                                }
                                
                                if paymentMethod == .bankTransfer {
                                    if profileViewModel.profile.ngnBalance ?? 0 < Double(amount){
                                        Text("You do not enough money in balance to complete this transaction!")
                                            .font(.caption)
                                            .foregroundColor(Color.red)
                                            .padding()
                                    }
                                }
                                
                                if paymentMethod == .cryptocurrency {
                                    if profileViewModel.profile.ngnBalance ?? 0 < Double(amount){
                                        Text("You do not enough money in balance to complete this transaction!")
                                            .font(.caption)
                                            .foregroundColor(Color.red)
                                            .padding()
                                    }
                                }
                            }
                            
                            
                            if paymentMethod == .mobileMobile && requestToPayResponseReferenceId.isEmpty != false {
                                Button {
                                    
                                    
                                    if selectedRecipient == nil && showAddRecipient == false{
                                        alertTitle = "Required!"
                                        alertMessage = "Add or Select a reciever"
                                        showAlert.toggle()
                                        alertType = .info
                                        
                                    }else  if recieverName.isEmpty && showAddRecipient {
                                        
                                        alertTitle = "Required!"
                                        alertMessage = "Enter the reciever's name"
                                        showAlert.toggle()
                                        alertType = .info
                                        recieverNameInFocus.toggle()
                                        
                                    }else if recieverPhonenumber.count > 5 && showAddRecipient {
                                        
                                        alertTitle = "Required!"
                                        alertMessage = "Enter the reciever's mobile number"
                                        showAlert.toggle()
                                        alertType = .info
                                        recieverPhonenumberInFocus.toggle()
                                        
                                    }else if momoPayerPhonenumber.isEmpty {
                                        
                                        alertTitle = "Required!"
                                        alertMessage = "Enter the payer's mobile number"
                                        showAlert.toggle()
                                        alertType = .info
                                        momoPayerPhonenumberInFocus.toggle()
                                        
                                    }else if  amount < 2 {
                                        
                                        alertTitle = "Required!"
                                        alertMessage = "Minimum amount is 2"
                                        showAlert.toggle()
                                        alertType = .info
                                        amountInFocus.toggle()
                                    }else if selectedMoMoProvider != "MTN" {
                                        
                                        alertTitle = "Ooops!"
                                        alertMessage = "We support only MTN Mobile money!"
                                        showAlert.toggle()
                                        alertType = .info
                                        
                                    }else if useBalance == true && profileViewModel.profile.ghsBalance ?? 0 < Double(amount){
                                        alertTitle = "Ooops!"
                                        alertMessage = "You do not enough money in balance to complete this transaction!"
                                        showAlert.toggle()
                                        alertType = .info
                                    } else{
                                        
                                        
                                        if useBalance == true {
                                            processing = true
                                            
                                            Task{
                                                
                                                await profileViewModel.updateGHSBalance(uid: profileViewModel.profile.uid, amount: Double(-amount))
                                                
                                                let _id =  UUID().uuidString.lowercased()
                                                let _redeemCode = transactionsViewModel.generateRedeemCode()
                                                
                                                let _recieverName = showAddRecipient ?recieverName : "\(selectedRecipient?.recieverName ?? "")"
                                                let _recieverPhonenumber = showAddRecipient ?recieverPhonenumber : "\(selectedRecipient?.recieverPhonenumber ?? "")"
                                                
                                                let _transaction = TransactionModel(id:_id, uid: _id, recieverName: _recieverName, recieverPhonenumber: _recieverPhonenumber, currency: "GHS", redeemedcurrency: "", amount: amount, redemptionCode: _redeemCode, isRedeemed: false, paymentMethod: "mobileMobile", senderID: profileViewModel.profile.uid, senderName: "\( profileViewModel.profile.firstName) \( profileViewModel.profile.lastName)", senderPhonenumber:  profileViewModel.profile.phoneNumber.removeSpecialCharsFromString(), momoReferenceId: requestToPayResponseReferenceId, addedOn: nil)
                                                
                                                await transactionsViewModel.addTransaction(transaction: _transaction)
                                                
                                                alertTitle = "Money sent!"
                                                alertMessage = "Money have been sent"
                                                showAlert.toggle()
                                                alertType = .info
                                                
                                                processing = false
                                                
                                                resetAll()
                                            }
                                            
                                        }else{
                                            Task{
                                                processing = true
                                                
                                                if showAddRecipient{
                                                    let _id  = "\(UUID().uuidString)".lowercased()
                                                    let _newRecipient = RecipientModel(id:_id, uid: _id, userId: profileViewModel.profile.uid, recieverName: recieverName, recieverPhonenumber: recieverPhonenumber, addedOn: nil)
                                                    
                                                    await transactionsViewModel.addRecipient(recipient: _newRecipient)
                                                }
                                                
                                                let accesstokenResponse = try? await  mobileMoneyViewModel.generateAccessToken()
                                                
                                                if accesstokenResponse?.accessToken != nil {
                                                    
                                                    let _requestPayModel = RequestPayModel(amount: "\(amount)", currency: "EUR", externalID: "097411065", payer: RequestPayPayerModel(partyIDType: "MSISDN", partyID: momoPayerPhonenumber), payerMessage: "Sure thing!", payeeNote: "Payback my money bro!")
                                                    
                                                    let requestToPayResponse = try? await mobileMoneyViewModel.requestPay(bearerToken: "\(accesstokenResponse?.accessToken ?? " ")", values: _requestPayModel)
                                                    
                                                    if requestToPayResponse?.isEmpty != true {
                                                        
                                                        requestToPayResponseReferenceId = "\(requestToPayResponse ?? "")"
                                                        processing = false
                                                        
                                                        NotificationManager.instance.notify(title: "Pending Transaction!⌛️", subTitle: "Sending funds is pending", body: "Waiting for your confirmation on MoMo")
                                                        
                                                        
                                                    }
                                                    
                                                }
                                            }
                                        }
                                      
                                        
                                        
                                    }
                                    
                                    
                                    
                                } label: {
                                    Text(processing ? "Processing..." : "Send funds".uppercased())
                                        .font(.title2)
                                        .foregroundColor(Color.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(processing ? Color.gray.opacity(0.4) : Color.primaryBrandColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                    
                                }
                                .disabled(paymentMethod == .mobileMobile && requestToPayResponseReferenceId.isEmpty != true ? true : false)
                                .padding(.top,50)
                                
                                
                            }
                            if paymentMethod == .mobileMobile && requestToPayResponseReferenceId.isEmpty != true {
                                HStack{
                                    Spacer()
                                    VStack(alignment:.center){
                                        Text("Waiting for your confirmation on MoMo")
                                        Button {
                                            Task{
                                                processingRequesttoPayTransactionStatus = true
                                                let accesstokenResponse = try? await  mobileMoneyViewModel.generateAccessToken()
                                                
                                                if accesstokenResponse?.accessToken != nil {
                                                    
                                                    
                                                    
                                                    let _requesttoPayTransactionStatus = try? await mobileMoneyViewModel.requesttoPayTransactionStatus(bearerToken: "\(accesstokenResponse?.accessToken ?? " ")", referenceId: requestToPayResponseReferenceId)
                                                    
                                                    if _requesttoPayTransactionStatus == true {
                                                        
                                                        let _id =  UUID().uuidString.lowercased()
                                                        let _redeemCode = transactionsViewModel.generateRedeemCode()
                                                        
                                                        let _recieverName = showAddRecipient ?recieverName : "\(selectedRecipient?.recieverName ?? "")"
                                                        let _recieverPhonenumber = showAddRecipient ?recieverPhonenumber : "\(selectedRecipient?.recieverPhonenumber ?? "")"
                                                        
                                                        let _transaction = TransactionModel(id:_id, uid: _id, recieverName: _recieverName, recieverPhonenumber: _recieverPhonenumber, currency: "GHS", redeemedcurrency: "", amount: amount, redemptionCode: _redeemCode, isRedeemed: false, paymentMethod: "mobileMobile", senderID: profileViewModel.profile.uid, senderName: "\( profileViewModel.profile.firstName) \( profileViewModel.profile.lastName)", senderPhonenumber:  profileViewModel.profile.phoneNumber.removeSpecialCharsFromString(), momoReferenceId: requestToPayResponseReferenceId, addedOn: nil)
                                                        
                                                        await transactionsViewModel.addTransaction(transaction: _transaction)
                                                        
                                                        alertTitle = "Money sent!"
                                                        alertMessage = "Money have been sent"
                                                        showAlert.toggle()
                                                        alertType = .info
                                                        
                                                        processingRequesttoPayTransactionStatus = false
                                                        
                                                        resetAll()
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    if _requesttoPayTransactionStatus == false{
                                                        alertTitle = "Momo not confirmed!"
                                                        alertMessage = "You need to confirm the momo request to pay"
                                                        showAlert.toggle()
                                                        alertType = .info
                                                        
                                                        processingRequesttoPayTransactionStatus = false
                                                        
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            
                                            
                                        } label: {
                                            Text( processingRequesttoPayTransactionStatus ? "Verifying payment status..":"Confirm transaction".uppercased())
                                                .font(.callout)
                                                .foregroundColor(Color.white)
                                                .padding()
                                                .background(processingRequesttoPayTransactionStatus ?Color.gray.opacity(0.4) :Color.primaryBrandColor)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        }
                                        
                                    }
                                    .padding()
                                    .background(Color.secondaryBrandColor.opacity(0.4))
                                    Spacer()
                                }
                            }
                            
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
                                                showAlert.toggle()
                                                alertType = .disconnect
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
                            
                            if paymentMethod == .bankTransfer {
                                if !haveOpenedPayStackWebview {
                                    Button {
                                    
                                        
                                        if selectedRecipient == nil && showAddRecipient == false{
                                            alertTitle = "Required!"
                                            alertMessage = "Add or Select a reciever"
                                            showAlert.toggle()
                                            alertType = .info
                                            
                                        }else  if recieverName.isEmpty && showAddRecipient {
                                            
                                            alertTitle = "Required!"
                                            alertMessage = "Enter the reciever's name"
                                            showAlert.toggle()
                                            alertType = .info
                                            recieverNameInFocus.toggle()
                                            
                                        }else if recieverPhonenumber.count > 5 && showAddRecipient {
                                            
                                            alertTitle = "Required!"
                                            alertMessage = "Enter the reciever's mobile number"
                                            showAlert.toggle()
                                            alertType = .info
                                            recieverPhonenumberInFocus.toggle()
                                            
                                        }else if amount < 100 {
                                            alertTitle = "Required!"
                                            alertMessage = "Enter amount. Minimum of 100"
                                            showAlert.toggle()
                                            alertType = .info
                                        }else if useBalance == true && profileViewModel.profile.ngnBalance ?? 0 < Double(amount){
                                            alertTitle = "Ooops!"
                                            alertMessage = "You do not enough money in balance to complete this transaction!"
                                            showAlert.toggle()
                                            alertType = .info
                                        }else {
                                            
                                            if useBalance == true {
                                                isProcessing = true
                                                
                                                Task{
                                                    
                                                    await profileViewModel.updateNGNBalance(uid: profileViewModel.profile.uid, amount: Double(-amount))
                                                    
                                                    
                                                    let _id =  UUID().uuidString.lowercased()
                                                    let _redeemCode = transactionsViewModel.generateRedeemCode()
                                                    
                                                    let _recieverName = showAddRecipient ?recieverName : "\(selectedRecipient?.recieverName ?? "")"
                                                    let _recieverPhonenumber = showAddRecipient ?recieverPhonenumber : "\(selectedRecipient?.recieverPhonenumber ?? "")"
                                                    
                                                    let _transaction = TransactionModel(id:_id, uid: _id, recieverName: _recieverName, recieverPhonenumber: _recieverPhonenumber, currency: "NGN", redeemedcurrency: "", amount: amount, redemptionCode: _redeemCode, isRedeemed: false, paymentMethod: "bankTransfer", senderID: profileViewModel.profile.uid, senderName: "\( profileViewModel.profile.firstName) \( profileViewModel.profile.lastName)", senderPhonenumber:  profileViewModel.profile.phoneNumber.removeSpecialCharsFromString(), momoReferenceId: requestToPayResponseReferenceId, addedOn: nil)
                                                    
                                                    await transactionsViewModel.addTransaction(transaction: _transaction)
                                                    
                                                    alertTitle = "Money sent!"
                                                    alertMessage = "Money have been sent"
                                                    showAlert.toggle()
                                                    alertType = .info
                                                    
                                                    isProcessing = false
                                                    
                                                    resetAll()
                                                }
                                                
                                            }else{
                                                isProcessing = true
                                                
                                                Task{
                                                    
                                                    if showAddRecipient{
                                                        let _id  = "\(UUID().uuidString)".lowercased()
                                                        let _newRecipient = RecipientModel(id:_id, uid: _id, userId: profileViewModel.profile.uid, recieverName: recieverName, recieverPhonenumber: recieverPhonenumber, addedOn: nil)
                                                        
                                                        await transactionsViewModel.addRecipient(recipient: _newRecipient)
                                                    }
                                                    
                                                    await paystackRepository.generateCheckoutUrl(email:"payfamcustomer@gmail.com",amount:"\(amount*100)", reference: paystackReferenceId)
                                                }
      
                                                isProcessing = false
                                                showCheckOutWebView.toggle()
                                            }
                                            
                                         
                                        }
                                        
                                    } label: {
                                        HStack(spacing:10){
                                            if isProcessing {
                                                ProgressView()
                                            }
                                            Text(isProcessing ? "Processing..." : "Send funds".uppercased())
                                                .font(.callout)
                                                .foregroundColor(.white)
                                                
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(isProcessing ? Color.gray : Color.accentColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                       
                                        
                                    }
                                    .padding(.top,20)
                                }
                                
                                if haveOpenedPayStackWebview {
                                    Button {
                                        isProcessing = true
                                        Task{
                                            let status = try await paystackRepository.verifyTransaction(reference: paystackReferenceId)
                                            
                                            if status {
                                                
                                                
                                                let _id =  UUID().uuidString.lowercased()
                                                let _redeemCode = transactionsViewModel.generateRedeemCode()
                                                
                                                let _recieverName = showAddRecipient ?recieverName : "\(selectedRecipient?.recieverName ?? "")"
                                                let _recieverPhonenumber = showAddRecipient ?recieverPhonenumber : "\(selectedRecipient?.recieverPhonenumber ?? "")"
                                                
                                                let _transaction = TransactionModel(id:_id, uid: _id, recieverName: _recieverName, recieverPhonenumber: _recieverPhonenumber, currency: "NGN", redeemedcurrency: "", amount: amount, redemptionCode: _redeemCode, isRedeemed: false, paymentMethod: "bankTransfer", senderID: profileViewModel.profile.uid, senderName: "\( profileViewModel.profile.firstName) \( profileViewModel.profile.lastName)", senderPhonenumber:  profileViewModel.profile.phoneNumber.removeSpecialCharsFromString(), momoReferenceId: requestToPayResponseReferenceId, addedOn: nil)
                                                
                                                await transactionsViewModel.addTransaction(transaction: _transaction)
                                                
                                                alertTitle = "Money sent!"
                                                alertMessage = "Money have been sent"
                                                showAlert.toggle()
                                                alertType = .info
                                                
                                                processingRequesttoPayTransactionStatus = false
                                                
                                                resetAll()
                                                
                                                
                                            }else{
                                                alertTitle = "Verification failed!"
                                                alertMessage = "Try again"
                                                showAlert.toggle()
                                                alertType = .info
                                            }
                                            isProcessing = false
                                        }
                                        
                                    } label: {
                                        Text(isProcessing ? "Processing..." : "Verify transaction".uppercased())
                                            .font(.callout)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.accentColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .padding(.top,20)
                                    
                                    Button {
                                        
                                        haveOpenedPayStackWebview = false
                                        isProcessing = false
                                        paystackReferenceId = paystackRepository.generateReferenceId()
                                        
                                        haveOpenedPayStackWebview = false
                                        
                                    } label: {
                                        Text( "Reset".uppercased())
                                            .font(.callout)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.orange)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .padding(.top,10)
                                    
                                }
                            }
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .transition(.slide)
                    
                    
                }
                
                
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                web3InteractionViewModel.initWalletConnect()
                
                
                
                
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
            .sheet(isPresented: $showRecieptientList){
                VStack{
                    HStack{
                        Button {
                            showRecieptientList.toggle()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                    if loadingRecipients {
                        Spacer()
                        HStack{
                            ProgressView()
                            Text("Fetching recipients...")
                        }
                    }
                    
                    if loadingRecipients == false {
                        if transactionsViewModel.recipientList.count > 0 {
                            List{
                                ForEach(transactionsViewModel.recipientList, id: \.uid){recipient in
                                    Button {
                                        
                                        selectedRecipient = RecipientModel(uid: recipient.uid, userId: recipient.userId, recieverName: recipient.recieverName, recieverPhonenumber: recipient.recieverPhonenumber)
                                        
                                        showRecieptientList.toggle()
                                        
                                    } label: {
                                        HStack{
                                            AsyncImage(url: URL(string: "https://avatars.dicebear.com/api/pixel-art/\(recipient.recieverName.removeSpecialCharsFromString()).png")) { resImage in
                                                resImage
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 40,height: 40)
                                                    .clipShape(Circle())
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            
                                            VStack{
                                                Text(recipient.recieverName)
                                                    .font(.callout)
                                                    .fontWeight(.semibold)
                                                
                                                Text(recipient.recieverPhonenumber)
                                                    .font(.caption)
                                                    .fontWeight(.thin)
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                }
                            }
                            .listStyle(.plain)
                        }
                        
                        if transactionsViewModel.recipientList.count == 0 {
                            Spacer()
                            Text("You have not added any recipient yet")
                                .font(.callout)
                                .foregroundColor(.primary)
                            Image("content-empty")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:100,height: 100)
                        }
                    }
                    Spacer()
                }
                .padding()
                .onAppear(perform:{
                    loadingRecipients = true
                    Task{
                        await transactionsViewModel.getRecipients(userId: profileViewModel.profile.uid)
                        loadingRecipients = false
                    }
                })
            }
            .sheet(isPresented: $showCheckOutWebView){
                VStack{
                    HStack{
                        Spacer()
                        Button {
                            showCheckOutWebView.toggle()
                            haveOpenedPayStackWebview = true
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                    if paystackRepository.resolvedCheckoutReponse?.status == true {
                        // webview
                        WebView(url: URL(string: "\(paystackRepository.resolvedCheckoutReponse?.data?.authorizationURL ?? "")"))
                    }
                    if paystackRepository.resolvedCheckoutReponse?.status == false {
                        Text("Try again!")
                    }
                    
                }
            }
            .alert(isPresented: $showAlert){
                
                
                switch alertType {
                case .info:
                    return  Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage)
                        
                    )
                case .connect:
                    return Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        primaryButton:.destructive(Text("Cancel")),
                        secondaryButton: .default(Text("Connect"),action: {
                            showWalletList.toggle()
                            
                        }))
                    
                case .disconnect:
                    
                    return Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        primaryButton:.destructive(Text("Cancel")),
                        secondaryButton: .default(Text("Disconnect"),action: {
                            Task{
                                await   web3InteractionViewModel.disconnect()
                            }
                            
                        }))
                    
                }
                
                
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    enum AlertType {
        case info
        case connect
        case disconnect
    }
    
    func resetAll(){
        self.paymentMethod = .none
        self.activeStep  = 0
        self.paymentMethodTitle  = ""
        self.recieverName = ""
        self.recieverPhonenumber = ""
        self.currency = ""
        self.amount =  0
        self.showAddRecipient = false
        self.requestToPayResponseReferenceId = ""
        
    }

    
}

struct SendMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        SendMoneyView(paymentMethod: .mobileMobile, activeStep: 1, paymentMethodTitle: "Mobile Money")
    }
}
