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

  private let episodeCellIdentifier = "EpisodeTableViewCell"

  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.navigationItem.title = EpisodeManager.titleName

    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: episodeCellIdentifier, bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: episodeCellIdentifier)

    EpisodeManager.sharedInstance.scrapingEpisodeList({
      self.tableView.reloadData()
    })
  }

  // MARK: - UITableViewDataSource
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(episodeCellIdentifier) as! EpisodeTableViewCell
    let episode = EpisodeManager.sharedInstance.episodes[indexPath.row]
    cell.episodeTitle.text = episode.title
    cell.episodeImage.sd_setImageWithURL(NSURL(string: episode.imageUrl!))
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
      vc.htmlString = EpisodeManager.sharedInstance.htmlString(indexPath.row)
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}
