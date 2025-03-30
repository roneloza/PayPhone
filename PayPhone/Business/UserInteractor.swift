//
//  UserInteractor.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation

protocol UserInteractorInput {
  
  var output: UserInteractorOutput { get }
  
  func loadExternalUsers() async
  func getLocalUsers() async
  func updateUser(user: UserModel) async
  func insertUser(user: UserModel) async
  func deleteAll() async
}

protocol UserInteractorOutput {
  
  @MainActor func setUsers(users: [UserModel])
  @MainActor func handleError(error: Error)
}

struct UserInteractor: UserInteractorInput {
  
  let output: UserInteractorOutput
  let dataManager: UserDataManagerProtocol
  
  func loadExternalUsers() async {
    let request = DataManagerRequest(host: "jsonplaceholder.typicode.com",
                                            path: "/users")
    do {
      let data = try await self.dataManager.getUsers(request: request)
      for item in data {
        let request = DataManagerRequest(jsonBody: ["id" : item.id.description,
                                                    "name" : item.name,
                                                    "userName" : item.userName,
                                                    "phone" : item.phone,
                                                    "email" : item.email,
                                                    "address" : item.address.street])
//        Task {
        try await self.dataManager.insert(request: request)
//        }
      }
      let users = try await self.dataManager.getLocalUsers(request: request)
      await self.output.setUsers(users: users)
    } catch let error {
      await self.output.handleError(error: error)
    }
  }
  
  func getLocalUsers() async {
    let request = DataManagerRequest()
    do {
      let users = try await self.dataManager.getLocalUsers(request: request)
      await self.output.setUsers(users: users)
    } catch let error {
      await self.output.handleError(error: error)
    }
  }
  
  func updateUser(user: UserModel) async {
    do {
      let request = DataManagerRequest(jsonBody: ["id" : user.id,
                                                  "name" : user.name,
                                                  "userName" : user.userName,
                                                  "phone" : user.phone,
                                                  "email" : user.email,
                                                  "address" : user.address])
      try await self.dataManager.update(request: request)
    } catch let error {
      await self.output.handleError(error: error)
    }
  }
  
  func insertUser(user: UserModel) async {
    do {
      let request = DataManagerRequest(jsonBody: ["id" : user.id,
                                                  "name" : user.name,
                                                  "userName" : user.userName,
                                                  "phone" : user.phone,
                                                  "email" : user.email,
                                                  "address" : user.address])
      try await self.dataManager.insert(request: request)
    } catch let error {
      await self.output.handleError(error: error)
    }
  }
  
  func deleteAll() async {
    do {
      try await self.dataManager.deleteAll()
    } catch let error {
      await self.output.handleError(error: error)
    }
  }
}
