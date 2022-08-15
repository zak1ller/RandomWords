//
//  RandomWordService.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/15.
//

import Foundation
import Combine

enum NetworkError: Error {
  case invalidRequest
  case invalidResponse
  case responseError(statusCode: Int)
}

final class NetworkService {
  static let baseUrl = "https://random-word-api.herokuapp.com/"
  static let allUrl = "https://random-word-api.herokuapp.com/all"
  static let wordUrl = "https://random-word-api.herokuapp.com/word"
  
  let session: URLSession
  
  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }
  
  func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
    guard let request = resource.urlRequest else {
      return .fail(NetworkError.invalidRequest)
    }
    
    return session
      .dataTaskPublisher(for: request)
      .tryMap { result -> Data in
        guard let response = result.response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
          let response = result.response as? HTTPURLResponse
          let statusCode = response?.statusCode ?? -1
          throw NetworkError.responseError(statusCode: statusCode)
        }
        return result.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
