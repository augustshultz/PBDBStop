//
//  Created by August Shultz on 12/13/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  let networkController = NetworkController()
  
  @IBOutlet weak var loadingView: UIView?
  @IBOutlet weak var noUpcomingArrivals: UIView?
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
  
  var state: State<Prediction> = .loading {
    didSet {
      setFooterView()
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = loadingView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    networkController.delegate = self
    networkController.loadPredictions()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return state.rowObjects.count
  }
  
  @IBAction func refresh(_ sender: UIBarButtonItem) {
    state = .loading
    networkController.loadPredictions()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let prediction = state.rowObjects[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionTableViewCell", for: indexPath)
    cell.textLabel?.text = prediction.name
    cell.detailTextLabel?.text = "\(prediction.minutes) m"
    return cell
  }
  
  func setFooterView() {
    switch state {
    case .loading:
      tableView.tableFooterView = loadingView
    case .empty:
      tableView.tableFooterView = noUpcomingArrivals
    default:
      tableView.tableFooterView = nil
    }
  }
}

extension TableViewController: NetworkControllerDelegate {
  func predictions(_ predictions: [Prediction]) {
    state = predictions.isEmpty ? .empty : .populated(predictions)
  }
  
  func errorFetchingPredictions(error: String) {
    state = .error
  }
}
