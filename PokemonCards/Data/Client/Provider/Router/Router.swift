//
//  Router.swift
//  PokemonCards
//
//  Created by Daniel Almeida on 26/11/2020.
//  Copyright © 2020 Coletiv. All rights reserved.
//

import Foundation

struct Route {
  let path: String
  let queryItems: [URLQueryItem]?

  init(path: String, queryItems: [URLQueryItem]? = nil) {
    self.path = path
    self.queryItems = queryItems
  }

  var url: URL? {
    var components = URLComponents()

    components.scheme = "https"
    components.host = Environment.apiURL.absoluteString
    components.path = "/\(Environment.apiVersion)/\(path)"
    components.queryItems = queryItems

    return components.url
  }
}

struct Router {}
