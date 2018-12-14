//
//  Created by August Shultz on 12/13/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import UIKit

enum State {
  case loading
  case error
  case empty
  case populated([Prediction])
  
  var predictions: [Prediction] {
    switch self {
    case .populated(let predictions):
      return predictions
    default:
      return []
    }
  }
}

class ViewController: UITableViewController {
  
  var state: State = .loading {
    didSet {
      tableView.reloadData()
    }
  }

  let networkController = NetworkController()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    networkController.delegate = self
    networkController.loadPredictions()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return state.predictions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let prediction = state.predictions[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionTableViewCell", for: indexPath)
    cell.textLabel?.text = prediction.name
    cell.detailTextLabel?.text = "\(prediction.seconds)"
    return cell
  }
}

extension ViewController: NetworkControllerDelegate {
  func predictions(_ predictions: [Prediction]) {
    state = .populated(predictions)
  }
  
  func errorFetchingPredictions(error: String) {
    state = .error
  }
}
