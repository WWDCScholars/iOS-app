//
//  UIApplication+CanOpenTwitter.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 08.09.19.
//  Copyright © 2019 WWDCScholars. All rights reserved.
//

import UIKit

fileprivate let tweetbotURL = URL(string: "tweetbot://")!
fileprivate let twitterURL = URL(string: "twitter://")!

extension UIApplication {

    class var canOpenTweetbot: Bool {
        return shared.canOpenURL(tweetbotURL)
    }

    class var canOpenTwitter: Bool {
        return shared.canOpenURL(twitterURL)
    }

}
