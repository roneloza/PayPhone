//
//  DataManager.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation

protocol DataManagerProtocol {
  
  func fetch<T: Codable>(request: DataManagerRequest, type: T.Type) async throws -> T
}

