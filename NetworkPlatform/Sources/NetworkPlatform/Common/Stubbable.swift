//
//  Stubbable.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

protocol Stubble {

}

extension Stubble {
  func stubbedResponse(_ filename: String) -> Data! {
    let path = Bundle.module.path(
      forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
  }
}
