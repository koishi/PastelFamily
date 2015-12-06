//
//  ComicViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit
import WebKit

class ComicViewController: UIViewController, WKNavigationDelegate
{

  private var webView: WKWebView!
  var htmlString: String?

  required init?(coder aDecoder: NSCoder)
  {
    super.init(nibName: nil, bundle: nil)
    webView = WKWebView()
  }

  override func viewDidLoad()
  {
    super.viewDidLoad()
    setupSubViews()

    if let htmlString = htmlString {
      webView.loadHTMLString(htmlString, baseURL: nil)
    }
  }

  private func setupSubViews()
  {
    webView.navigationDelegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(webView)
    var viewBindingsDict = [String: AnyObject]()
    viewBindingsDict["webView"] = webView
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
  }
  
  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
  {
    navigationItem.title = webView.title
  }

}
