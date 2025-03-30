//
//  UserDetailView.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import SwiftUI

struct UserDetailView: View {
  
  let user: UserListItem
  
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        VStack(alignment: .leading, spacing: 16) {
          Image(user.imagen)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: proxy.size.width)
          VStack(alignment: .leading) {
            Text("Nombre:")
              .font(.title)
            TextField(user.fullName, text: .constant(""))
              .font(.title3)
          }
          VStack(alignment: .leading) {
            Text("Email:")
              .font(.title)
            TextField(user.email, text: .constant(""))
              .font(.title3)
          }
          VStack(alignment: .leading) {
            Text("Telefono:")
              .font(.title)
            Text(user.phone)
              .font(.title3)
          }
          VStack(alignment: .leading) {
            Text("Dirección:")
              .font(.title)
            Text(user.address)
              .font(.title3)
          }
        }
      }
      .padding(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
      .navigationTitle(user.name)
      .edgesIgnoringSafeArea(.bottom)
    }
  }
}

#Preview {
  UserDetailView(user: UserListItem(id: 1,
                                    name: "Bret",
                                    fullName: "Leanne Graham",
                                    phone: "1-770-736-8031 x56442",
                                    email: "Sincere@april.biz",
                                    address: "Kulas Light Apt. 556, Gwenborough",
                                    imagen: "avatar"))
}
