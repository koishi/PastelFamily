//
//  EpisodeManager.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import Ji
import RealmSwift

class GogoItemManager: NSObject {
  
  static let titleName = "午後の映画アプリ"

  fileprivate(set) var episodes: Results<EpisodeEntity>

  class var sharedInstance: GogoItemManager {
    struct Static {
      static let instance = GogoItemManager()
    }
    return Static.instance
  }
  
  required override init() {
    let realm = try! Realm()
    episodes = realm.objects(EpisodeEntity)
  }

  func scrapingGogoitemList(_ completion:@escaping () -> Void) {

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {

      let realm = try! Realm()
      
      let jiDoc = Ji(htmlURL: URL(string: "http://www.tv-tokyo.co.jp/telecine/oa_afr_load/")!)

        guard let bodyNode = jiDoc?.xPath("//body/main")!.first else {
            return
        }
        
        let contentDivNode = bodyNode.xPath("div[@class='wrapper']/div[@class='clearfix']/div[@id='content_left']/div[@id='contents']").first

        /// エンティティを抽出
        for childNode in contentDivNode!.children {
            
            guard childNode.attributes["class"] == "gogo_lineup_block mt50", let month = childNode.xPath("div[@class='all_lineup clearfix mt10']").first else {
                continue
            }

            for gogoitem in month.children {

                guard gogoitem.attributes["class"] == "gogo_item" else {
                    continue
                }

                let gogoItemEntity = GogoItemEntity()
                
                /// 放映日時
                if let time = gogoitem.attributes["data-oastart"] {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMddHHmmssSS"
                    if let date = formatter.date(from: time) {
                        formatter.dateFormat = "M/d HH:mm〜"
//                        let dateString = formatter.stringFromDate(date)
//                        print(dateString)
                    }
                    gogoItemEntity.date = time
                }

                /// 地上波初
                if let g_red = gogoitem.xPath("span[@class='g_red']").first?.value {
                    gogoItemEntity.isFirstTerrestria = RealmOptional<Bool>(false)
                    print(g_red)
                }

                if let g_data_block = gogoitem.xPath("div[@class='g_data_block']").first {

                    /// テーマ
                    if let g_sp_thema = g_data_block.xPath("span[@class='g_sp_thema']").first {
                        gogoItemEntity.specialTheme = g_sp_thema.value
                        //                    print(g_sp_thema?.value)
                    }

                    if let titles = g_data_block.xPath("h3").first {
                        
                        /// 邦題
                        if let jp = titles.xPath("span[@class='jp']").first {
                            gogoItemEntity.japaneseTitle = jp.value
//                            print(jp.value)
                        }
                        
                        /// 原題
                        if let en = titles.xPath("span[@class='en roboto']").first {
                            gogoItemEntity.englishTitle = en.value
//                            print(en?.value)
                        }

                    }

                    if let otherDataGhide = g_data_block.xPath("div[@class='other_data g_hide']").first {

                        /// 制作年・国
                        if let g_country_year = otherDataGhide.xPath("span[@class='g_country_year']").first {
                            gogoItemEntity.country = g_country_year.value
                            gogoItemEntity.year = g_country_year.value
//                            print(g_country_year?.value)
                        }

                        
                        /// 監督・出演
                        if let otherData = otherDataGhide.xPath("div[@class='g_other_data']").first {

                            let gt_array = otherData.xPath("div[@class='g_t']")
                            for gt in gt_array {
                                let gt_childs = gt.xPath("span[@class='g_c']")
                                if gt_childs.count  >= 2 {
                                    
                                    var category = GogoItemDetailEntity()
                                    category.title = gt_childs[0].xPath("span[@class='data_title']").first?.value
                                    var person = GogoItemDetailEntity()
                                    person.title = gt_childs[1].value
                                    gogoItemEntity.detailEntities.append(category)
                                    gogoItemEntity.detailEntities.append(person)
//                                    print(gt_childs[0].xPath("span[@class='data_title']").first?.value)
//                                    print(gt_childs[1].value)
                                }
                            }
                        }
                    }
                }
            }
        }
      }
      DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        completion()
      }
  }

  fileprivate func scrapingKomaFromEpisode(_ url: String) -> List<Koma> {
    let jiDoc = Ji(htmlURL: URL(string: url)!)
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
