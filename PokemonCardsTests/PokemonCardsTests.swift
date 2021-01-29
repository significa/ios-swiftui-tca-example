//
//  PokemonCardsTests.swift
//  PokemonCardsTests
//
//  Created by Daniel Almeida on 26/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture
@testable import PokemonCards
import XCTest

class PokemonCardsTests: XCTestCase {
  static let scheduler = DispatchQueue.testScheduler

  struct TestError: Error {}
  let error: ProviderError = .network(error: TestError())

  let mockStateCards: [CardDetailState] = [
    .init(
      id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
      card: Card.mock1
    ),
    .init(
      id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
      card: Card.mock2
    )
  ]

  let cardsStore = TestStore(
    initialState: CardsState(),
    reducer: cardsReducer,
    environment: CardsEnvironment(
      cardsClient: .mock(),
      favoriteCardsClient: .mock(),
      mainQueue: scheduler.eraseToAnyScheduler(),
      uuid: UUID.incrementing
    )
  )

  func testCardsListSuccess() {
    // Success retrieving data
    cardsStore.assert(
      .environment {
        $0.cardsClient.page = { _, _ in Effect(value: Cards.mock) }
        $0.favoriteCardsClient.all = { Effect(value: []) }
      },

      .send(.retrieve) { _ in },
      .receive(.loadingActive(true)) {
        $0.isLoading = true
      },

      .do { PokemonCardsTests.scheduler.advance() },
      .receive(.cardsResponse(.success(Cards.mock))) {
        $0.cards = .init(self.mockStateCards)
      },

      .receive(.loadingActive(false)) {
        $0.isLoading = false
      },

      .receive(.loadingPageActive(false)) {
        $0.isLoadingPage = false
      },

      .receive(.retrieveFavorites) { _ in },

      .receive(.favoritesResponse(.success([]))) {
        $0.favorites = []
      }
    )
  }

  func testCardsListError() {
    // Error retrieving data
    cardsStore.assert(
      .environment {
        $0.cardsClient.page = { [self] _, _ in
          .init(error: error)
        }
        $0.favoriteCardsClient.all = { Effect(value: []) }
      },

      .send(.retrieve) { _ in },
      .receive(.loadingActive(true)) {
        $0.isLoading = true
      },

      .do { PokemonCardsTests.scheduler.advance() },
      .receive(.cardsResponse(.failure(error))) {
        $0.cards = []
      },

      .receive(.loadingActive(false)) {
        $0.isLoading = false
      },

      .receive(.loadingPageActive(false)) {
        $0.isLoadingPage = false
      },

      .receive(.retrieveFavorites) { _ in },

      .receive(.favoritesResponse(.success([]))) {
        $0.favorites = []
      }
    )
  }

  func testToggleFavorite() {
    let store = TestStore(
      initialState: CardDetailState(
        id: .init(),
        card: .mock1
      ),
      reducer: cardDetailReducer,
      environment: CardDetailEnvironment(
        favoriteCardsClient: .mock(),
        mainQueue: PokemonCardsTests.scheduler.eraseToAnyScheduler()
      )
    )

    // Toggle Favorite
    store.assert(
      .environment {
        $0.favoriteCardsClient.all = { .init(value: []) }
        $0.favoriteCardsClient.add = { _ in .init(value: [Card.mock1]) }
        $0.favoriteCardsClient.remove = { _ in .init(value: []) }
      },

      .send(.onAppear) { _ in },
      .do { PokemonCardsTests.scheduler.advance() },
      .receive(.favoritesResponse(.success([]))) {
        $0.favorites = []
      },

      .send(.toggleFavorite) { _ in },
      .do { PokemonCardsTests.scheduler.advance() },
      .receive(.toggleFavoriteResponse(.success([Card.mock1]))) {
        $0.favorites = [Card.mock1]
        $0.isFavorite = true
      },

      .send(.toggleFavorite) { _ in },
      .do { PokemonCardsTests.scheduler.advance() },
      .receive(.toggleFavoriteResponse(.success([]))) {
        $0.favorites = []
        $0.isFavorite = false
      }
    )
  }

  func testFavoritesList() {
    let store = TestStore(
      initialState: FavoritesState(),
      reducer: favoritesReducer,
      environment: FavoritesEnvironment(
        favoriteCardsClient: .mock(),
        mainQueue: PokemonCardsTests.scheduler.eraseToAnyScheduler(),
        uuid: UUID.incrementing
      )
    )

    store.assert(
      .environment {
        $0.favoriteCardsClient.all = { Effect(value: Cards.mock.cards) }
      },

      .send(.onAppear) { _ in },
      .receive(.retrieveFavorites) { _ in },

      .do { PokemonCardsTests.scheduler.advance() },
      .receive(.favoritesResponse(.success(Cards.mock.cards))) {
        $0.cards = .init(self.mockStateCards)
      }
    )
  }
}
