//
//  UserInteractor.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation

protocol UserInteractorInput {
  
  var output: UserInteractorOutput { get }
  
  func getUsers() async
  func updateUsers(user: UserResponse) async
  func insertUsers(user: UserResponse) async
}

protocol UserInteractorOutput {
  
  @MainActor func setUsers(users: [UserResponse])
  @MainActor func handleError(error: Error)
}

struct UserInteractor: UserInteractorInput {
  
  let output: UserInteractorOutput
  let dataManager: UserDataManagerProtocol
  
  func getUsers() async {
    let request = NetworkDataManagerRequest(host: "jsonplaceholder.typicode.com",
                                            path: "/users")
    do {
      let data = try await self.dataManager.getUsers(request: request)
      await self.output.setUsers(users: data)
    } catch let error {
      await self.output.handleError(error: error)
    }
  }
  
  func updateUsers(user: UserResponse) async {
    
  }
  
  func insertUsers(user: UserResponse) async {
    
  }
}
