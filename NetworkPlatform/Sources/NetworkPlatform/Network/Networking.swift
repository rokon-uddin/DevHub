//
//  Networking.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Alamofire
import Combine
import CombineMoya
import Foundation
import Moya
import Utilities

class OnlineProvider<Target> where Target: Moya.TargetType {
  private let online: AnyPublisher<Bool, Never>
  private let provider: MoyaProvider<Target>

  init(
    endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure =
      MoyaProvider<Target>.defaultEndpointMapping,
    requestClosure: @escaping MoyaProvider<Target>.RequestClosure =
      MoyaProvider<Target>.defaultRequestMapping,
    stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<
      Target
    >.neverStub,
    session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
    plugins: [PluginType] = [VerbosePlugin(verbose: false)],
    trackInflights: Bool = false,
    online: AnyPublisher<Bool, Never>
  ) {
    self.online = online
    provider = MoyaProvider(
      endpointClosure: endpointClosure,
      requestClosure: requestClosure,
      stubClosure: stubClosure,
      session: session,
      plugins: plugins,
      trackInflights: trackInflights)
  }

  func request(_ target: Target) -> AnyPublisher<Moya.Response, MoyaError> {
    return provider.requestPublisher(target)
      .mapError { $0 }
      .handleEvents(
        receiveOutput: { _ in },
        receiveCompletion: { _ in }
      )
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
