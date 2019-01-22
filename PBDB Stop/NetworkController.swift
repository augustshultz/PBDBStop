//
//  Created by August Shultz on 12/13/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import Foundation

class NetworkController {
  private let session = URLSession.shared
  private let decoder = JSONDecoder()
  weak var delegate: NetworkControllerDelegate?
  
  func loadPredictions() {
    guard let url = URL(string: "https://api.bongo.org/predictions/0264") else { return }
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        self.notifyDelegate(ofError: error.localizedDescription)
      }
      if let data = data {
        do {
          let predictions = try self.decoder.decode([Prediction].self, from: data)
          self.notifyDelegate(ofPredictions: predictions)
        } catch let error as NSError {
          self.notifyDelegate(ofError: error.localizedDescription)
        }
      } else {
        self.notifyDelegate(ofError: "Invalid response")
      }
    }
    task.resume()
  }
  
  private func notifyDelegate(ofError error: String) {
    DispatchQueue.main.async {
      self.delegate?.errorFetchingPredictions(error: error)
    }
  }
  
  private func notifyDelegate(ofPredictions predictions: [Prediction]) {
    DispatchQueue.main.async {
      self.delegate?.predictions(predictions)
    }
  }
}

protocol NetworkControllerDelegate: class {
  func predictions(_ predictions: [Prediction])
  func errorFetchingPredictions(error: String)
}
