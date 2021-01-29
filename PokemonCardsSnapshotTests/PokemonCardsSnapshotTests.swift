//
//  PokemonCardsSnapshotTests.swift
//  PokemonCardsTests
//
//  Created by Daniel Almeida on 16/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
@testable import PokemonCards
import XCTest

class PokemonCardsSnapshotTests: XCTestCase {
  func testCardsList() {
    let cardsClient: CardsClient = .mock(
      all: { [self] _, _ in
        let cards = cardDetailStates(12).map { $0.card }
        return .init(value: .init(cards: cards))
      }
    )

    let favoriteCardsClient: FavoriteCardsClient = .mock(
      all: { .init(value: [Card.mock2]) }
    )

    let mainStore = Store(
      initialState: MainState(),
      reducer: mainReducer,
      environment: .init(
        cardsClient: cardsClient,
        favoriteCardsClient: favoriteCardsClient,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        uuid: UUID.incrementing
      )
    )

    let mainView = MainView(store: mainStore)
    let vc = UIHostingController(rootView: mainView)
    vc.view.frame = UIScreen.main.bounds

//    isRecording = true

    ViewStore(mainStore.scope(state: { $0.cardsState })).send(.cards(.onAppear))
    wait(0.5)
    assertSnapshot(matching: vc, as: .windowedImage)

    ViewStore(mainStore).send(.selectedTabChange(.favorites))

    wait(0.5)
    assertSnapshot(matching: vc, as: .windowedImage)
  }

  /// NavigationLink has some problems when using a binding to activate the navigation, using this simple test to the view only
  func testCardDetail() {
    let store = Store(
      initialState: .init(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        card: Card.mock1
      ),
      reducer: cardDetailReducer,
      environment: CardDetailEnvironment(
        favoriteCardsClient: .mockPreview(),
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )

    let cardListView = CardDetailView(store: store)
    let vc = UIHostingController(rootView: cardListView)
    vc.view.frame = UIScreen.main.bounds

//    isRecording = true

    wait(0.5)
    assertSnapshot(matching: vc, as: .windowedImage)
  }

  // MARK: HELPER

  private func cardDetailStates(_ count: Int) -> [CardDetailState] {
    var mockStateCards: [CardDetailState] = []
    for index in 1 ... count {
      mockStateCards.append(
        .init(
          id: UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", index))")!,
          card: Card.mock1
        )
      )
    }
    return mockStateCards
  }

  private func wait(_ seconds: TimeInterval) {
    let expectation = self.expectation(description: "wait")
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: seconds * 2)
  }
}

/**
 # Taken from
 https://www.pointfree.co/episodes/ep86-swiftui-snapshot-testing
 */
extension Snapshotting where Value: UIViewController, Format == UIImage {
  static var windowedImage: Snapshotting {
    return Snapshotting<UIImage, UIImage>.image.asyncPullback { vc in
      Async<UIImage> { callback in
        UIView.setAnimationsEnabled(false)
        let window = UIApplication.shared.windows.first!
        window.rootViewController = vc
        DispatchQueue.main.async {
          let image = UIGraphicsImageRenderer(bounds: window.bounds).image { _ in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
          }
          callback(image)
          UIView.setAnimationsEnabled(true)
        }
      }
    }
  }
}
