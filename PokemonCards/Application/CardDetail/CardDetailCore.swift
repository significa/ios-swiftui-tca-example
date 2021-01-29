//
//  CardDetailCore.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 02/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture

struct CardDetailState: Equatable, Identifiable {
  let id: UUID
  var card: Card

  var isFavorite = false
  var favorites = [Card]()
}

enum CardDetailAction: Equatable {
  case onAppear
  case onDisappear

  case toggleFavorite
  case favoritesResponse(Result<[Card], Never>)
  case toggleFavoriteResponse(Result<[Card], Never>)
}

struct CardDetailEnvironment {
  var favoriteCardsClient: FavoriteCardsClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer

let cardDetailReducer =
  Reducer<CardDetailState, CardDetailAction, CardDetailEnvironment> { state, action, environment in

    struct CardDetailCancelId: Hashable {}

    switch action {
    case .onAppear:
      return environment.favoriteCardsClient
        .all()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(CardDetailAction.favoritesResponse)
        .cancellable(id: CardDetailCancelId())

    case .favoritesResponse(.success(let favorites)),
         .toggleFavoriteResponse(.success(let favorites)):
      state.favorites = favorites
      state.isFavorite = favorites.contains(where: { $0.id == state.card.id })
      return .none

    case .toggleFavorite:
      if state.isFavorite {
        return environment.favoriteCardsClient
          .remove(state.card)
          .receive(on: environment.mainQueue)
          .catchToEffect()
          .map(CardDetailAction.toggleFavoriteResponse)
          .cancellable(id: CardDetailCancelId())
      } else {
        return environment.favoriteCardsClient
          .add(state.card)
          .receive(on: environment.mainQueue)
          .catchToEffect()
          .map(CardDetailAction.toggleFavoriteResponse)
          .cancellable(id: CardDetailCancelId())
      }

    case .onDisappear:
      return .cancel(id: CardDetailCancelId())
    }
  }
