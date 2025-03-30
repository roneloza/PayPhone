//
//  UserPresenter.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import UIKit

class UserPresenter: UserInteractorOutput {
  
  weak var viewModel: UserPresenterInput?
  
  init(viewModel: UserPresenterInput? = nil) {
    self.viewModel = viewModel
  }
  
  @MainActor func setUsers(users: [UserModel]) {
    self.viewModel?.setUsers(users: self.formatUsers(users: users))
  }
  
  private func formatUsers(users: [UserModel]) -> [UserListItem] {
    return users.compactMap { UserListItem(id: $0.id,
                                           name: $0.userName,
                                           fullName: $0.name,
                                           phone: $0.phone,
                                           email: $0.email,
                                           address: $0.address,
                                           imagen: "avatar") }
  }
  
  func handleError(error: Error) {
    self.viewModel?.setShowAlert(value: true, errorMessage: error.localizedDescription)
  }
}

protocol UserPresenterInput: AnyObject {
  
  var users: [UserListItem] { get }
  var interactor: UserInteractorInput? { get set }
  
  @MainActor func setUsers(users: [UserListItem])
  @MainActor func setShowAlert(value: Bool, errorMessage: String)
}

struct UserListItem: Identifiable {
  
  let id: String
  let name: String
  let fullName: String
  let phone: String
  let email: String
  let address: String
  let imagen: String
}

class UserViewModel: ObservableObject, UserPresenterInput {
  
  @Published var showingAlert = false
  @Published private(set) var users: [UserListItem] = []
  private(set) var errorMessage: String = ""
  var interactor: UserInteractorInput?
  
  @MainActor func setUsers(users: [UserListItem]) {
    self.users = users
  }
  
  @MainActor func setShowAlert(value: Bool, errorMessage: String) {
    self.showingAlert = value
    self.errorMessage = errorMessage
  }
}
