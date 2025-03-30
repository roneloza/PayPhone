//
//  UserDataManager.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation
import Combine

protocol UserDataManagerProtocol {
  
  func getUsers(request: DataManagerRequestProtocol) async throws-> [UserResponse]
  func getLocalUsers(request: DataManagerRequestProtocol) async throws-> [UserModel]
  func insert(request: DataManagerRequestProtocol) async throws
  func update(request: DataManagerRequestProtocol) async throws
  func deleteAll() async throws
}

struct UserDataManager: UserDataManagerProtocol {
  
  let apiDataManager: DataManagerProtocol
  let localDataManager: DataManagerProtocol
  
  func getUsers(request: DataManagerRequestProtocol) async throws-> [UserResponse] {
    try await self.apiDataManager.fetch(request: request,
                                     type: [UserResponse].self)
  }
  
  func insert(request: DataManagerRequestProtocol) async throws {
    try await self.localDataManager.insert(request: request)
  }
  
  func getLocalUsers(request: DataManagerRequestProtocol) async throws-> [UserModel] {
    try await self.localDataManager.fetch(request: request, type: [UserModel].self)
  }
  
  func deleteAll() async throws {
    try await self.localDataManager.deleteAll()
  }
  
  func update(request: DataManagerRequestProtocol) async throws {
    try await self.localDataManager.update(request: request)
  }
}
