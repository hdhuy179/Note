//
//  CartItem.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 25.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import Foundation
import Differentiator

struct CartItem: Equatable {
  let coffee: Coffee
  let count: Int
  let totalPrice: Float
  
  init(coffee: Coffee, count: Int) {
    self.coffee = coffee
    self.count = count
    self.totalPrice = Float(count) * coffee.price
  }
}

extension CartItem: IdentifiableType {
    var identity: String {
        coffee.name
    }
    
    typealias Identity = String
    
    
}
