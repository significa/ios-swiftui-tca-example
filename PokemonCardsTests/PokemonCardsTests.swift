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
  static let scheduler = DispatchQueue.test

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
  
  let cardDetailStore = TestStore(
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
  
  let favoritesStore = TestStore(
    initialState: FavoritesState(),
    reducer: favoritesReducer,
    environment: FavoritesEnvironment(
      favoriteCardsClient: .mock(),
      mainQueue: PokemonCardsTests.scheduler.eraseToAnyScheduler(),
      uuid: UUID.incrementing
    )
  )
  
  // Success retrieving data
  func testCardsListSuccess() async {
    cardsStore.environment.cardsClient.page = { _, _ in EffectPublisher(value: Cards.mock) }
    cardsStore.environment.favoriteCardsClient.all = { EffectPublisher(value: []) }
    
    await cardsStore.send(.retrieve)
    await cardsStore.receive(.loadingActive(true)) {
      $0.isLoading = true
    }
    
    await PokemonCardsTests.scheduler.advance()
    await cardsStore.receive(.cardsResponse(.success(Cards.mock))) {
      $0.cards = .init(uniqueElements: self.mockStateCards)
    }
    
    await cardsStore.receive(.loadingActive(false)) {
      $0.isLoading = false
    }
    await cardsStore.receive(.loadingPageActive(false))
    
    await cardsStore.receive(.retrieveFavorites)
    await cardsStore.receive(.favoritesResponse(.success([])))
  }

  // Error retrieving data
  func testCardsListError() async {
    cardsStore.environment.cardsClient.page = { [self] _, _ in .init(error: error) }
    cardsStore.environment.favoriteCardsClient.all = { EffectPublisher(value: []) }
    
    await cardsStore.send(.retrieve)
    await cardsStore.receive(.loadingActive(true)) {
      $0.isLoading = true
    }

    await PokemonCardsTests.scheduler.advance()
    await cardsStore.receive(.cardsResponse(.failure(error)))

    await cardsStore.receive(.loadingActive(false)) {
      $0.isLoading = false
    }

    await cardsStore.receive(.loadingPageActive(false))

    await cardsStore.receive(.retrieveFavorites)
    await cardsStore.receive(.favoritesResponse(.success([])))
  }

  func testToggleFavorite() async {

    cardDetailStore.environment.favoriteCardsClient.all = { .init(value: []) }
    cardDetailStore.environment.favoriteCardsClient.add = { _ in .init(value: [Card.mock1]) }
    cardDetailStore.environment.favoriteCardsClient.remove = { _ in .init(value: []) }
    
    await cardDetailStore.send(.onAppear)
    await PokemonCardsTests.scheduler.advance()
    await cardDetailStore.receive(.favoritesResponse(.success([])))

    await cardDetailStore.send(.toggleFavorite)
    await PokemonCardsTests.scheduler.advance()
    await cardDetailStore.receive(.toggleFavoriteResponse(.success([Card.mock1]))) {
      $0.favorites = [Card.mock1]
      $0.isFavorite = true
    }

    await cardDetailStore.send(.toggleFavorite)
    await PokemonCardsTests.scheduler.advance()
    await cardDetailStore.receive(.toggleFavoriteResponse(.success([]))) {
      $0.favorites = []
      $0.isFavorite = false
    }
  }

  func testFavoritesList() async {
    favoritesStore.environment.favoriteCardsClient.all = { EffectTask(value: Cards.mock.cards) }
    
    await favoritesStore.send(.onAppear)
    await favoritesStore.receive(.retrieveFavorites)

    await PokemonCardsTests.scheduler.advance()
    await favoritesStore.receive(.favoritesResponse(.success(Cards.mock.cards))) {
      $0.cards = .init(uniqueElements: self.mockStateCards)
    }
  }
}
