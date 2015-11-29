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

  var texts = ["hello", "world", "hello", "Swift"]
  
  override func viewDidLoad()
  {
    super.viewDidLoad()

    
    tableView.dataSource = self
    
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }

  // MARK: - UITableViewDataSource
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    cell.textLabel?.text = texts[indexPath.row]
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return texts.count
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
}
