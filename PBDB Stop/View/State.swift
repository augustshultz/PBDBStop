//
//  Created by August Shultz on 12/14/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import Foundation

enum State<T> {
  case loading
  case error(String)
  case empty
  case populated([T])
  
  var rowObjects: [T] {
    switch self {
    case .populated(let rowObjects):
      return rowObjects
    default:
      return []
    }
  }
}
