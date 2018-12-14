//
//  Created by August Shultz on 12/14/18.
//  Copyright © 2018 August Shultz. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
  
  var prediction: Prediction? {
    didSet {
      textLabel?.text = prediction?.name
      detailTextLabel?.text = format(secondsForDisplay: prediction?.seconds)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
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
      format = "\(format)\(secondsRemaining) m"
    }
    return format
  }
}
