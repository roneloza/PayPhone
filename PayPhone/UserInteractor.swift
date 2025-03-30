//
//  UserInteractor.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation

protocol UserListInteractorInput {
  
  var output: UserListInteractorOutput { get }
  
  func getUsers() async
}

protocol UserListInteractorOutput {
  
  @MainActor func setUsers(users: [UserResponse])
  func handleError(error: Error)
}

struct UserListInteractor: UserListInteractorInput {
  
  let output: UserListInteractorOutput
  let dataManager: UserDataManagerProtocol
  
  func getUsers() async {
    let request = NetworkDataManagerRequest(host: "https://jsonplaceholder.typicode.com",
                                            path: "users")
    do {
      let data = try await self.dataManager.getUsers(request: request)
      await self.output.setUsers(users: data)
    } catch let error as NetworkDataManagerError {
      self.output.handleError(error: error)
    } catch { }
  }
}
