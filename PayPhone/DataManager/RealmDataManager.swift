//
//  RealmDataManager.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation
import Combine
import RealmSwift

enum RealmDataManagerError: Error {
  
  case objectNotFound
  case invalidObject
}

class UserObject: Object, Identifiable, Codable {
  
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var userName: String
  @Persisted var name: String
  @Persisted var phone: String
  @Persisted var email: String
  @Persisted var address: String
}

struct UserModel: Identifiable, Codable {
  
  var id: String
  var userName: String
  var name: String
  var phone: String
  var email: String
  var address: String
 
  init(id: String,
       userName: String,
       name: String,
       phone: String,
       email: String,
       address: String) {
    self.id = id
    self.userName = userName
    self.name = name
    self.phone = phone
    self.email = email
    self.address = address
  }
  
  init(user: UserObject) {
    self.id = user.id.stringValue
    self.name = user.name
    self.phone = user.phone
    self.userName = user.userName
    self.email = user.email
    self.address = user.address
  }
  
  init(user: UserListItem) {
    self.id = user.id
    self.name = user.name
    self.phone = user.phone
    self.userName = user.fullName
    self.email = user.email
    self.address = user.address
  }
}

class UserRealmDataManager: DataManagerProtocol {
  
  func fetch<T: Codable>(request: DataManagerRequestProtocol, type: T.Type) async throws -> T {
    do {
      return try await self.objects(type: type).value
    } catch let error {
      throw error
    }
  }
  
  func update(request: DataManagerRequestProtocol) async throws {
    do {
      try await self.update(request: request).value
    } catch let error {
      throw error
    }
  }
  
  func insert(request: DataManagerRequestProtocol) async throws {
    let user = UserObject()
    user.userName = request.jsonBody["userName"] ?? ""
    user.name = request.jsonBody["name"] ?? ""
    user.phone = request.jsonBody["phone"] ?? ""
    user.email = request.jsonBody["email"] ?? ""
    user.address = request.jsonBody["address"] ?? ""
    try await self.write(user: user).value
  }
  
  func deleteAll() async throws {
    do {
      return try await self.deleteAll().value
    } catch let error {
      throw error
    }
  }
  
  private func update(request: DataManagerRequestProtocol) -> Task<Void, Error> {
    let task: Task<Void, Error> = Task {
      do {
        let realm = try Realm()
        let objectId = try ObjectId(string: request.jsonBody["id"] ?? "")
        guard let user = realm.object(ofType: UserObject.self,
                                      forPrimaryKey: objectId) else {
          throw RealmDataManagerError.invalidObject
        }
        try realm.write {
          user.name = request.jsonBody["userName"] ?? ""
          user.email = request.jsonBody["email"] ?? ""
        }
      } catch let error {
        throw error
      }
    }
    return task
  }
  
  private func deleteAll() -> Task<Void, Error> {
    let task: Task<Void, Error> = Task {
      do {
        let realm = try Realm()
        try realm.write {
          realm.deleteAll()
        }
      } catch let error {
        throw error
      }
    }
    return task
  }
  
  private func write(user: UserObject) -> Task<Void, Error> {
    let task: Task<Void, Error> = Task {
      do {
        let realm = try Realm()
        try realm.write {
          realm.add(user)
        }
      } catch let error {
        throw error
      }
    }
    return task
  }
  
  private func objects<T: Codable>(type: T.Type) -> Task<T, Error> {
    let task: Task<T, Error> = Task {
      do {
        let realm = try Realm()
        let objects = realm.objects(UserObject.self).compactMap { UserModel(user: $0) }.sorted { $0.userName < $1.userName}
        if let results = objects as? T {
          return results
        } else {
          throw RealmDataManagerError.objectNotFound
        }
      } catch let error {
        throw error
      }
    }
    return task
  }
    
}
