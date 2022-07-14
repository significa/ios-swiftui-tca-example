//
//  CardItemView.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 02/12/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct CardItemView: View {
  let card: Card
  let isFavorite: Bool

  var body: some View {
    ZStack(alignment: .topTrailing) {
      VStack(alignment: .leading, spacing: 4) {
        KFImage(card.images.smallURL)
          .placeholder {
            ActivityIndicator(
              style: .large,
              isAnimating: .constant(true)
            )
          }
          .resizable()
          .aspectRatio(CGSize(width: 600, height: 825), contentMode: .fit)
          .clipped()
        HStack {
          VStack(alignment: .leading, spacing: 0) {
            Text(card.name)
              .font(.system(size: 18, weight: .bold))
              .lineLimit(1)
            Text(card.hp ?? "-")
              .font(.system(size: 12, weight: .regular))
          }
          Spacer()
          if isFavorite {
            Image(systemName: "star.fill")
              .imageScale(.small)
          }
        }
      }
    }
  }
}

// MARK: - Previews

struct CardItemView_Previews: PreviewProvider {
  static var previews: some View {
    CardItemView(card: .mock1, isFavorite: true)
  }
}
