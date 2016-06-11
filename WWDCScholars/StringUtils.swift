//
//  StringUtils.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation

typealias URL = String

extension String {
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func isValidGitHubLink() -> Bool {
        let matches = matchesForRegexInText("https?://(www\\.)?github.com\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]{2,})", text: self)
        
        return matches.count > 0
    }
    
    func isValidFacebookLink() -> Bool {
        let matches = matchesForRegexInText("https?://(www\\.)?facebook.com/.(?:(?:\\w)*#!/)?(?:pages/)?(?:[\\w\\-]*/)*([\\w\\-\\.]*)", text: self)
        
        return matches.count > 0
    }
    
    func isValidTwitterLink() -> Bool {
        let matches = matchesForRegexInText("https?://(www\\.)?twitter.com/\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]{2,})", text: self)
        
        return matches.count > 0
    }
    
    func isValidiTunesLink() -> Bool {
        let matches = matchesForRegexInText("https?://itunes.apple.com/\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]{2,})", text: self)
        
        return matches.count > 0
    }
    
//    func isValidLinkedInLink() -> Bool {
//        let matches = matchesForRegexInText("https?://(www\\.)?linkedin.com/\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]{2,})", text: self)
//        
//        return matches.count > 0
//    }
    
    func isValidyoutubeLink() -> Bool {
        let matches = matchesForRegexInText("https?://(www\\.)?youtube.com/\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]{2,})", text: self)
        
        let secondMatches = matchesForRegexInText("https?://(www\\.)?youtu.be/\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]{2,})", text: self)

        return matches.count > 0 || secondMatches.count > 0
    }

    
}