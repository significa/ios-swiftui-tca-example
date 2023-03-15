//
//  CardsClient.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 27/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture

struct CardsClient {
  var page: (_ number: Int, _ size: Int) -> EffectPublisher<Cards, ProviderError>
}

// MARK: - Live

extension CardsClient {
  static let live = CardsClient(
    page: { number, size in
      Provider.shared
        .cardsPage(number: number, size: size)
        .eraseToEffect()
    }
  )
}

// MARK: - Mock

extension CardsClient {
  static func mock(
    all: @escaping (Int, Int) -> EffectPublisher<Cards, ProviderError> = { _, _ in
      fatalError("Unmocked")
    }
  ) -> Self {
    Self(
      page: all
    )
  }

  static func mockPreview(
    all: @escaping (Int, Int) -> EffectPublisher<Cards, ProviderError> = { _, _ in
      .init(value: Cards.mock)
    }
  ) -> Self {
    Self(
      page: all
    )
  }
}
