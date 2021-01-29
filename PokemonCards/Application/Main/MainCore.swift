//
//  MainCore.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 17/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture

struct MainState: Equatable {
  var cardsState = CardsState()
  var favoritesState = FavoritesState()

  enum Tab {
    case cards
    case favorites
  }

  var selectedTab = Tab.cards
}

enum MainAction {
  case cards(CardsAction)
  case favorites(FavoritesAction)

  case selectedTabChange(MainState.Tab)
}

struct MainEnvironment {
  var cardsClient: CardsClient
  var favoriteCardsClient: FavoriteCardsClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var uuid: () -> UUID
}

// MARK: - Reducer

let mainReducer: Reducer<MainState, MainAction, MainEnvironment> = .combine(
  cardsReducer.pullback(
    state: \MainState.cardsState,
    action: /MainAction.cards,
    environment: { environment in
      CardsEnvironment(
        cardsClient: environment.cardsClient,
        favoriteCardsClient: environment.favoriteCardsClient,
        mainQueue: environment.mainQueue,
        uuid: environment.uuid
      )
    }
  ),
  favoritesReducer.pullback(
    state: \MainState.favoritesState,
    action: /MainAction.favorites,
    environment: { environment in
      FavoritesEnvironment(
        favoriteCardsClient: environment.favoriteCardsClient,
        mainQueue: environment.mainQueue,
        uuid: environment.uuid
      )
    }
  ),
  .init { state, action, environment in

    switch action {
    // Update favorites on Cards State
    case .cards(.card(id: _, action: .toggleFavoriteResponse(.success(let favorites)))):
      state.favoritesState.cards = .init(
        favorites.map {
          CardDetailState(
            id: environment.uuid(),
            card: $0
          )
        }
      )
      return .none

    case .cards:
      return .none

    // Update favorites on Favorites State
    case .favorites(.card(id: _, action: .toggleFavoriteResponse(.success(let favorites)))):
      state.cardsState.favorites = favorites
      return .none

    case .favorites:
      return .none

    case .selectedTabChange(let selectedTab):
      state.selectedTab = selectedTab
      return .none
    }
  }
)
