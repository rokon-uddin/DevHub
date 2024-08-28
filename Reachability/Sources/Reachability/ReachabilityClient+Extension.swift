//
//  ReachabilityClient+Extension.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/25/24.
//

import Combine

extension ReachabilityClient {
  public func networkPathPublisher() -> AnyPublisher<Bool, Never> {
    let subject = PassthroughSubject<Bool, Never>()
    Task {
      for await networkPath in await networkPathStream() {
        let isOnline = networkPath.reachability.isOnline
        subject.send(isOnline)
      }
      subject.send(completion: .finished)
    }
    return subject.eraseToAnyPublisher()
  }
}
