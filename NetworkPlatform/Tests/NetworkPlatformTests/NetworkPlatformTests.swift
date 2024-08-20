import Combine
import XCTest

@testable import Domain
@testable import NetworkPlatform

final class NetworkPlatformTests: XCTestCase {
  var networking: AppNetworking!

  override func setUp() {
    super.setUp()
    networking = AppNetworking.stubbingNetworking()
  }

  func testReadUserDetailSuccess() async throws {
    let repository = RemoteUserDetailRepository.stubbed
    let userDetail = try await repository.read(input: "rokon-uddin")
    XCTAssertNotNil(userDetail)
  }

  func testRequestObjectSuccess() async throws {
    let expectation = self.expectation(description: "Successful object request")
    let userDetail = try await networking.requestObject(.userDetail("username"), type: UserDetail.self)
    XCTAssertNotNil(userDetail)
    await fulfillment(of: [expectation])
  }

}
