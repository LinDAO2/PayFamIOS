//
//  RedeemFunds.swift
//  PayFam
//
//  Created by Mattosha on 07/12/2022.
//

import SwiftUI

struct RedeemFunds: View {
    
    let recieverPhonenumber : String
    let redemptionCode : String
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var transactionsViewModel : TransactionsViewModel = TransactionsViewModel()
    
    @State private var transaction : TransactionModel?
    @State private var isLoading : Bool = false
    private let currencyList : [CurrencyItem] = [
        CurrencyItem(title: "Naira", symbol: "NGN",image: "naira"),
        CurrencyItem(title: "Cedis", symbol: "GHS",image: "cedis"),
        CurrencyItem(title: "USDT", symbol: "USDT",image: "tether")
    ]
    
    private var columns : [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 3)
      }
    
    private let steps = ["Select currency","Redeem"]
    @State private var activeStep : Int = 0
    @State private var selectedCurrency : String = ""
    
    @EnvironmentObject private var profileViewModel : ProfileViewModel
    
    let nairaCurrencyFormatter: NumberFormatter
    let cedisCurrencyFormatter: NumberFormatter
    let usdtCurrencyFormatter: NumberFormatter
    
    @State private var showConfirmation : Bool = false
    @State private var alertType : String = ""
    
    
    init(recieverPhonenumber : String,redemptionCode:String ){
        self.recieverPhonenumber = recieverPhonenumber
        self.redemptionCode = redemptionCode
        
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
        VStack{
            if isLoading {
                HStack{
                    Spacer()
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.primary)
                    ProgressView()
                    Spacer()
                }
                .padding()
            }
            
            if transaction != nil {
//                HStack{
//                    Text(steps[activeStep])
//                        .font(.title2)
//                        .foregroundColor(.primary)
//                        .fontWeight(.semibold)
//                    Spacer()
//                    Text("\(activeStep + 1) / \(steps.count)")
//                }
//                .padding()
//                Text("\(transaction?.redemptionCode ?? "")")
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(currencyList, id : \.hashValue){ currency in
                        Button {
                            withAnimation{
                                selectedCurrency = currency.symbol
                            }
                        } label: {
                            VStack{
                                if  selectedCurrency == currency.symbol {
                                    Image(systemName: "checkmark.diamond.fill")
                                        .font(.title)
                                        .foregroundColor(.green)
                                }
                               
                                Image(currency.image)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width:100,height: 100)
                            }
                            
                            
                        }
                        .padding(.all,5)
                        

                    }
               }
                
                if selectedCurrency.isEmpty == false {
                    Text("Sent")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    if let _tAmount = transaction?.amount {
                        VStack{
                            if transaction?.currency == "NGN" {
                                Text(nairaCurrencyFormatter.string(from: _tAmount as NSNumber) ?? "0")
                            }
                            if transaction?.currency == "GHS" {
                                Text(cedisCurrencyFormatter.string(from: _tAmount as NSNumber) ?? "0")
                            }
                            if transaction?.currency == "USDT" {
                                Text(usdtCurrencyFormatter.string(from: _tAmount as NSNumber) ?? "0")
                            }
                        }
                        
                        VStack{
                            Text("You get")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.top,10)
                           
                            if  selectedCurrency == "NGN"  {
                                Text(cedisCurrencyFormatter.string(from: _tAmount * 40 as NSNumber) ?? "0")
                                Text(usdtCurrencyFormatter.string(from: _tAmount * 442 as NSNumber) ?? "0")
                            }
                            if  selectedCurrency == "GHS"{
                                Text(nairaCurrencyFormatter.string(from: _tAmount * 4 as NSNumber) ?? "0")
                                Text(usdtCurrencyFormatter.string(from: _tAmount * 250 as NSNumber) ?? "0")
                            }
                            if  selectedCurrency == "USDT" {
                                Text(nairaCurrencyFormatter.string(from: _tAmount * 442 as NSNumber) ?? "0")
                                Text(cedisCurrencyFormatter.string(from: _tAmount * 250 as NSNumber) ?? "0")
                            }
                        }
                    }
                    
                   
                    
                }
                
                
                if selectedCurrency.isEmpty == false {
                    Button {
                        showConfirmation.toggle()
                        alertType = "confirmation"
                    } label: {
                        Text("Confirm".uppercased())
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding(.top,15)
                }
               
             
            }
            Spacer()
        }
        .onAppear(perform: {
            isLoading = true
            Task{
                if let _transaction = try? await  transactionsViewModel.getTransactionByRedemptionCode(recieverPhonenumber: recieverPhonenumber, redemptionCode: redemptionCode){
                    transaction  = _transaction
                }
                isLoading = false
            }
        })
        .navigationTitle(Text("Redeem funds"))
        .alert(isPresented: $showConfirmation){
            if alertType == "confirmation"{
                return  Alert(title: Text("Are you sure you want to redeem funds"), primaryButton: .cancel(), secondaryButton: .default(Text("Redeem funds").fontWeight(.bold),action: {
                    
                    
                    if  selectedCurrency == "NGN"  {
                        
                        if transaction != nil {
                            var _amount :Double = 0
                            
                            switch transaction?.currency  {
                            case "NGN":
                                _amount =  Double(transaction?.amount ?? 0)
                            case "GHS":
                                _amount =  Double(transaction?.amount ?? 0)
                            case "usdt":
                                _amount =  Double(transaction?.amount ?? 0)
                            case .none:
                                _amount =  Double(transaction?.amount ?? 0)
                            case .some(_):
                                _amount =  Double(transaction?.amount ?? 0)
                            }
                            isLoading = true
                            Task{
                                await profileViewModel.updateNGNBalance(uid:profileViewModel.profile.uid,amount:_amount)
                                await transactionsViewModel.markTransactionAsRedeemed(uid: transaction?.uid ?? "", selectedCurrency: selectedCurrency)
                                isLoading = false
                                showConfirmation.toggle()
                                alertType = "done"
                            }
                        }
                                           
    //                    let newWallet = profileViewModel.profile.wallets?.map(  {
    //                        if  $0.name == "NGN" {
    //                            return ProfileWallet(name: "NGN", balance: $0.balance + 1000)
    //                        }else if $0.name != "NGN"{
    //                            return ProfileWallet(name: $0.name, balance: $0.balance )
    //                        }else {
    //                            return ProfileWallet(name: "NGN", balance: $0.balance + 1000)
    //                        }
    //
    //
    //                    })
    //
    //                    var newWallet : [ProfileWallet]
    //                    if  profileViewModel.profile.wallets?.count ?? 0  > 0 {
    //
    //                       newWallet = profileViewModel.profile.wallets?.map(  {
    //                            if  $0.name == "NGN" {
    //                                return ProfileWallet(name: "NGN", balance: $0.balance + 2000)
    //                            }else {
    //                                return ProfileWallet(name: $0.name, balance: $0.balance )
    //                            }
    //
    //
    //                       }) ?? []
    //
    ////                        print("\(newWallet[0].name) \(newWallet[0].balance)")
    ////                        print("\(newWallet[1].name) \(newWallet[1].balance)")
    ////                        print("\(newWallet[2].name) \(newWallet[2].balance)")
    //
    //                    }else {
    //                       newWallet = [ProfileWallet(name: "NGN", balance: 1000)]
    //
    //                        print("\(newWallet[0].name) \(newWallet[0].balance)")
    //                    }
                        


                        
     
                    }
                    if  selectedCurrency == "GHS"{
                        
                        if transaction != nil {
                            var _amount :Double = 0
                            
                            switch transaction?.currency  {
                            case "NGN":
                                _amount =  Double(transaction?.amount ?? 0)
                            case "GHS":
                                _amount =  Double(transaction?.amount ?? 0)
                            case "usdt":
                                _amount =  Double(transaction?.amount ?? 0)
                            case .none:
                                _amount =  Double(transaction?.amount ?? 0)
                            case .some(_):
                                _amount =  Double(transaction?.amount ?? 0)
                            }
                            isLoading = true
                            Task{
                                await profileViewModel.updateGHSBalance(uid:profileViewModel.profile.uid,amount:_amount)
                                await transactionsViewModel.markTransactionAsRedeemed(uid: transaction?.uid ?? "", selectedCurrency: selectedCurrency)
                                isLoading = false
                                showConfirmation.toggle()
                                alertType = "done"
                            }
                        }
                       
                    }
                    if  selectedCurrency == "USDT" {
                        if transaction != nil {
                            var _amount :Double = 0
                            
                            switch transaction?.currency  {
                            case "NGN":
                                _amount =  Double(transaction?.amount ?? 0)
                            case "GHS":
                                _amount =  Double(transaction?.amount ?? 0)
                            case "usdt":
                                _amount =  Double(transaction?.amount ?? 0)
                            case .none:
                                _amount =  Double(transaction?.amount ?? 0)
                            case .some(_):
                                _amount =  Double(transaction?.amount ?? 0)
                            }
                            isLoading = true
                            Task{
                                await profileViewModel.updateUSDTBalance(uid:profileViewModel.profile.uid,amount:_amount)
                                await transactionsViewModel.markTransactionAsRedeemed(uid: transaction?.uid ?? "", selectedCurrency: selectedCurrency)
                                isLoading = false
                                showConfirmation.toggle()
                                alertType = "done"
                            }
                        }
                    }
                    
                }))
            }
            if alertType == "done"{
                return Alert(title: Text("Success!"),message: Text("Money redeemed to your wallet"),dismissButton: .default(Text("You are welcome")){
                    presentationMode.wrappedValue.dismiss()
                })
            }
            return Alert(title: Text("Hello!"),message: Text("Ignore this alert"))
        }
        
        
    }
    
    struct CurrencyItem : Hashable{
        let title : String
        let symbol : String
        let image : String
    }
}

struct RedeemFunds_Previews: PreviewProvider {
    static var previews: some View {
        RedeemFunds(recieverPhonenumber:"xsxs",redemptionCode: "dcdcdc")
    }
}
