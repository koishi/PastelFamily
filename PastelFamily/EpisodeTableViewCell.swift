//
//  EpisodeTableViewCell.swift
//  PastelFamily
//
//  Created by bs on 2015/12/06.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

  @IBOutlet weak private var episodeImage: UIImageView!
  @IBOutlet weak private var episodeTitle: UILabel!
  @IBOutlet weak private var favoriteLabel: UILabel!

  var episode: EpisodeEntity? {

    didSet {

      guard let episode = episode else {
        return
      }

      episodeTitle.text = episode.title
      
      if let isReadFlag = episode.isReadFlag.value {
        if isReadFlag {
          episodeTitle.textColor = UIColor.grayColor()
        } else {
          episodeTitle.textColor = UIColor.blackColor()
        }
      }

      if let isFavoriteFlag = episode.isFavoriteFlag.value {
        favoriteLabel.hidden = !isFavoriteFlag
      }
      episodeImage.sd_setImageWithURL(NSURL(string: episode.imageUrl!))

    }
  }

  static let cellIdentifier = "EpisodeTableViewCell"

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
