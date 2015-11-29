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

  override func viewDidLoad()
  {
    super.viewDidLoad()

    
    tableView.dataSource = self
    
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

// MARK: - UITableViewDataSource
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 1
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
}
