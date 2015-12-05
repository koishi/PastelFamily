//
//  ComicViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit

class ComicViewController: UIViewController, UIWebViewDelegate
{
  @IBOutlet weak private var webView: UIWebView!

  var url: NSURL?

  override func viewDidLoad()
  {
    webView.delegate = self
    if let url = url {
      let request = NSURLRequest(URL: url)
      webView.loadRequest(request)
    }
  }

  func webViewDidFinishLoad(webView: UIWebView)
  {
    let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    self.navigationItem.title = title
  }
}
