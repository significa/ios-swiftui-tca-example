//
//  Cards.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 02/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import Foundation

struct Card: Codable, Equatable, Identifiable {
  var id: String
  var name: String
  var hp: String?

  var imageURLString: String
  var imageURL: URL? {
    return URL(string: imageURLString)
  }

  var imageHDURLString: String
  var imageHDURL: URL? {
    return URL(string: imageHDURLString)
  }

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case hp
    case imageURLString = "imageUrl"
    case imageHDURLString = "imageUrlHiRes"
  }

  init(
    id: String,
    name: String,
    hp: String? = nil,
    imageURLString: String,
    imageHDURLString: String
  ) {
    self.id = id
    self.name = name
    self.hp = hp
    self.imageURLString = imageURLString
    self.imageHDURLString = imageHDURLString
  }
}

// MARK: Inits

extension Card {
  init(with favorite: FavoriteCard) {
    self.id = favorite.id ?? ""
    self.name = favorite.name ?? ""
    self.hp = favorite.hp
    self.imageURLString = favorite.imageURL ?? ""
    self.imageHDURLString = favorite.imageHDURL ?? ""
  }
}

// MARK: Mock

extension Card {
  static var mock1: Card {
    Card(
      id: "xy7-4",
      name: "Bellossom",
      hp: "120",
      imageURLString: "https://images.pokemontcg.io/xy7/4.png",
      imageHDURLString: "https://images.pokemontcg.io/xy7/4_hires.png"
    )
  }

  static var mock2: Card {
    Card(
      id: "ex16-1",
      name: "Aggron",
      hp: "110",
      imageURLString: "https://images.pokemontcg.io/ex16/1.png",
      imageHDURLString: "https://images.pokemontcg.io/ex16/1_hires.png"
    )
  }
}

// MARK: - Cards

struct Cards: Codable, Equatable, Identifiable {
  var id = UUID()
  var cards: [Card]

  enum CodingKeys: String, CodingKey {
    case cards
  }
}

// MARK: Mock

extension Cards {
  static var mock: Cards = .init(
    cards: [
      Card.mock1,
      Card.mock2
    ]
  )
}
