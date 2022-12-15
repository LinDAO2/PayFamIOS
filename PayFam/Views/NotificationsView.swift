//
//  NotificationsView.swift
//  PayFam
//
//  Created by Mattosha on 03/12/2022.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        List{
            ForEach(0..<10){  index in
                HStack{
                    Text("This is a  notification")
                }
            }
        }
        .listStyle(.plain)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
