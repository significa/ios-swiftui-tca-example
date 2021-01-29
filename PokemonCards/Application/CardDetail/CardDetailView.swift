//
//  CardDetailView.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 03/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture
import KingfisherSwiftUI
import SwiftUI

struct CardDetailView: View {
  let store: Store<CardDetailState, CardDetailAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        KFImage(viewStore.card.imageHDURL)
          .placeholder {
            ActivityIndicator(
              style: .large,
              isAnimating: .constant(true)
            )
          }
          .resizable()
          .aspectRatio(CGSize(width: 600, height: 825), contentMode: .fit)
          .clipped()
          .padding(.horizontal, 16)
        Spacer()
      }
      .padding(.top, 32)
      .navigationBarTitle(viewStore.card.name)
      .navigationBarItems(trailing: favoriteButton(viewStore))
      .onAppear { viewStore.send(.onAppear) }
      .onDisappear { viewStore.send(.onDisappear) }
    }
  }
}

// MARK: - Views

extension CardDetailView {
  @ViewBuilder
  private func favoriteButton(_ viewStore: ViewStore<CardDetailState, CardDetailAction>) -> some View {
    WithViewStore(store.scope(state: { $0.isFavorite })) { favoriteViewStore in
      FavoriteButton(
        action: { viewStore.send(.toggleFavorite) },
        isFavorite: favoriteViewStore.state
      )
    }
  }
}

// MARK: - Previews

struct CardDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CardDetailView(
        store: .init(
          initialState: CardDetailState(
            id: .init(),
            card: .mock1
          ),
          reducer: cardDetailReducer,
          environment: .init(
            favoriteCardsClient: .mockPreview(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
    }
  }
}
