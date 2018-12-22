//
//  Created by August Shultz on 12/13/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  var state: State<Prediction> = .loading {
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
    return state.rowObjects.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let prediction = state.rowObjects[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionTableViewCell", for: indexPath)
    cell.textLabel?.text = prediction.name
    cell.detailTextLabel?.text = format(secondsForDisplay: prediction.seconds)
    return cell
  }
  
  func format(secondsForDisplay seconds: Int?) -> String? {
    guard let seconds = seconds else {
      return nil
    }
    let minutes = seconds / 60
    let secondsRemaining = seconds % 60
    var format: String = ""
    if minutes != 0 {
      format = "\(minutes) m "
      
    }
    if secondsRemaining != 0 {
      format = "\(format)\(secondsRemaining) s"
    }
    return format
  }
}

extension TableViewController: NetworkControllerDelegate {
  func predictions(_ predictions: [Prediction]) {
    state = .populated(predictions)
  }
  
  func errorFetchingPredictions(error: String) {
    state = .error
  }
}