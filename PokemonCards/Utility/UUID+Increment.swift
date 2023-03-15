//
//  UUID+Increment.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 11/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
/**
 # Taken from Composable Architecture Examples:
 https://github.com/pointfreeco/swift-composable-architecture/blob/c1f88bd8608e8a26fd61ab46c9f11a63b0f4023d/Examples/CaseStudies/SwiftUICaseStudies/03-Effects-SystemEnvironment.swift#L216
 // swiftlint:enable line_length
 */
extension UUID {
  /// A deterministic, auto-incrementing "UUID" generator for testing.
  static var incrementing: () -> UUID {
    var uuid = 0
    return {
      defer { uuid += 1 }
      return UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", uuid))")!
    }
  }
}
