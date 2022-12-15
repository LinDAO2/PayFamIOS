//
//  AppLogoView.swift
//  PayFam
//
//  Created by Mattosha on 03/12/2022.
//
import SwiftUI

struct AppLogoView: View {

    
    private var xSmallSize : CGFloat = 30
    private var smallSize : CGFloat = 100
    private var mediumSize : CGFloat  = 150
    private var largeSize  : CGFloat  = 200
   
    var size : LogoSize
    
    init( size : LogoSize){
       
        self.size = size
    }
    
    var body: some View {
        
        Image("logo")
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Rectangle())
            .frame(width:size == .small ? smallSize : size == .medium ? mediumSize : size == .large ? largeSize : smallSize,height:size == .small ? smallSize : size == .medium ? mediumSize : size == .large ? largeSize : size == .xsmall ? xSmallSize : smallSize)
            
        
    }
}

enum LogoColor {
    case white
    case blue
    case black
}

enum LogoSize {
    case xsmall
    case small
    case medium
    case large
}

struct AppLogoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            AppLogoView(size: .small)
            AppLogoView(size:.medium)
            AppLogoView(size:.large)
        }
    }
}
