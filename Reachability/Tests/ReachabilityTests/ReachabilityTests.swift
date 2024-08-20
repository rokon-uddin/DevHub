import XCTest

@testable import Reachability

final class ReachabilityTests: XCTestCase {

  func testReachabilitySatisfiedWifi() async {
    let client = ReachabilityClient.satisfiedWifi

    let stream = await client.networkPathPublisher()
    var paths = [NetworkPath]()

    for await path in stream {
      paths.append(path)
    }

    XCTAssertEqual(paths.count, 1)
    XCTAssertEqual(paths.first?.reachability, .connected(interface: .wifi))
  }

  func testReachabilitySatisfiedCellular() async {
    let client = ReachabilityClient.satisfiedCellular

    let stream = await client.networkPathPublisher()
    var paths = [NetworkPath]()

    for await path in stream {
      paths.append(path)
    }

    XCTAssertEqual(paths.count, 1)
    XCTAssertEqual(paths.first?.reachability, .connected(interface: .cellular))
  }

  func testReachabilityUnsatisfied() async {
    let client = ReachabilityClient.unsatisfied

    let stream = await client.networkPathPublisher()
    var paths = [NetworkPath]()

    for await path in stream {
      paths.append(path)
    }

    XCTAssertEqual(paths.count, 1)
    XCTAssertEqual(paths.first?.reachability, .notConnected)
  }
}
