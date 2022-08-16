//
//  WordViewModel.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/16.
//

import Foundation
import Combine

final class WordViewModel {
  let network = NetworkService(configuration: .default)
  
  var subscriptions = Set<AnyCancellable>()
  
  @Published var word = ""
}

extension WordViewModel {
  func fetchWord(isReload: Bool = false) {
    if isReload {
      word = ""
    }
    
    let resource = Resource<[String]>(
      base: "https://random-word-api.herokuapp.com/",
      path: "word",
      params: [:],
      header: ["Content-Type": "application/json"]
    )
    
    network.load(resource)
      .sink { completion in
        switch completion {
        case .failure(let error):
          print(error)
          break
        case .finished:
          break
        }
      } receiveValue: { words in
        self.word = words.first ?? ""
      }
      .store(in: &subscriptions)
  }
}
