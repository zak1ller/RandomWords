//
//  PublisherExtension.swift
//  RandomWords
//
//  Created by Min-Su Kim on 2022/08/15.
//

import Foundation
import Combine

extension Publisher {
  static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
    return Fail(error: error).eraseToAnyPublisher()
  }
}
