//
//  TwitterInteractionController.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 08.09.19.
//  Copyright © 2019 WWDCScholars. All rights reserved.
//

import SafariServices
import UIKit

// Profile
//   - Tweetbot -> tweetbot://<screenName>/user_profile/<profile_screenName>
//   - Twitter  -> twitter://user?screen_name=<profile_screenName>
//   - Website  -> https://twitter.com/<screenName>
// Tweet
//   - Tweetbot -> tweetbot://<screenName>/status/<tweetID>
//   - Twitter  -> twitter://status?id=<tweetID>
//   - Website  -> https://twitter.com/<screenName>/status/<tweetID>
// Hashtag / Cashtag
//   - Tweetbot -> tweetbot://<screenName>/search?query=<query>
//   - Twitter  -> twitter://search?query=<query>
//   - Website  -> https://twitter.com/search?q=<query>

enum TwitterEntity {
    case profile(screenName: String)
    case tweet(screenName: String, tweetID: String)
    case tag(screenName: String, query: String)

    func url(for client: TwitterClient) -> URL {
        switch self {
        default:
            fatalError()
        }
    }
}

protocol TwitterClient: class {
    static var baseURLComponents: URLComponents { get }
    static func url(for entity: TwitterEntity) -> URL
}

final class TweetbotApp: TwitterClient {
    class var baseURLComponents: URLComponents {
        return URLComponents(string: "tweetbot://")!
    }

    class func url(for entity: TwitterEntity) -> URL {
        var components = baseURLComponents
        switch entity {
        case .profile(let screenName):
            components.path = "/\(screenName)/user_profile/\(screenName)"
        case .tweet(let screenName, let tweetID):
            components.path = "/\(screenName)/status/\(tweetID)"
        case .tag(let screenName, let query):
            components.path = "/\(screenName)/search"
            components.queryItems = [URLQueryItem(name: "query", value: query)]
        }
        return components.url!
    }
}

final class TwitterApp: TwitterClient {
    class var baseURLComponents: URLComponents {
        return URLComponents(string: "twitter://")!
    }

    class func url(for entity: TwitterEntity) -> URL {
        var components = baseURLComponents
        switch entity {
        case .profile(let screenName):
            components.path = "/user"
            components.queryItems = [URLQueryItem(name: "screen_name", value: screenName)]
        case .tweet(_, let tweetID):
            components.path = "/status"
            components.queryItems = [URLQueryItem(name: "id", value: tweetID)]
        case .tag(_, let query):
            components.path = "/search"
            components.queryItems = [URLQueryItem(name: "query", value: query)]
        }
        return components.url!
    }
}

final class TwitterWebsite: TwitterClient {
    class var baseURLComponents: URLComponents {
        return URLComponents(string: "https://twitter.com")!
    }

    class func url(for entity: TwitterEntity) -> URL {
        var components = baseURLComponents
        switch entity {
        case .profile(let screenName):
            components.path = "/\(screenName)"
        case .tweet(let screenName, let tweetID):
            components.path = "/\(screenName)/status/\(tweetID)"
        case .tag(_, let query):
            components.path = "/search"
            components.queryItems = [URLQueryItem(name: "q", value: query)]
        }
        return components.url!
    }
}


final class TwitterInteractionController {

    private let presenter: UIViewController

    init(presenter: UIViewController) {
        self.presenter = presenter
    }

    func handleEntityTap(_ entity: TwitterEntity) {
        if openInApp(entity: entity) {
            return
        }

        openInSafari(entity: entity)
    }

    func openSafari(withURL url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredBarTintColor = .scholarsTranslucentPurple
        safariViewController.preferredControlTintColor = .white
        if #available(iOS 13.0, *) {
            safariViewController.modalPresentationStyle = .automatic
        }

        presenter.present(safariViewController, animated: true, completion: nil)
    }

    private func openInApp(entity: TwitterEntity) -> Bool {
        var url: URL

        if UIApplication.canOpenTweetbot {
            url = TweetbotApp.url(for: entity)
        } else if UIApplication.canOpenTwitter {
            url = TwitterApp.url(for: entity)
        } else {
            return false
        }

        UIApplication.shared.open(url)
        return true
    }

    private func openInSafari(entity: TwitterEntity) {
        let url = TwitterWebsite.url(for: entity)
        openSafari(withURL: url)
    }

}
