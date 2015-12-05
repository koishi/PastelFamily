//
//  EpisodeViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  @IBOutlet weak private var tableView: UITableView!

  private let cellIdentifier = "Cell"

  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.navigationItem.title = EpisodeManager.titleName

    tableView.delegate = self
    tableView.dataSource = self
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

    EpisodeManager.sharedInstance.scrapingEpisodeList({
      self.tableView.reloadData()
    })
  }

  // MARK: - UITableViewDataSource
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
    let episode = EpisodeManager.sharedInstance.episodes[indexPath.row]
    cell.textLabel?.text = episode.title
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return EpisodeManager.sharedInstance.count()
  }

  // MARK: - UITableDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ComicViewController") as? ComicViewController {
      let episode = EpisodeManager.sharedInstance.episodes[indexPath.row]
      vc.url = htmlWithKoma(episode)
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

  // MARK: - Private

  private func htmlWithKoma(episode: EpisodeEntity) -> NSURL
  {
    var html = "<html lang=\"ja\"><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>\(episode.title)</title>"
    for komaUrl in episode.komaUrl {
      html += "<img src=\"\(komaUrl)\">"
    }
    html += "</body></html>"

    let data = html.dataUsingEncoding(NSUTF8StringEncoding)
    let documentsPath: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let filePath = documentsPath.stringByAppendingPathComponent("test.html")
    data!.writeToFile(filePath, atomically: true)
    return NSURL(fileURLWithPath: filePath)
  }
  
}
