//
//  UserResponse.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation

struct UserResponse: Codable {
  
  let id: Int
  let userName: String
  let name: String
  let email: String
  let phone: String
  let address: UserAddressResponse
  
  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case userName = "username"
    case email
    case phone
    case address
  }
}

struct UserAddressResponse: Codable {
  
  let street: String
  let suite: String
  let city: String
  let zipcode: String
  let geo: UserAddressGeoResponse
}

struct UserAddressGeoResponse: Codable {
  
  let lat: String
  let lng: String
}
