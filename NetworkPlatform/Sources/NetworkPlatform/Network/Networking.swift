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
    plugins: [PluginType] = [VerbosePlugin(verbose: true)],
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
        receiveOutput: { response in
          Logger.log(logLevel: .debug, response)
        },
        receiveCompletion: { completion in
          switch completion {
          case .finished:
            Logger.log(logLevel: .info, "Success")
          case let .failure(error):
            // TODO: handle network error
            Logger.log(logLevel: .error, error)
          }
        }
      )
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
