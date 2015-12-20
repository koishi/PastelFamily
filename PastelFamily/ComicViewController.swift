//
//  ComicViewController.swift
//  PastelFamily
//
//  Created by bs on 2015/12/05.
//  Copyright © 2015年 bs. All rights reserved.
//

import UIKit
import WebKit

class ComicViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

  private var webView: WKWebView!
  var htmlString: String?
  var episode: EpisodeEntity?
  var episodeIndex: Int?

  @IBOutlet weak var subView: UIView!
  @IBOutlet weak var nextEpisodeButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    webView = WKWebView()
    setupSubViews()

    if let htmlString = htmlString {
      webView.loadHTMLString(htmlString, baseURL: nil)
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    webView.scrollView.delegate = nil;
  }

  private func setupSubViews() {
    webView.navigationDelegate = self
    webView.scrollView.delegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)
    view.sendSubviewToBack(webView)
    var viewBindingsDict = [String: AnyObject]()
    viewBindingsDict["webView"] = webView
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))

    subView.hidden = true
  }

  // MARK: - WKNavigationDelegate

  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    navigationItem.title = webView.title
  }

  // MARK: - UIScrollViewDelegate

  func scrollViewDidScroll(scrollView: UIScrollView) {
    if webView.scrollView.bounds.size.height == 0 || webView.scrollView.contentSize.height == 0 {
      subView.hidden = true
      return
    }

    let calc = (webView.scrollView.contentOffset.y + webView.scrollView.bounds.size.height) / webView.scrollView.contentSize.height
    if calc >= 1.0 {
      episode?.isRead()
      subView.hidden = false

      if EpisodeManager.sharedInstance.availableEpisode(episodeIndex! + 1) {
        nextEpisodeButton.hidden = false
      } else {
        nextEpisodeButton.hidden = true
      }

      return
    }

    subView.hidden = true
    return
  }

  // MARK: IBAction
  
  @IBAction func tappedNextEpisodeButton(sender: AnyObject) {
    if let html = EpisodeManager.sharedInstance.nextEpisodeHtml(episodeIndex!) {
      htmlString = html
      episodeIndex! += 1
      episode = EpisodeManager.sharedInstance.episodes[episodeIndex!]
      webView.loadHTMLString(htmlString!, baseURL: nil)
    }
  }

  @IBAction func tappedFavoriteButton(sender: AnyObject) {
    episode?.isFavorite()
  }

}
