//
//  FavoriteCardsClient.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 27/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture

struct FavoriteCardsClient {
  var all: () -> Effect<[Card], Never>
  var add: (_ card: Card) -> Effect<[Card], Never>
  var remove: (_ card: Card) -> Effect<[Card], Never>
}

// MARK: - Live

extension FavoriteCardsClient {
  static let live = FavoriteCardsClient(
    all: {
      Provider.shared
        .getFavorites()
    },
    add: { card in
      Provider.shared
        .addFavorite(card)
    },
    remove: { card in
      Provider.shared
        .removeFavorite(card)
    }
  )
}

// MARK: - Mock

extension FavoriteCardsClient {
  static func mock(
    all: @escaping () -> Effect<[Card], Never> = {
      fatalError("Unmocked")
    },
    add: @escaping (Card) -> Effect<[Card], Never> = { _ in
      fatalError("Unmocked")
    },
    remove: @escaping (Card) -> Effect<[Card], Never> = { _ in
      fatalError("Unmocked")
    }
  ) -> Self {
    Self(
      all: all,
      add: add,
      remove: remove
    )
  }

  static func mockPreview(
    all: @escaping () -> Effect<[Card], Never> = {
      .init(value: [Card.mock1])
    },
    add: @escaping (Card) -> Effect<[Card], Never> = { _ in
      .init(value: [Card.mock2])
    },
    remove: @escaping (Card) -> Effect<[Card], Never> = { _ in
      .init(value: [])
    }
  ) -> Self {
    Self(
      all: all,
      add: add,
      remove: remove
    )
  }
}
