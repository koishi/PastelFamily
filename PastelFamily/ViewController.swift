//
//  ViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/11/29.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource
{

  @IBOutlet weak var tableView: UITableView!

  var comas = ["http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_001.jpg"]
  
  let cellIdentifier = "CustomTableViewCell"
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    tableView.dataSource = self

    let nib = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }

  // MARK: - UITableViewDataSource

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! CustomTableViewCell
    cell.komaImage.sd_setImageWithURL(NSURL(string: comas[indexPath.row]))
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return comas.count
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
}
