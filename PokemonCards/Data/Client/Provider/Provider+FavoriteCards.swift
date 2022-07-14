//
//  Provider+FavoriteCards.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 11/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import ComposableArchitecture
import Foundation

extension Provider {
  func getFavorites() -> Effect<[Card], Never> {
    let cards = getFavorites().map { Card(with: $0) }
    return .init(value: cards)
  }

  private func getFavorites() -> [FavoriteCard] {
    var favorites = [FavoriteCard]()
    do {
      favorites = try context.fetch(FavoriteCard.fetchRequest())
    } catch {
      debugPrint("error retrieving cards: \(error)")
    }

    return favorites
  }

  func addFavorite(_ card: Card) -> Effect<[Card], Never> {
    guard !hasFavorite(with: card) else { return getFavorites() }

    _ = FavoriteCard.instance(from: card, with: context)
    CoreData.shared.saveContext()

    return getFavorites()
  }

  func removeFavorite(_ card: Card) -> Effect<[Card], Never> {
    guard
      let favoriteId = getFavorites().filter({ $0.id == card.id }).first?.objectID,
      let favoriteCard = context.object(with: favoriteId) as? FavoriteCard
    else { return getFavorites() }

    context.delete(favoriteCard)
    CoreData.shared.saveContext()

    return getFavorites()
  }

  private func hasFavorite(with card: Card) -> Bool {
    let favorite = getFavorites().filter { $0.id == card.id }.first
    return favorite != nil
  }
}
