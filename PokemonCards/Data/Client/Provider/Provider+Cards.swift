//
//  Provider+Cards.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 26/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import Combine
import Foundation

extension Provider {
  /**
   # TGC Reference
   https://docs.pokemontcg.io/#api_v1cards_list
   */
  func cardsPage(number: Int, size: Int) -> AnyPublisher<Cards, ProviderError> {
    var request = URLRequest(url: Router.cardsPage(number: number, size: size).url!)
    request.httpMethod = "GET"

    return requestPublisher(request)
  }
}
