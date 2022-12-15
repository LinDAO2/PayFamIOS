//
//  HomePayFamAgain.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct HomePayFamAgain: View {
    
    @State var loadingRecipients : Bool  = false
    
    func getPaymentTitle(phonenumber : String)->String{
        if phonenumber.contains("233") {
            return "Mobile Money"
        }else if phonenumber.contains("234"){
            return "Bank Transfer"
        }else{
            return "Cryptocurrency"
        }
    }
    func getPaymentMethod(phonenumber : String)-> TransactionPaymethod{
        if phonenumber.contains("233") {
            return .mobileMobile
        }else if phonenumber.contains("234"){
            return .bankTransfer
        }else{
            return .cryptocurrency
        }
    }
   
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            
            if loadingRecipients {
                Spacer()
                HStack{
                    ProgressView()
                    
                }
            }
            
            if loadingRecipients == false {
               
                    HStack{
                        ForEach(TransactionsViewModel.instance.recipientList, id: \.uid ){recipient in
                            
                            NavigationLink{
                                SendMoneyView(paymentMethod: getPaymentMethod(phonenumber:recipient.recieverPhonenumber ),
                                              activeStep: 1,paymentMethodTitle:getPaymentTitle(phonenumber:recipient.recieverPhonenumber ),selectedRecipient: RecipientModel(uid: recipient.uid, userId: recipient.userId, recieverName: recipient.recieverName, recieverPhonenumber: recipient.recieverPhonenumber))
                            }label: {
                                VStack(alignment:.center){
                                    AsyncImage(url: URL(string: "https://avatars.dicebear.com/api/pixel-art/\(recipient.recieverName.removeSpecialCharsFromString()).png")) { resImage in
                                        resImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 40,height: 40)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }

                                   
                                    Text(recipient.recieverName)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                            }
                          
                        }
                    }
                
            }
          
        }
        .onAppear(perform: {
            loadingRecipients = true
            Task{
                await TransactionsViewModel.instance.getRecipients(userId: ProfileViewModel.instance.profile.uid)
                loadingRecipients = false
            }
        })
    }
}

struct HomePayFamAgain_Previews: PreviewProvider {
    static var previews: some View {
        HomePayFamAgain()
    }
}
