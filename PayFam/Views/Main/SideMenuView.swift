//
//  SideMenuView.swift
//  PayFam
//
//  Created by Mattosha on 28/11/2022.
//

import SwiftUI
import SwiftUIFontIcon

struct SideMenuView: View {
    
    @Binding var currentTab : String
    @Binding var showSideMenu : Bool
    
    @State var username : String = "Mattosha"
    
    var body: some View {
        VStack{
            VStack(spacing:10){
                AsyncImage(url: URL(string: "https://avatars.dicebear.com/api/pixel-art/\(username).png")) { resImage in
                    resImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:45,height:45)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }

                Text("@\(username)")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth:.infinity,alignment: .leading)
            
            ScrollView(getScreenBounds().height < 750 ? .vertical : .init() ){
                //MARK: Tab buttons
                VStack(alignment: .leading, spacing: 25){
                    CustomTabButton(icon: "house.fill", title: "Home")
                    CustomTabButton( title: "My Wallet",useSystemName: false,FontText: FontIcon.text(.awesome5Solid(code: .wallet)))
                    CustomTabButton(title: "Transactions",useSystemName: false,FontText: FontIcon.text(.materialIcon(code: .receipt)))
                    
                    
                    Spacer()
                    CustomTabButton(icon: "gearshape.fill", title: "Settings",useSystemName: true)
                    CustomTabButton(icon: "power.circle.fill", title: "Logout")
                }
                .padding()
                .padding(.top,45)
            }
            .frame(width:getScreenBounds().width / 2 + 80,alignment: .leading)
            .frame(maxWidth:.infinity,alignment: .leading)
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top).background(showSideMenu ? Color.primaryBrandColor.opacity(0.6) : .systemBacground)
        
    }
    
    
    //MARK: Custom tabs
    @ViewBuilder
    func CustomTabButton(icon: String = "house.fill", title: String,useSystemName: Bool = true, FontText:Text =  FontIcon.text(.materialIcon(code: .access_alarm))
       
        )-> some View{
        Button {
            if title == "Logout"{
                showSideMenu.toggle()
                
            }else{
                withAnimation {
                    currentTab = title
                    showSideMenu.toggle()
                }
            }
          
        } label: {
            HStack(spacing:12){
                
                if useSystemName {
                    Image(systemName: icon)
                        .font(.title3)
                        .frame(width: currentTab == title ? 48 : nil,height:48)
                        .foregroundColor(currentTab == title ? Color.primaryBrandColor: (title == "Logout" ? .orange : Color.primaryBrandColor))
                        .background(
                            Color.white.clipShape(Circle())
                        )
                }else{
                    FontText
                        .font(.title3)
                        .frame(width: 48,height:48)
                        .foregroundColor(Color.primaryBrandColor)
                        .background(
                            ZStack{
                                if currentTab == title {
                                    Color.white.clipShape(Circle())
                                }
                            }
                        )
                }
              
                
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(currentTab == title ? .white : title == "Logout" ? .orange : .primaryBrandColor)
                    
                
            }
            .padding(.trailing,18)
            .background(
                ZStack{
                    if currentTab  == title {
                        Color.primaryBrandColor.clipShape(Capsule())
                    }
                })
           
          
        }

    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
