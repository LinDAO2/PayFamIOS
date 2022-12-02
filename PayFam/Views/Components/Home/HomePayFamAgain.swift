//
//  HomePayFamAgain.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct HomePayFamAgain: View {
    let names : [String] = [
        "Eric","Linda","Babara","Mike","Mattosha"
    ]
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(names, id: \.self ){name in
                    VStack(alignment:.center){
                        AsyncImage(url: URL(string: "https://avatars.dicebear.com/api/pixel-art/\(name).png")) { resImage in
                            resImage
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70,height: 70)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }

                       
                        Text(name)
                    }
                    .padding()
                }
            }
        }
    }
}

struct HomePayFamAgain_Previews: PreviewProvider {
    static var previews: some View {
        HomePayFamAgain()
    }
}
