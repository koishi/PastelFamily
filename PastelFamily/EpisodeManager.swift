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

  private(set) var episodes: Results<EpisodeEntity>

  class var sharedInstance: EpisodeManager {
    struct Static {
      static let instance = EpisodeManager()
    }
    return Static.instance
  }
  
  required override init() {
    let realm = try! Realm()
    episodes = realm.objects(EpisodeEntity)
  }

  func scrapingEpisodeList(completion:() -> Void) {

    UIApplication.sharedApplication().networkActivityIndicatorVisible = true

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

      let realm = try! Realm()
      
      let jiDoc = Ji(htmlURL: NSURL(string: "http://www.tv-tokyo.co.jp/telecine/oa_afr_load/")!)

      if let bodyNode = jiDoc?.xPath("//body")!.first {
        let contentDivNode = bodyNode.xPath("div[@id='wrap']/div[@id='contents']/div[@id='con_l']/table/tr/td/div[@class='style3']").first
        
        for childNode in contentDivNode!.children {

            guard childNode.tag == "table" else {
                continue
            }

            for tr in childNode.children {
                
                for td in tr.children {

                    guard td.childrenWithName("p").count > 0 else {
                        continue
                    }
                    for p in td.childrenWithName("p") {
                        print(p)
                    }
                }
            }

//          let url = childNode.firstChildWithName("a")?.attributes["href"]
//          var title = ""
//          var imageUrl = ""
//
//          // すでに存在するURLならスキップする
//          let result = realm.objects(EpisodeEntity).filter("url = '\(url!)'")
//          if result.count != 0 {
//            continue
//          }
//
//          for childNode in (childNode.firstChildWithName("a")?.childrenWithName("p"))! {
//            if let plainTitle = childNode.firstChildWithName("img")?.attributes["alt"] {
//              title = plainTitle.stringByReplacingOccurrencesOfString(EpisodeManager.titleName, withString: "")
//            }
//            if let imgSrc = childNode.firstChildWithName("img")?.attributes["src"] {
//              imageUrl = imgSrc
//            }
//            break
//          }
//
//          let episode = EpisodeEntity(title: title, url: url!, imageUrl: imageUrl)
//          episode.komaUrl = self.scrapingKomaFromEpisode(episode.url!)
//
//          try! realm.write {
//            realm.add(episode)
//          }
//
//          dispatch_async(dispatch_get_main_queue()) {
//            completion()
//          }
        }
      }
      dispatch_async(dispatch_get_main_queue()) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        completion()
      }
    }
  }

  private func scrapingKomaFromEpisode(url: String) -> List<Koma> {
    let jiDoc = Ji(htmlURL: NSURL(string: url)!)
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

  func htmlString(index: Int) -> String {
    let episode = episodes[index]
    var html = "<html lang=\"ja\"><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>\(episode.title!)</title>"
    for komaUrl in episode.komaUrl {
      html += "<img src=\"\(komaUrl.url!)\">"
    }
    html += "</body></html>"
    return html
  }

  func nextEpisodeHtml(index: Int) -> String? {
    if availableEpisode(index + 1) {
      return htmlString(index + 1)
    }
    return nil
  }

  func availableEpisode(index: Int) -> Bool {
    return count() >= index + 1
  }
  
}
