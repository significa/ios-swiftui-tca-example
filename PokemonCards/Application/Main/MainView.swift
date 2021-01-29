//
//  MainView.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 17/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
  let store: Store<MainState, MainAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      TabView(
        selection: viewStore.binding(
          get: { $0.selectedTab },
          send: MainAction.selectedTabChange
        ),
        content: {
          Group {
            CardsView(store: cardsStore)
              .tabItem {
                Image(systemName: "greetingcard")
                Text(Localization.Cards.title)
              }
              .tag(MainState.Tab.cards)
            FavoritesView(store: favoritesStore)
              .tabItem {
                Image(systemName: "star")
                Text(Localization.Favorites.title)
              }
              .tag(MainState.Tab.favorites)
          }
        }
      )
    }
  }
}

// MARK: - Store inits

extension MainView {
  private var cardsStore: Store<CardsState, CardsAction> {
    return store.scope(
      state: { $0.cardsState },
      action: MainAction.cards
    )
  }

  private var favoritesStore: Store<FavoritesState, FavoritesAction> {
    return store.scope(
      state: { $0.favoritesState },
      action: MainAction.favorites
    )
  }
}

// MARK: - Previews

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(
      store: .init(
        initialState: MainState(),
        reducer: mainReducer,
        environment: .init(
          cardsClient: .mockPreview(),
          favoriteCardsClient: .mockPreview(),
          mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
          uuid: UUID.init
        )
      )
    )
  }
}
