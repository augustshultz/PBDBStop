//
//  Created by August Shultz on 12/13/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import Foundation

class NetworkController {
  private let session = URLSession.shared
  private let decoder = JSONDecoder()
  
  typealias RequestCompletion = ([Prediction]?, String?) -> Void
  
  func loadPredictions(fromUrl url: URL, _ completion: @escaping RequestCompletion) {
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(nil, error.localizedDescription)
      } else if let data = data {
        do {
          let predictions = try self.decoder.decode([Prediction].self, from: data)
          completion(predictions, nil)
        } catch let error as NSError {
          completion(nil, error.localizedDescription)
        }
      } else {
        completion(nil, "Invalid response")
      }
    }
    task.resume()
  }
}

