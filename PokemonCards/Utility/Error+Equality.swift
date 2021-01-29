//
//  Error+Equality.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 27/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import Foundation

/**
 # Inspired by:
 https://kandelvijaya.com/2018/04/21/blog_equalityonerror/
 */
class ErrorUtility {
  public static func areEqual(_ lhs: Error, _ rhs: Error) -> Bool {
    return lhs.reflectedString == rhs.reflectedString
  }
}

public extension Error {
  var reflectedString: String {
    return String(reflecting: self)
  }

  func isEqual(to: Self) -> Bool {
    return reflectedString == to.reflectedString
  }
}

public extension NSError {
  func isEqual(to: NSError) -> Bool {
    let lhs = self as Error
    let rhs = to as Error
    return isEqual(to) && lhs.reflectedString == rhs.reflectedString
  }
}
