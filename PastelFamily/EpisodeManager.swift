//
//  EpisodeManager.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit
import Ji

class EpisodeManager: NSObject
{
  
  static let titleName = "パステル家族"

  private(set) var episodes = [EpisodeEntity]()

  class var sharedInstance: EpisodeManager
  {
    struct Static {
      static let instance: EpisodeManager = EpisodeManager()
    }
    return Static.instance
  }

  func scrapingEpisodeList(completion:() -> Void)
  {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

      let jiDoc = Ji(htmlURL: NSURL(string: "http://www.comico.jp/detail.nhn?titleNo=32&articleNo=1")!)
      let bodyNode = jiDoc?.xPath("//body")!.first!
      let contentDivNode = bodyNode!.xPath("header[@class='m-article-header']/div[@class='m-article-header__nav-article']/div[@class='m-article-header__nav-article-list']/ul").first

      for childNode in contentDivNode!.children {
        let url = childNode.firstChildWithName("a")?.attributes["href"]
        var title: String = ""
        
        for childNode in (childNode.firstChildWithName("a")?.childrenWithName("p"))! {
          
          if let plainTitle = childNode.firstChildWithName("img")?.attributes["alt"] {
            title = plainTitle.stringByReplacingOccurrencesOfString(EpisodeManager.titleName, withString: "")
          }
          
          break
        }
        
        var episode = EpisodeEntity(title: title, url: url!)
        episode.komaUrl = self.scrapingEpisodeKoma(episode.url)
        self.episodes.append(episode)

        dispatch_async(dispatch_get_main_queue()) {
          completion()
        }
      }
    }
    completion()
  }

  private func scrapingEpisodeKoma(url: String) -> [String]
  {
    let jiDoc = Ji(htmlURL: NSURL(string: url)!)
    let bodyNode = jiDoc?.xPath("//body")!.first!
    let contentDivNode = bodyNode!.xPath("div[@class='m-comico-body o-section-bg-01 o-pb50']/div[@class='m-comico-body__inner']/div[@class='m-section-detail o-mt-1']/section[@class='m-section-detail__body']").first

    var komaURL = [String]()
    for childNode in contentDivNode!.children {
      komaURL.append(childNode.attributes["src"]!)
    }
    return komaURL
  }
  
  func count() -> Int
  {
    return episodes.count
  }
}
