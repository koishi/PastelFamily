//
//  EpisodeViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit

class EpisodeListViewController: UIViewController {
  @IBOutlet weak private var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = GogoItemManager.titleName

    tableView.delegate = self
    tableView.dataSource = self
    tableView.registerNib(UINib(nibName: EpisodeListTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: EpisodeListTableViewCell.cellIdentifier)

    GogoItemManager.sharedInstance.scrapingEpisodeList({
      self.tableView.reloadData()
    })
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

}

// MARK: - UITableDelegate

extension EpisodeListViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier(EpisodeDetailViewController.identifier) as! EpisodeDetailViewController
    vc.htmlString = GogoItemManager.sharedInstance.htmlString(indexPath.row)
    vc.episode = GogoItemManager.sharedInstance.episodes[indexPath.row]
    vc.episodeIndex = indexPath.row
    self.navigationController?.pushViewController(vc, animated: true)
  }

}

// MARK: - UITableViewDataSource

extension EpisodeListViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(EpisodeListTableViewCell.cellIdentifier) as! EpisodeListTableViewCell
    let episode = GogoItemManager.sharedInstance.episodes[indexPath.row]
    cell.episode = episode
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return GogoItemManager.sharedInstance.count()
  }

}