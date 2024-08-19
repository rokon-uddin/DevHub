//
//  AppNetworkingTests.swift
//
//
//  Created by Mohammed Rokon Uddin on 8/19/24.
//

import XCTest

@testable import Domain
@testable import NetworkPlatform

class AppNetworkingTests: XCTestCase {

  var networking: AppNetworking!

  override func setUp() {
    super.setUp()
    networking = AppNetworking.stubbingNetworking()

  }

  override func tearDown() {
    networking = nil
    super.tearDown()
  }

  func testRequestObjectSuccess() async throws {
    let expectation = self.expectation(description: "Successful object request")
    let userDetail = try await networking.requestObject(.userDetail("username"), type: UserDetail.self)
    XCTAssertNotNil(userDetail)
    await fulfillment(of: [expectation])
  }
}
