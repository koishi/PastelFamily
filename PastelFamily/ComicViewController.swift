//
//  ComicViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit
import WebKit

class ComicViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate
{

  private var webView: WKWebView!
  var htmlString: String?
  var episode: EpisodeEntity?

  // MARK: - LifeCycle

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
  
  override func viewWillDisappear(animated: Bool)
  {
    webView.scrollView.delegate = nil;
  }

  private func setupSubViews()
  {
    webView.navigationDelegate = self
    webView.scrollView.delegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)
    var viewBindingsDict = [String: AnyObject]()
    viewBindingsDict["webView"] = webView
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
  }

  // MARK: - WKNavigationDelegate

  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
  {
    navigationItem.title = webView.title
  }
  
  // MARK: - UIScrollViewDelegate
  
  func scrollViewDidScroll(scrollView: UIScrollView)
  {
    if webView.scrollView.bounds.size.height == 0 || webView.scrollView.contentSize.height == 0 {
      return
    }

    let calc = (webView.scrollView.contentOffset.y + webView.scrollView.bounds.size.height) / webView.scrollView.contentSize.height
    if calc >= 1.0 {
      episode?.isRead()
    }
  }
  
}
