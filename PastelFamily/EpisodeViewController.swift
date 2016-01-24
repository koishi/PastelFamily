//
//  EpisodeViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {
  @IBOutlet weak private var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = EpisodeManager.titleName

    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: EpisodeTableViewCell.cellIdentifier, bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: EpisodeTableViewCell.cellIdentifier)

    EpisodeManager.sharedInstance.scrapingEpisodeList({
      self.tableView.reloadData()
    })
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

}

// MARK: - UITableDelegate

extension EpisodeViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier(ComicViewController.identifier) as! ComicViewController
    vc.htmlString = EpisodeManager.sharedInstance.htmlString(indexPath.row)
    vc.episode = EpisodeManager.sharedInstance.episodes[indexPath.row]
    vc.episodeIndex = indexPath.row
    self.navigationController?.pushViewController(vc, animated: true)
  }

}

// MARK: - UITableViewDataSource

extension EpisodeViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(EpisodeTableViewCell.cellIdentifier) as! EpisodeTableViewCell
    let episode = EpisodeManager.sharedInstance.episodes[indexPath.row]
    cell.episode = episode
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return EpisodeManager.sharedInstance.count()
  }

}