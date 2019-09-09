//
//  ActivityViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import SafariServices
import DeckTransition

final class ActivityViewController: TWTRTimelineViewController {

    // MARK: - Private Properties

    var proxy: ActivityViewControllerProxy?
    private var filter: TWTRTimelineFilter?
    private var twitterInteractionController: TwitterInteractionController?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        twitterInteractionController = TwitterInteractionController(presenter: self)

        self.proxy = ActivityViewControllerProxy(delegate: self)

        self.configureUI()
        self.loadTimeline()
    }

    // MARK: - UI

    private func configureUI() {
        title = "Activity"
        showTweetActions = false
        tweetViewDelegate = self

        let appearance = TWTRTweetView.appearance()
        appearance.linkTextColor = .adjustingScholarsPurple
        if #available(iOS 13.0, *) {
            appearance.backgroundColor = .systemBackground
            appearance.primaryTextColor = .label
        }

//        let composeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.composeTweetButtonTapped))
//        navigationItem.rightBarButtonItem = composeBarButtonItem

        refreshControl?.replaceTarget(self, action: #selector(self.loadTimeline), for: .valueChanged)
    }

    // MARK: - Private Functions

    private func configureDataSource(with activityQueryItems: [ActivityQueryItem]) {
        let query = ActivityQueryFactory.query(for: activityQueryItems)
        let client = TWTRAPIClient()
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: query, apiClient: client)
        dataSource.filterSensitiveTweets = true
        dataSource.timelineFilter = self.filter
        dataSource.resultType = "recent"

        self.dataSource = dataSource
        refresh()
    }

    // MARK: - Actions

    @objc
    private func loadTimeline() {
        self.proxy?.loadActivityTimelineFilters()
    }

    @objc
    private func composeTweetButtonTapped() {
        let composer = TWTRComposer()
        composer.setText("#WWDCScholars")
        composer.show(from: self) { _ in }
    }
}

extension ActivityViewController: ActivityViewControllerProxyDelegate {

    // MARK: - Internal Functions

    func didLoadActivityTimelineFilters(activityTimelineFilters: [ActivityTimelineFilter]) {
        self.filter = ActivityFilterFactory.filter(for: activityTimelineFilters)
        self.proxy?.loadActivityQueryItems()
    }

    func failedToLoadActivityTimelineFilters() {
        // TODO: Update UI to display background view controller
    }

    func didLoadActivityQueryItems(activityQueryItems: [ActivityQueryItem]) {
        DispatchQueue.main.async {
            self.configureDataSource(with: activityQueryItems)
            self.refreshControl?.endRefreshing()
        }
    }

    func failedToLoadActivityQueryItems() {
        // TODO: Update UI to display background view controller
    }
}

extension ActivityViewController: TWTRTweetViewDelegate {
    func tweetView(_ tweetView: TWTRTweetView, didTap tweet: TWTRTweet) {
        twitterInteractionController?.handleEntityTap(.tweet(screenName: tweet.author.screenName, tweetID: tweet.tweetID))
    }

    func tweetView(_ tweetView: TWTRTweetView, didTapProfileImageFor user: TWTRUser) {
        twitterInteractionController?.handleEntityTap(.profile(screenName: user.screenName))
    }

    func tweetView(_ tweetView: TWTRTweetView, didTap url: URL) {
        twitterInteractionController?.openSafari(withURL: url)
    }

    func tweetView(_ tweetView: TWTRTweetView, didTapHashtag hashtag: String) {
        twitterInteractionController?.handleEntityTap(.tag(screenName: tweetView.tweet.author.screenName, query: "#\(hashtag)"))
    }

    func tweetView(_ tweetView: TWTRTweetView, didTapCashtag cashtag: String) {
        twitterInteractionController?.handleEntityTap(.tag(screenName: tweetView.tweet.author.screenName, query: "$\(cashtag)"))
    }

    func tweetView(_ tweetView: TWTRTweetView, didTapUserMention userID: String, screenName: String, name: String) {
        twitterInteractionController?.handleEntityTap(.profile(screenName: screenName))
    }
}
