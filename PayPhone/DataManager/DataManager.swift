//
//  DataManager.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation

protocol DataManagerProtocol {
  
  func fetch<T: Codable>(request: DataManagerRequestProtocol, type: T.Type) async throws -> T
  func update(request: DataManagerRequestProtocol) async throws
  func insert(request: DataManagerRequestProtocol) async throws
  func deleteAll() async throws
}

