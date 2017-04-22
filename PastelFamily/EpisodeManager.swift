//
//  EpisodeManager.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import Ji
import RealmSwift

class EpisodeManager: NSObject {
  
  static let titleName = "パステル家族"

  fileprivate(set) var episodes: Results<EpisodeEntity>

  class var sharedInstance: EpisodeManager {
    struct Static {
      static let instance = EpisodeManager()
    }
    return Static.instance
  }
  
  required override init() {
    let realm = try! Realm()
    episodes = realm.objects(EpisodeEntity.self)
  }

  func scrapingEpisodeList(_ completion:@escaping () -> Void) {

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

//    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0).async(DispatchQueue.global) {
//    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0).async(DispatchQueue.global) {
    DispatchQueue.global(qos: .default).async {

      let realm = try! Realm()
      
      let jiDoc = Ji(htmlURL: NSURL(string: "http://www.comico.jp/detail.nhn?titleNo=32&articleNo=1")! as URL)

      if let bodyNode = jiDoc?.xPath("//body")!.first {
        let contentDivNode = bodyNode.xPath("header[@class='m-article-header']/div[@class='m-article-header__nav-article']/div[@class='m-article-header__nav-article-list']/ul").first
        
        for childNode in contentDivNode!.children {
          let url = childNode.firstChildWithName("a")?.attributes["href"]
          var title = ""
          var imageUrl = ""

          // すでに存在するURLならスキップする
          let result = realm.objects(EpisodeEntity.self).filter("url = '\(url!)'")
          if result.count != 0 {
            continue
          }

          for childNode in (childNode.firstChildWithName("a")?.childrenWithName("p"))! {
            if let plainTitle = childNode.firstChildWithName("img")?.attributes["alt"] {
                title = plainTitle.replacingOccurrences(of: EpisodeManager.titleName, with: "")
            }
            if let imgSrc = childNode.firstChildWithName("img")?.attributes["src"] {
              imageUrl = imgSrc
            }
            break
          }

          let episode = EpisodeEntity(title: title, url: url!, imageUrl: imageUrl)
          episode.komaUrl = self.scrapingKomaFromEpisode(episode.url!)

          try! realm.write {
            realm.add(episode)
          }

          DispatchQueue.main.async {
            completion()
          }
        }
      }
      DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        completion()
      }
    }
  }

  fileprivate func scrapingKomaFromEpisode(_ url: String) -> List<Koma> {
    let jiDoc = Ji(htmlURL: NSURL(string: url)! as URL)
    let bodyNode = jiDoc?.xPath("//body")!.first!
    let contentDivNode = bodyNode!.xPath("div[@class='m-comico-body o-section-bg-01 o-pb50']/div[@class='m-comico-body__inner']/div[@class='m-section-detail o-mt-1']/section[@class='m-section-detail__body']").first

    let komaURL = List<Koma>()
    for childNode in contentDivNode!.children {
      komaURL.append(Koma.init(url: childNode.attributes["src"]!))
    }
    return komaURL
  }
  
  func count() -> Int {
    return episodes.count
  }

  func htmlString(_ index: Int) -> String {
    let episode = episodes[index]
    var html = "<html lang=\"ja\"><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>\(episode.title!)</title>"
    for komaUrl in episode.komaUrl {
      html += "<img src=\"\(komaUrl.url!)\">"
    }
    html += "</body></html>"
    return html
  }

  func nextEpisodeHtml(_ index: Int) -> String? {
    if availableEpisode(index + 1) {
      return htmlString(index + 1)
    }
    return nil
  }

  func availableEpisode(_ index: Int) -> Bool {
    return count() >= index + 1
  }
  
}
