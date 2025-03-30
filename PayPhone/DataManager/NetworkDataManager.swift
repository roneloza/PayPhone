//
//  NetworkDataManager.swift
//  PayPhone
//
//  Created by Rone Shender Loza Aliaga on 29/03/25.
//

import Foundation
import Combine

enum NetworkDataManagerError: Error {
  
  case urlMalFormed
  case decodeTypeFailure
}

struct NetworkDataManager: DataManagerProtocol {
  
  func fetch<T: Codable>(request: DataManagerRequest, type: T.Type) async throws -> T {
    var urlComponents = URLComponents()
    urlComponents.host = request.host
    urlComponents.scheme = request.scheme
    urlComponents.path = request.path
    urlComponents.queryItems = request.query.compactMap { URLQueryItem(name: $0.key, value: $0.value)}
    
    guard let url = urlComponents.url,
          !request.host.isEmpty
    else {
      throw NetworkDataManagerError.urlMalFormed
    }
    let dataBody = (request.jsonBody.isEmpty ?
                    nil :
                      try? JSONSerialization.data(withJSONObject: request.jsonBody, options: []))
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method
    urlRequest.httpBody = dataBody
    let (data, _) = try await URLSession.shared.data(for: urlRequest)
    let fetchedData = try JSONDecoder().decode(type, from: data)
    return fetchedData
  }
  
}

