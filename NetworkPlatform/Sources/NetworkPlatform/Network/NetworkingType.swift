//
//  NetworkingType.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Alamofire
import Combine
import Foundation
import Moya
import Utilities

protocol ProductAPIType {
  var addXAuth: Bool { get }
}

protocol NetworkingType {
  associatedtype T: TargetType, ProductAPIType
  var provider: OnlineProvider<T> { get }

  static func defaultNetworking() -> Self
  static func stubbingNetworking() -> Self
}

extension NetworkingType {
  static func endpointsClosure<T>(_: String? = nil) -> (T) -> Endpoint
  where T: TargetType, T: ProductAPIType {
    return { MoyaProvider.defaultEndpointMapping(for: $0) }
  }

  static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
    return .never
  }

  static var plugins: [PluginType] {
    var plugins: [PluginType] = []
    plugins.append(NetworkLoggerPlugin())
    return plugins
  }

  static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
    return { endpoint, closure in
      do {
        var request = try endpoint.urlRequest()
        request.httpShouldHandleCookies = false
        closure(.success(request))
      } catch {
        Logger.log(logLevel: .error, error)
      }
    }
  }
}

// MARK: - Provider support

func stubbedResponse(_ filename: String) -> Data! {
  @objc class TestClass: NSObject {}

  let bundle = Bundle(for: TestClass.self)
  let path = bundle.path(forResource: filename, ofType: "json")
  return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

extension String {
  fileprivate var URLEscapedString: String {
    return addingPercentEncoding(
      withAllowedCharacters: CharacterSet.urlHostAllowed)!
  }
}

func url(_ route: TargetType) -> String {
  return route.baseURL.appendingPathComponent(route.path).absoluteString
}
