//
//  HomeCarouselSubView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI

struct HomeCarouselSubView: View {
    
   
    @State private var images : [String] = [
        "https://images.pexels.com/photos/9011185/pexels-photo-9011185.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/5649229/pexels-photo-5649229.jpeg?auto=compress&cs=tinysrgb&w=800",
        "https://images.pexels.com/photos/10228155/pexels-photo-10228155.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
    ]
    var body: some View {
        VStack{
            TabView{
                           ForEach((images), id: \.self) { image in
                               AsyncImage(url: URL(string: image)) { resImage in
                                   resImage
                                       .resizable()
                                       .aspectRatio(contentMode: .fill)
                                       .frame(height: 200)
                                       .clipShape(RoundedRectangle(cornerRadius: 20))

                               } placeholder: {
                                   ProgressView()
                               }
                           }
                       }
                       .tabViewStyle(PageTabViewStyle())
            
     
        }
        .padding(.top,10)
        .frame(height: 250)
       
    }
}


struct HomeCarouselSubView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCarouselSubView()
    }
}
