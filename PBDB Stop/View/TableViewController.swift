//
//  Created by August Shultz on 12/13/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  let networkController = NetworkController()
  let stopUrl = URL(string: "https://api.bongo.org/predictions/0264")
  
  @IBOutlet weak var loadingView: UIView?
  @IBOutlet weak var noUpcomingArrivals: UIView?
  @IBOutlet weak var errorView: UIView?
  @IBOutlet weak var errorLabel: UILabel?
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
  
  var state: State<Prediction> = .loading {
    didSet {
      DispatchQueue.main.async { [unowned self] in
        self.setFooterView()
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = loadingView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadPredictions()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return state.rowObjects.count
  }
  
  @IBAction func refresh(_ sender: UIBarButtonItem) {
    state = .loading
    loadPredictions()
  }
  
  func loadPredictions() {
    guard let stopUrl = stopUrl else {
      state = .error("The Stop url could not be created.")
      return
    }
    networkController.loadPredictions(fromUrl: stopUrl) { [unowned self] (result) in
      switch result {
      case .success(let predictions):
        self.state = .populated(predictions)
      case .failure(let error):
        self.state = .error(error.localizedDescription)
      }
    }
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
    case .populated(let predictions) where predictions.isEmpty:
      tableView.tableFooterView = noUpcomingArrivals
    case .error(let errorMessage):
      errorLabel?.text = errorMessage
      tableView.tableFooterView = errorView
    default:
      tableView.tableFooterView = nil
    }
  }
}
