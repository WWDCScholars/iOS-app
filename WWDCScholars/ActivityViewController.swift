//
//  ActivityViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import SafariServices
import DeckTransition

internal final class ActivityViewController: TWTRTimelineViewController {
    
    // MARK: - File Private Properties
    
    fileprivate var filter: TWTRTimelineFilter?
    
    // MARK: - Internal Properties
    
    internal var proxy: ActivityViewControllerProxy?
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.proxy = ActivityViewControllerProxy(delegate: self)
        
        self.configureUI()
        self.loadTimeline()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.title = "Activity"
        self.showTweetActions = true
        self.tweetViewDelegate = self
        
        let composeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.presentTweetComposer))
        self.navigationItem.rightBarButtonItem = composeBarButtonItem
        
        self.refreshControl?.replaceTarget(self, action: #selector(self.loadTimeline), for: .valueChanged)
    }
    
    // MARK: - File Private Functions
    
    fileprivate func configureDataSource(with activityQueryItems: [ActivityQueryItem]) {
        let query = ActivityQueryFactory.query(for: activityQueryItems)
        let client = TWTRAPIClient()
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: query, apiClient: client)
        dataSource.filterSensitiveTweets = true
        dataSource.timelineFilter = self.filter
        dataSource.topTweetsOnly = false
        self.dataSource = dataSource
        self.refresh()
    }
    
    // MARK: - Actions
    
    @objc fileprivate func loadTimeline() {
        self.proxy?.loadActivityTimelineFilters()
    }
    
    @objc fileprivate func presentTweetComposer() {
        let composer = TWTRComposer()
        composer.setText("#WWDCScholars")
        composer.show(from: self) { _ in }
    }
}

extension ActivityViewController: ActivityViewControllerProxyDelegate {
    
    // MARK: - Internal Functions
    
    internal func didLoadActivityTimelineFilters(activityTimelineFilters: [ActivityTimelineFilter]) {
        self.filter = ActivityFilterFactory.filter(for: activityTimelineFilters)
        self.proxy?.loadActivityQueryItems()
    }
    
    internal func failedToLoadActivityTimelineFilters() {
        // TODO: Update UI to display background view controller
    }
    
    internal func didLoadActivityQueryItems(activityQueryItems: [ActivityQueryItem]) {
        self.configureDataSource(with: activityQueryItems)
        self.refreshControl?.endRefreshing()
    }
    
    internal func failedToLoadActivityQueryItems() {
        // TODO: Update UI to display background view controller
    }
}

extension ActivityViewController: TWTRTweetViewDelegate {
    internal func openSafariViewController(`for` url: URL) {
        let svc = SFSafariViewController(url: url)
        svc.preferredBarTintColor = .scholarsTranslucentPurple
        if let presVC = self.presentedViewController {
            presVC.present(svc, animated: true, completion: nil)
        }else {
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    internal func tweetView(_ tweetView: TWTRTweetView, didTap url: URL) {
        openSafariViewController(for: url)
    }
    
    internal func tweetView(_ tweetView: TWTRTweetView, didTapProfileImageFor user: TWTRUser) {
        if (UIApplication.shared.canOpenURL(URL(string:"twitter://")!)) {
            UIApplication.shared.open(URL.init(string: "twitter://user?id=\(user.userID)")!, options: [:], completionHandler: nil)
        }else if (UIApplication.shared.canOpenURL(URL(string:"tweetbot://")!)) {
            UIApplication.shared.open(URL.init(string: "tweetbot://\(user.screenName)")!, options: [:], completionHandler: nil)
        }else {
            openSafariViewController(for: user.profileURL)
        }
    }
    
    internal func tweetView(_ tweetView: TWTRTweetView, shouldDisplay controller: TWTRTweetDetailViewController) -> Bool {
        controller.delegate = self
        let transitionDelegate = DeckTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        present(controller, animated: true, completion: nil)
        controller.scrollView.delegate = controller
        return false
    }
}

extension ActivityViewController: TWTRTweetDetailViewControllerDelegate {
    internal func tweetDetailViewController(_ controller: TWTRTweetDetailViewController, didTap url: URL) {
        openSafariViewController(for: url)
    }
    
    internal func tweetDetailViewController(_ controller: TWTRTweetDetailViewController, didTapProfileImageFor user: TWTRUser) {
        if (UIApplication.shared.canOpenURL(URL(string:"twitter://")!)) {
            UIApplication.shared.open(URL.init(string: "twitter://user?id=\(user.userID)")!, options: [:], completionHandler: nil)
        }else if (UIApplication.shared.canOpenURL(URL(string:"tweetbot://")!)) {
            UIApplication.shared.open(URL.init(string: "tweetbot://\(user.screenName)")!, options: [:], completionHandler: nil)
        }else {
            openSafariViewController(for: user.profileURL)
        }
    }
    
    internal func tweetDetailViewController(_ controller: TWTRTweetDetailViewController, didTapHashtag hashtag: TWTRTweetHashtagEntity) {
        if hashtag.text == "WWDCScholars" {
            self.dismiss(animated: true, completion: nil)
        }else {
            if (UIApplication.shared.canOpenURL(URL(string:"twitter://")!)) {
                UIApplication.shared.open(URL.init(string: "twitter://search?query=%23\(hashtag.text)")!, options: [:], completionHandler: nil)
            }else if (UIApplication.shared.canOpenURL(URL(string:"tweetbot://")!)) {
                UIApplication.shared.open(URL.init(string: "tweetbot://query=%23\(hashtag.text)")!, options: [:], completionHandler: nil)
            }else {
                openSafariViewController(for: URL.init(string: "https://twitter.com/search?q=%23\(hashtag.text)")!)
            }
        }
    }
    
    internal func tweetDetailViewController(_ controller: TWTRTweetDetailViewController, didTapCashtag cashtag: TWTRTweetCashtagEntity) {
        if (UIApplication.shared.canOpenURL(URL(string:"twitter://")!)) {
            UIApplication.shared.open(URL.init(string: "twitter://search?query=%24\(cashtag.text)")!, options: [:], completionHandler: nil)
        }else if (UIApplication.shared.canOpenURL(URL(string:"tweetbot://")!)) {
            UIApplication.shared.open(URL.init(string: "tweetbot://query=%24\(cashtag.text)")!, options: [:], completionHandler: nil)
        }else {
            openSafariViewController(for: URL.init(string: "https://twitter.com/search?q=%24\(cashtag.text)")!)
        }
    }
}
