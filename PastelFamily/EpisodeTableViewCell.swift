//
//  EpisodeTableViewCell.swift
//  PastelFamily
//
//  Created by bs on 2015/12/06.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

  @IBOutlet weak var episodeImage: UIImageView!
  @IBOutlet weak var episodeTitle: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
