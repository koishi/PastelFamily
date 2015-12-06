//
//  EpisodeEntity.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import Foundation
import SDWebImage
import RealmSwift

class EpisodeEntity: Object
{
  dynamic var title: String?
  dynamic var url: String?
  dynamic var imageUrl: String?
  var komaUrl = List<Koma>()
  var isNew: Bool?
  var isRead: Bool?

  convenience init(title: String, url: String, imageUrl: String)
  {
    self.init()
    self.title = title
    self.url = url
    self.imageUrl = imageUrl
    self.komaUrl = List<Koma>()
    self.isNew = false
    self.isRead = false
  }
}

class Koma: Object
{
  dynamic var url: String?

  convenience init(url: String)
  {
    self.init()
    self.url = url
  }
}