//
//  FavoriteButton.swift
//  Core
//
//  Created by Daniel Almeida on 27/08/2020.
//  Copyright © 2020 Coletiv Studio, Lda. All rights reserved.
//

import SwiftUI

struct FavoriteButton: View {
  let action: () -> Void
  let isFavorite: Bool

  var body: some View {
    Button(
      action: action,
      label: { Image(systemName: isFavorite ? "star.fill" : "star") }
    )
    .frame(width: 32, height: 44)
  }
}

// MARK: - Previews

struct FavoriteButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FavoriteButton(
        action: {},
        isFavorite: true
      )
      .previewLayout(.sizeThatFits)
      FavoriteButton(
        action: {},
        isFavorite: false
      )
      .previewLayout(.sizeThatFits)
    }
  }
}
