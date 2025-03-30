//
//  UserDetailView.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import SwiftUI

struct UserDetailView: View {
  
  let user: UserListItem
  let interactor: UserInteractorInput?
  @State private var fullName: String = ""
  @State private var email: String = ""
  
  init(user: UserListItem, interactor: UserInteractorInput?) {
    self.user = user
    self.interactor = interactor
    _fullName = State(initialValue: user.fullName)
    _email = State(initialValue: user.email)
  }
  
  var body: some View {
      GeometryReader { proxy in
        ScrollView {
        ZStack {
          VStack(alignment: .leading, spacing: 16) {
            Image(user.imagen)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity, maxHeight: proxy.size.width)
            VStack(alignment: .leading) {
              Text("Nombre:")
                .font(.title)
              TextField(user.fullName, text: self.$fullName)
                .font(.title3)
            }
            VStack(alignment: .leading) {
              Text("Email:")
                .font(.title)
              TextField(user.email, text: self.$email)
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
            VStack(alignment: .leading) {
              HStack {
                Spacer()
                Button("Guardar", action: {
                  Task {
                    await self.interactor?.updateUser(
                      user: UserModel(id: self.user.id,
                                      userName: self.fullName,
                                      name: self.user.name,
                                      phone: self.user.phone,
                                      email: self.email,
                                      address: self.user.address))
                    await self.interactor?.getLocalUsers()
                  }
                })
                .font(.title)
                Spacer()
              }
            }
          }
        }
      }
      .padding(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
      .edgesIgnoringSafeArea(.bottom)
    }
  }
}

#Preview {
//  UserDetailView(user: UserListItem(id: UUID().uuidString,
//                                    name: "Bret",
//                                    fullName: "Leanne Graham",
//                                    phone: "1-770-736-8031 x56442",
//                                    email: "Sincere@april.biz",
//                                    address: "Kulas Light Apt. 556, Gwenborough",
//                                    imagen: "avatar"))
}
