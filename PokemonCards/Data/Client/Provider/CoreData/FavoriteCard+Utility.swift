//
//  FavoriteCard+Utility.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 17/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import CoreData

extension FavoriteCard {
  static func instance(from card: Card, with context: NSManagedObjectContext) -> FavoriteCard {
    let newFavorite = FavoriteCard(context: context)
    newFavorite.id = card.id
    newFavorite.name = card.name
    newFavorite.hp = card.hp
    newFavorite.imageURL = card.imageURLString
    newFavorite.imageHDURL = card.imageHDURLString

    return newFavorite
  }
}
