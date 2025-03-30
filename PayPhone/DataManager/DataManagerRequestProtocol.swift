//
//  DataManagerRequest.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation

protocol DataManagerRequestProtocol {
  
  var scheme: String { get }
  var host: String { get }
  var path: String { get }
  var query: [String : String] { get }
  var headers: [String : String] { get }
  var jsonBody: [String : String] { get }
  var method: String { get }
}

struct DataManagerRequest: DataManagerRequestProtocol {
  
  let scheme: String
  let host: String
  let path: String
  let method: String
  let query: [String : String]
  let headers: [String : String]
  let jsonBody: [String : String]
  
  internal init(scheme: String = "https",
                host: String = "",
                path: String = "",
                method: String = "GET",
                query: [String : String] = [:],
                headers: [String : String] = [:],
                jsonBody: [String : String] = [:]) {
    self.scheme = scheme
    self.host = host
    self.path = path
    self.method = method
    self.query = query
    self.headers = headers
    self.jsonBody = jsonBody
  }
}
