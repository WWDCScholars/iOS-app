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

internal final class ActivityViewController: TWTRTimelineViewController {
    
    private var client: TWTRAPIClient! = nil
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client = TWTRAPIClient()
        
        self.styleUI()
        self.configureUI()
        self.configureTwitterDataSource()
        self.configureTwitterDelegate()
        print (self.refreshControl)
        self.refreshControl?.removeTarget(nil, action: nil, for: .allEvents)
        self.refreshControl?.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
    }
    
    // MARK: - UI
    
    private func styleUI() {
        let composeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.openTweetComposer))
        self.navigationItem.rightBarButtonItem = composeBarButtonItem
    }
    
    private func configureUI() {
        self.title = "Activity"
        self.showTweetActions = true
    }
    
    // MARK: - Private functions
    
    private func configureTwitterDataSource() {
        loadFilterAndQuery()
    }
    
    private func loadFilterAndQuery(completion: ((Error?) -> Void)? = nil) {
        CloudKitManager.shared.loadActivityTimelineFilters() { filter, error in
            guard let filter = filter, error == nil else {
                print ("Error loading activity filters \(error.debugDescription)")
                completion?(error)
                return
            }
            
            CloudKitManager.shared.loadActivityQueryItems() { query, error in
                guard let query = query, error == nil else {
                    print ("Error loading activity query \(error.debugDescription)")
                    completion?(error)
                    return
                }
                //            let query = "#WWDCScholars OR from:@tim_cook OR from:@cue OR from:@jgeleynse OR from:@pschiller OR from:@AngelaAhrendts OR from:@EEhare"
                DispatchQueue.main.async {
                    if let dataSource = self.dataSource as? TWTRSearchTimelineDataSource,
                        dataSource.searchQuery == query {
                        dataSource.filterSensitiveTweets = true
                        dataSource.timelineFilter = filter
                    }else {
                        let dataSource = TWTRSearchTimelineDataSource(searchQuery: query, apiClient: self.client)
                        self.dataSource = dataSource
                        dataSource.filterSensitiveTweets = true
                        dataSource.timelineFilter = filter
                        
                    }
                    completion?(nil)
                }
            }
        }
    }
    
    private func configureTwitterDelegate() {
        self.tweetViewDelegate = self
    }
    
    // MARK: - Actions
    
    internal func refreshTableView() {
        loadFilterAndQuery(completion: { error in
            guard error == nil else {
                print ("Error loading activity filters and query \(error.debugDescription)")
                if self.refreshControl?.isRefreshing == true {
                   self.refreshControl?.endRefreshing()
                }
                return
            }
            
            self.refresh()
        })
    }
    
    internal func openTweetComposer() {
        let composer = TWTRComposer()
        composer.setText("#WWDCScholars")
        composer.show(from: self) { _ in }
    }
}

extension ActivityViewController: TWTRTweetViewDelegate {
    internal func openSafariViewController(`for` url: URL) {
        let svc = SFSafariViewController(url: url)
        svc.preferredBarTintColor = .scholarsTranslucentPurple
        self.presentedViewController?.present(svc, animated: true, completion: nil)
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
        return true
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
