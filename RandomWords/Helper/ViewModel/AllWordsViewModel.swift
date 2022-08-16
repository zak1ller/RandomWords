//
//  AllWordsViewModel.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/16.
//

import Foundation
import Combine

final class AllWordsViewModel {
  let network = NetworkService(configuration: .default)
  
  var subscriptions = Set<AnyCancellable>()
  
  @Published var words: [String] = []
  @Published var showingLoading = false

  let wordTappedAction = PassthroughSubject<String, Never>()
}

extension AllWordsViewModel {
  func fetchWords() {
    let resource = Resource<[String]>(
      base: "https://random-word-api.herokuapp.com/",
      path: "all",
      params: [:],
      header: ["Content-Type": "application/json"]
    )
    
    showingLoading = true
    
    network.load(resource)
      .sink { completion in
        self.showingLoading = false
        switch completion {
        case .failure(let error):
          print(error)
          break
        case .finished:
          break
        }
      } receiveValue: { words in
        self.words = words
      }
      .store(in: &subscriptions)
  }
  
  func shuffle() {
    words.shuffle()
  }
}
