//
//  UserCreateView.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import SwiftUI

struct UserCreateView: View {
  
  let interactor: UserInteractorInput?
  @Binding var showAddView: Bool
  @State private var errorMessage: String = ""
  @State private var fullName: String = ""
  @State private var email: String = ""
  @State private var phone: String = ""
  @State var invalidatedForm = false
  
  var body: some View {
    GeometryReader { proxy in
      ScrollView {
        ZStack {
          VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
              Text("Nombre:")
                .font(.title)
              TextField("Nombre", text: self.$fullName)
                .font(.title3)
            }
            VStack(alignment: .leading) {
              Text("Email:")
                .font(.title)
              TextField("Email", text: self.$email)
                .font(.title3)
            }
            VStack(alignment: .leading) {
              Text("Telefono:")
                .font(.title)
              TextField("Telefono", text: self.$phone)
                .font(.title3)
            }
            VStack(alignment: .leading, spacing: 16) {
              HStack {
                Spacer()
                Button("Guardar", action: {
                  self.validateForm()
                  if !self.invalidatedForm {
                    Task {
                      let user = UserModel(id: UUID().uuidString,
                                           userName: self.fullName,
                                           name: self.fullName,
                                           phone: self.phone,
                                           email: self.email,
                                           address: "")
                      await self.interactor?.insertUser(user: user)
                      await self.interactor?.getLocalUsers()
                      self.showAddView.toggle()
                    }
                  }
                })
                .font(.title)
                Spacer()
              }
              HStack {
                Spacer()
                Button("Cerrar", action: {
                  self.showAddView.toggle()
                })
                .font(.title)
                Spacer()
              }
            }
          }
        }
        .alert(self.errorMessage,
               isPresented: self.$invalidatedForm) {
          Button("OK", role: .cancel) { }
        }
      }
      .padding(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
      .edgesIgnoringSafeArea(.bottom)
    }
  }
  
  private func validateForm() {
    var messages: [String] = []
    let validatedEmail = self.isValidEmail(text: self.email)
    if !validatedEmail {
      messages.append("email inválido")
    }
    let validatedPhone = !self.phone.isEmpty
    if !validatedPhone {
      messages.append("Telefono vacío")
    }
    let validatedName = !self.fullName.isEmpty
    if !validatedName {
      messages.append("Nombre vacío")
    }
    self.invalidatedForm = !(validatedEmail && validatedPhone && validatedName)
    self.errorMessage = messages.joined(separator: "\n")
  }
  
  private func isValidEmail(text: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: text)
  }
}
