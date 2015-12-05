//
//  EpisodeEntity.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import Foundation

struct EpisodeEntity
{
  var title: String
  var url: String
  var komaUrl = [String]()

  init(title: String, url: String)
  {
    self.title = title
    self.url = url
    self.komaUrl = []
  }
}
