//
//  TransactionListView.swift
//  PayFam
//
//  Created by Mattosha on 29/11/2022.
//

import SwiftUI

struct TransactionListView: View {
    let names : [String] = [
        "Eric","Linda","Babara","Mike","Mattosha"
    ]
    
    var body: some View {
        List{
            ForEach(names, id: \.self ){name in
                HStack(alignment:.center){
                    AsyncImage(url: URL(string: "https://avatars.dicebear.com/api/pixel-art/\(name).png")) { resImage in
                        resImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40,height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }

                   
                    VStack(alignment: .leading){
                        Text(name)
                            .font(.callout)
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
                            .font(.caption)
                        
                    }
                }
                .padding()
            }
        }
        .listStyle(.plain)
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
