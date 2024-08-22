//
//  AppNetworking.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Combine
import Domain
import Foundation
import Moya

struct AppNetworking: NetworkingType {
  typealias T = AppAPI
  let provider: OnlineProvider<T>

  static func defaultNetworking() -> Self {
    return AppNetworking(
      provider:
        OnlineProvider(
          endpointClosure: AppNetworking.endpointsClosure(),
          requestClosure: AppNetworking.endpointResolver(),
          stubClosure: AppNetworking.APIKeysBasedStubBehaviour,
          online: Just(true).setFailureType(to: Never.self)
            .eraseToAnyPublisher()))
  }

  static func stubbingNetworking() -> Self {
    return AppNetworking(
      provider:
        OnlineProvider(
          endpointClosure: endpointsClosure(),
          requestClosure: AppNetworking.endpointResolver(),
          stubClosure: MoyaProvider.immediatelyStub,
          online: Just(true).setFailureType(to: Never.self)
            .eraseToAnyPublisher()))
  }

  func request(_ target: T) -> AnyPublisher<Moya.Response, MoyaError> {
    let actualRequest = provider.request(target)
    return actualRequest
  }

  func requestObject<T: Codable>(
    _ target: AppAPI,
    type _: T.Type
  ) async throws -> T {
    return try await request(target)
      .filterSuccessfulStatusCodes()
      .map(T.self)
      .mapError { $0.asAppError }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
      .async()
  }

  func requestResponseAndHeader<T: Codable>(
    _ target: AppAPI,
    type _: T.Type
  ) async throws -> RemoteResponse<T> {
    return try await request(target)
      .filterSuccessfulStatusCodes()
      .tryMap { try RemoteResponse(data: $0.data, response: $0.response) }
      .mapError { error -> AppError in
        guard let error = error as? MoyaError else { return AppError.network(error, context: "Network") }
        return error.asAppError
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
      .async()
  }
}

extension MoyaError {
  public var asAppError: AppError {
    AppError.network(response?.response?.networkRequestError ?? self, context: "Network")
  }
}
