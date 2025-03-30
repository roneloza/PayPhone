//
//  ContentView.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var viewModel = UserViewModel()
  @State var showAddView = false
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          ForEach(self.viewModel.users) { user in
            UserListItemView(user: user, interactor: self.viewModel.interactor)
          }
        }
      }
      .navigationTitle("UserListTitle")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add", action: { showAddView = true })
            .fullScreenCover(isPresented: $showAddView, content: {
              UserCreateView(
                interactor: self.viewModel.interactor,
                showAddView: self.$showAddView) })
        }
      }
      .task {
        await self.viewModel.interactor?.deleteAll()
        await self.viewModel.interactor?.loadExternalUsers()
      }
      .alert(self.viewModel.errorMessage,
             isPresented: self.$viewModel.showingAlert) {
        Button("OK", role: .cancel) { }
      }
    }
  }
  
  init() {
    let presenter: UserInteractorOutput = UserPresenter(viewModel: self.viewModel)
    let interactor: UserInteractorInput = UserInteractor(
      output: presenter,
      dataManager: UserDataManager(apiDataManager: NetworkDataManager(),
                                   localDataManager: UserRealmDataManager()))
    self.viewModel.interactor = interactor
  }
}

#Preview {
  ContentView()
}

struct UserListItemView: View {
  
  let user: UserListItem
  let interactor: UserInteractorInput?
  
  var body: some View {
    NavigationLink(destination: UserDetailView(user: user,
                                               interactor: self.interactor)) {
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
