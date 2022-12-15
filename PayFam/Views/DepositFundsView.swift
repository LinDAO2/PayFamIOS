//
//  DepositFundsView.swift
//  PayFam
//
//  Created by Mattosha on 03/12/2022.
//

import SwiftUI
import WebKit
import iPhoneNumberField


struct WebView: UIViewRepresentable {
    
    let url: URL?
    
    let callbackUrl = "CALLBACK_URL_GOES_HERE"
    let pstkUrl =  "AUTHORIZATION_URL_GOES_HERE"
    let ThreeDsUrl = "https://standard.paystack.co/close"
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs: WKWebpagePreferences = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
    
        
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        return WKWebView(frame: .zero, configuration: config)
    }
    
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURL = url else {
            return
        }
        let request = URLRequest(url: myURL)
        
        uiView.load(request)
    }
    
    
}


struct DepositFundsView: View {
    let title : String
    let method : TransactionPaymethod
    
    @State private var amount : Int  = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private  var showAlert : Bool = false
    @State private  var alertTitle : String = ""
    @State private  var alertMessage : String = ""
    @State private var alertType : AlertType = .info
    
    @State private var isProcessing : Bool = false
    
    @StateObject  var paystackRepository : PaystackRepository =  PaystackRepository()
    @StateObject var mobileMoneyViewModel : MobileMoneyViewModel = MobileMoneyViewModel()
    @StateObject var web3InteractionViewModel : Web3InteractionViewModel = Web3InteractionViewModel()
    
    
    @EnvironmentObject private var profileViewModel : ProfileViewModel
    
    @State private var showCheckOutWebView : Bool = false
    
    @State private var requestToPayResponseReferenceId : String = ""
    @State private var processing : Bool = false
    @State private var processingRequesttoPayTransactionStatus : Bool = false
    @State   var momoPayerPhonenumber:   String = "233"
    
    @State private var paystackReferenceId  : String = ""
    @State private var haveOpenedPayStackWebview : Bool = false
    
    let nairaCurrencyFormatter: NumberFormatter
    let cedisCurrencyFormatter: NumberFormatter
    
    init(title : String, method: TransactionPaymethod){
        self.title = title
        self.method = method
        
       
        
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
        
    }
    
  
    var body: some View {
        VStack{
            if method == .bankTransfer {
                VStack{
                    TextField("₦ 0.00", value: $amount, formatter: nairaCurrencyFormatter)
                        .submitLabel(.done)
                        .padding()
                        .foregroundColor(.primary)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    if !haveOpenedPayStackWebview {
                        Button {
                          
                            if amount < 100 {
                                alertTitle = "Required!"
                                alertMessage = "Enter amount. Minimum of 100"
                                showAlert.toggle()
                                alertType = .info
                            }else {
                                isProcessing = true
                                Task{
                                    await paystackRepository.generateCheckoutUrl(email:"payfamcustomer@gmail.com",amount:"\(amount*100)", reference: paystackReferenceId)
                                }
                                
                                print(paystackReferenceId)

                                isProcessing = false
                                showCheckOutWebView.toggle()
                            }
                            
                        } label: {
                            Text(isProcessing ? "Processing..." : "Continue".uppercased())
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
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
                                    
                                    await profileViewModel.updateNGNBalance(uid: profileViewModel.profile.uid, amount: Double(amount))
                                    
                                    alertTitle = "Success!"
                                    alertMessage = "Deposit confirmed!"
                                    showAlert.toggle()
                                    alertType = .info
                                    presentationMode.wrappedValue.dismiss()
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
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.top,20)
                        
                        Button {
                            
                            haveOpenedPayStackWebview = false
                            isProcessing = false
                            paystackReferenceId = ""
                            amount = 0
                            
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
                .padding(.top,40)
                .onAppear(perform: {
                    paystackReferenceId = paystackRepository.generateReferenceId()
                })
            }
            
            if method == .mobileMobile {
                TextField("GH₵ 0.00", value: $amount, formatter: cedisCurrencyFormatter)
                    .submitLabel(.done)
                    .keyboardType(.numberPad)
                    .padding()
                    .foregroundColor(.primary)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment:.leading){
                    Text("Payer’s mobile number")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary.opacity(0.5))
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
                       
                }
                
                if requestToPayResponseReferenceId.isEmpty != false {
                    Button {
                        
                         if  amount < 2 {
                            
                            alertTitle = "Required!"
                            alertMessage = "Minimum amount is 2"
                            showAlert.toggle()
                            alertType = .info
                            
                        }else if momoPayerPhonenumber.isEmpty {
                            
                            alertTitle = "Required!"
                            alertMessage = "Enter the payer's mobile number"
                            showAlert.toggle()
                            alertType = .info
                          
                            
                        } else{
                            
                            

                            Task{
                                processing = true
                                
                            
                                let accesstokenResponse = try? await  mobileMoneyViewModel.generateAccessToken()

                                if accesstokenResponse?.accessToken != nil {

                                    let _requestPayModel = RequestPayModel(amount: "\(amount)", currency: "EUR", externalID: "097411065", payer: RequestPayPayerModel(partyIDType: "MSISDN", partyID: momoPayerPhonenumber.removeSpecialCharsFromString()), payerMessage: "Sure thing!", payeeNote: "Payback my money bro!")

                                    let requestToPayResponse = try? await mobileMoneyViewModel.requestPay(bearerToken: "\(accesstokenResponse?.accessToken ?? " ")", values: _requestPayModel)

                                    if requestToPayResponse?.isEmpty != true {

                                        requestToPayResponseReferenceId = "\(requestToPayResponse ?? "")"
                                        processing = false

                                      

                                    }

                                }
                            }
                            

                        }

                  
                        
                    } label: {
                        Text(processing ? "Processing..." : "Submit".uppercased())
                            .font(.title2)
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(processing ? Color.gray.opacity(0.4) : Color.primaryBrandColor)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                    }
                    .disabled(requestToPayResponseReferenceId.isEmpty != true ? true : false)
                    .padding(.top,50)
                }
                
               if  requestToPayResponseReferenceId.isEmpty != true {
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
                                            
                                                
                                                alertTitle = "Money sent!"
                                                alertMessage = "Money have been sent"
                                                showAlert.toggle()
                                                alertType = .info
              
                                            await profileViewModel.updateGHSBalance(uid: profileViewModel.profile.uid, amount: Double(amount))
                                                processingRequesttoPayTransactionStatus = false

                                              
                                            presentationMode.wrappedValue.dismiss()
                                            
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
                
                
            }
            
            if method == .cryptocurrency {
                Button {
                  
                    
                        isProcessing = true
                        Task{
                            await web3InteractionViewModel.getTokenName(to:"0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747")
                            
                            isProcessing = false
                        }
                        
                        

                        
                      
                    
                    
                } label: {
                    Text(isProcessing ? "Processing..." : "Continue".uppercased())
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                .padding(.top,20)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(title)
        .alert(isPresented: $showAlert){
            switch alertType {
            case .info :
            return Alert(title: Text(alertTitle),message: Text(alertMessage))
            case .infoAndBack:
                return Alert(title: Text(alertTitle),message: Text(alertMessage))
            }
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
    }
    
    enum AlertType {
        case info
        case infoAndBack
     
    }
}

struct DepositFundsView_Previews: PreviewProvider {
    static var previews: some View {
        DepositFundsView(title: "Deposit Money",method: .bankTransfer)
    }
}
