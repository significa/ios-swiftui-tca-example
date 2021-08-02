//
//  CardsView.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 26/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct CardsView: View {
  var store: Store<CardsState, CardsAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        ScrollView {
          Group {
            if viewStore.isLoading {
              VStack {
                Spacer()
                ActivityIndicator(
                  style: .large,
                  isAnimating: viewStore.binding(
                    get: { $0.isLoading },
                    send: CardsAction.loadingActive
                  )
                )
                Spacer()
              }
            } else {
              VStack {
                itemsList(viewStore)
                ActivityIndicator(
                  style: .medium,
                  isAnimating: viewStore.binding(
                    get: { $0.isLoadingPage },
                    send: CardsAction.loadingPageActive
                  )
                )
              }
            }
          }
          .padding()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(Localization.Cards.title)
      }
      .onAppear { viewStore.send(.onAppear) }
      .onDisappear { viewStore.send(.onDisappear) }
    }
  }
}

// MARK: - Views

extension CardsView {
  @ViewBuilder
  private func itemsList(_ viewStore: ViewStore<CardsState, CardsAction>) -> some View {
    if #available(iOS 14.0, *) {
      let gridItem = GridItem(.flexible(minimum: 80, maximum: 180))
      LazyVGrid(
        columns: [gridItem, gridItem, gridItem],
        alignment: .center,
        spacing: 16,
        content: { cardsList(viewStore) }
      )
    } else {
      VStack {
        cardsList(viewStore)
      }
    }
  }

  @ViewBuilder
  private func cardsList(_ viewStore: ViewStore<CardsState, CardsAction>) -> some View {
    ForEachStore(
      store.scope(
        state: { $0.cards },
        action: CardsAction.card(id:action:)
      ),
      content: { cardStore in
        WithViewStore(cardStore) { cardViewStore in
          NavigationLink(
            destination: CardDetailView(store: cardStore),
            label: {
              CardItemView(
                card: cardViewStore.state.card,
                isFavorite: viewStore.state.isFavorite(with: cardViewStore.state.card)
              )
              .onAppear {
                viewStore.send(.retrieveNextPageIfNeeded(currentItem: cardViewStore.state.id))
              }
            }
          )
        }
      }
    )
  }
}

// MARK: - Previews

struct CardsView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach(["en", "pt_PT"], id: \.self) { id in
      CardsView(
        store: .init(
          initialState: .init(
            cards: .init(
              uniqueElements: Cards.mock.cards.map {
                CardDetailState(
                  id: .init(),
                  card: $0
                )
              }
            )
          ),
          reducer: cardsReducer,
          environment: .init(
            cardsClient: .mockPreview(),
            favoriteCardsClient: .mockPreview(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            uuid: UUID.init
          )
        )
      )
      .environment(\.locale, .init(identifier: id))
    }
  }
}
