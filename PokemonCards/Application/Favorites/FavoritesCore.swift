//
//  FavoritesCore.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 26/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture

struct FavoritesState: Equatable {
  var cards = IdentifiedArrayOf<CardDetailState>()
}

enum FavoritesAction: Equatable {
  case retrieveFavorites
  case favoritesResponse(Result<[Card], Never>)

  case card(id: UUID, action: CardDetailAction)

  case onAppear
  case onDisappear
}

struct FavoritesEnvironment {
  var favoriteCardsClient: FavoriteCardsClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var uuid: () -> UUID
}

// MARK: - Reducer

let favoritesReducer =
  Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment>.combine(
    cardDetailReducer.forEach(
      state: \.cards,
      action: /FavoritesAction.card(id:action:),
      environment: { environment in
        .init(
          favoriteCardsClient: environment.favoriteCardsClient,
          mainQueue: environment.mainQueue
        )
      }
    ),
    .init { state, action, environment in

      struct FavoritesCancelId: Hashable {}

      switch action {
      case .onAppear:
        guard state.cards.isEmpty else { return .none }
        return .init(value: .retrieveFavorites)

      case .retrieveFavorites:
        return environment.favoriteCardsClient
          .all()
          .receive(on: environment.mainQueue)
          .catchToEffect()
          .map(FavoritesAction.favoritesResponse)
          .cancellable(id: FavoritesCancelId())

      case .favoritesResponse(.success(let favorites)):
        state.cards = .init(
          uniqueElements: favorites.map {
            CardDetailState(
              id: environment.uuid(),
              card: $0
            )
          }
        )
        return .none

      case .card(id: _, action: .onDisappear):
        return .init(value: .retrieveFavorites)

      case .card(id: _, action: _):
        return .none

      case .onDisappear:
        return .cancel(id: FavoritesCancelId())
      }
    }
  )
