//
//  ViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/11/29.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

  @IBOutlet weak var tableView: UITableView!

  let comas = [
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_001.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_002.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_003.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_004.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_005.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_006.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_007.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_008.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_009.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_010.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_011.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_012.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_013.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_014.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_015.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_016.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_017.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_018.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_019.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_001_020.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_002_021.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_002_022.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_002_023.jpg",
    "http://comicimg.comico.jp/pc/32/139/7743feb03818b25b9e37aaea2ac5d27e_002_024.jpg"
  ]

  let cellIdentifier = "CustomTableViewCell"
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self

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
    SDWebImageManager.sharedManager().delegate = cell
    
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

  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
  {
    return 1000
  }

}
