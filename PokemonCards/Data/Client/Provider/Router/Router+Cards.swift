//
//  Router+Cards.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 26/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import Foundation

extension Router {
  static func cardsPage(number: Int, size: Int) -> Route {
    return
      Route(
        path: "cards",
        queryItems: [
          .init(name: "page", value: "\(number)"),
          .init(name: "pageSize", value: "\(size)")
        ]
      )
  }
}
