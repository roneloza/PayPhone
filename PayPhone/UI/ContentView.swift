//
//  ContentView.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var viewModel = UserViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          ForEach(self.viewModel.users) { user in
            UserListItemView(user: user)
          }
        }
      }
      .navigationTitle("UserListTitle")
    }
    .onAppear {
      Task {
        await self.viewModel.interactor?.getUsers()
      }
    }
    .alert(self.viewModel.errorMessage,
           isPresented: self.$viewModel.showingAlert) {
      Button("OK", role: .cancel) { }
    }
  }
  
  init() {
    let presenter: UserInteractorOutput = UserPresenter(viewModel: self.viewModel)
    let interactor: UserInteractorInput = UserInteractor(output: presenter,
                                                         dataManager: UserDataManager(dataManager: NetworkDataManager()))
    self.viewModel.interactor = interactor
  }
}

#Preview {
  ContentView()
}

struct UserListItemView: View {
  
  let user: UserListItem
  
  var body: some View {
    NavigationLink(destination: UserDetailView(user: user)) {
      HStack {
        Image(user.imagen)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 70, height: 70)
          .cornerRadius(5)
        VStack(alignment: .leading) {
          Text(user.name)
            .font(.headline)
          Text(user.fullName)
            .font(.callout)
          Text(user.phone)
            .font(.callout)
          Text(user.email)
            .font(.callout)
          Text(user.address)
            .font(.callout)
        }
      }
      .padding(.vertical, 8)
    }
  }
}
