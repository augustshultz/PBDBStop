//
//  Created by August Shultz on 12/13/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
  case noDataError
}

class NetworkController {
  private let session = URLSession.shared
  private let decoder = JSONDecoder()
  
  func loadPredictions(fromUrl url: URL, _ completion: @escaping (Result<[Prediction], Error>) -> Void) {
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let data = data else {
        completion(.failure(NetworkingError.noDataError))
        return
      }
      
      do {
        let timeInterval = UserDefaults.standard.integer(forKey: "look_ahead")
        let predictions = try self.decoder.decode([Prediction].self, from: data)
        completion(.success(predictions.filter { $0.minutes <= timeInterval }))
      } catch let error {
        completion(.failure(error))
      }
    }
    task.resume()
  }
}

