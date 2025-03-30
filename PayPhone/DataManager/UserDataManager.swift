//
//  UserDataManager.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation
import Combine

protocol UserDataManagerProtocol {
  
  func getUsers(request: DataManagerRequest) async throws-> [UserResponse]
}

struct UserDataManager: UserDataManagerProtocol {
  
  let dataManager: DataManagerProtocol
  
  func getUsers(request: DataManagerRequest) async throws-> [UserResponse] {
    try await self.dataManager.fetch(request: request,
                                     type: [UserResponse].self)
  }
}
