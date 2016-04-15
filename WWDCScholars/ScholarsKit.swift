//
//  ScholarsKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation

class ScholarsKit {

    /// Server URL of the database (with API) where the scholar data is saved
    var scholarsServerURL = "http://wwdcscholarsadmin.herokuapp.com"
    
    /// Shared Instance of the ScholarAPI
    static let sharedInstance = ScholarsKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
//    let data = "[{\"_id\":\"56f95ab20eb1a7027a7463ae\",\"latitude\":37.44187628900045,\"longtitude\":-122.1430178499997,\"shortBio\":\"I'm from Guangzhou, China. Studying in US as a high school student at The King's Academy. I've been an iOS developer for three years. I'm also a self-taught UI/UX designer.\",\"itunes\":\"https://itunes.apple.com/us/artist/tianyu-li/id830191901\",\"website\":\"http://www.skyrain.org/\",\"linkedin\":\"https://www.linkedin.com/pub/tianyu-li/8b/b23/362\",\"github\":\"https://github.com/tonylitianyu\",\"facebook\":\"https://www.facebook.com/tonylitianyu\",\"location\":\"Palo Alto, United States\",\"gender\":\"Male\",\"age\":18,\"birthday\":\"1996-11-23T16:00:00.000Z\",\"email\":\"tonylitianyu@gmail.com\",\"lastName\":\"Li\",\"firstName\":\"Tianyu\",\"screenshotTwo\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_TianyuLi_screenshotTwo.jpg\",\"screenshotOne\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_TianyuLi_screenshotOne.jpg\",\"profilePic\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_TianyuLi_profilePic_1459374596558.png\",\"acceptanceEmail\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_TianyuLi_acceptanceEmail.jpg\",\"__v\":0,\"numberOfTimesWWDCScholar\":1,\"statusComment\":\"\",\"status\":\"Approved\",\"approvedOn\":\"2016-03-29T13:43:39.183Z\",\"updatedAt\":\"2016-03-28T16:24:18.105Z\",\"createdAt\":\"2016-03-28T16:24:18.105Z\",\"batchWWDC\":[\"WWDC15\"]},{\"_id\":\"56f95bea0eb1a7027a7463af\",\"latitude\":40.71426940400045,\"longtitude\":-74.00596992899966,\"status\":\"Approved\",\"shortBio\":\"I am an iOS developer with two apps on the app store called Knightly Moves and Healthy Food Compass. I am also a wrestler.\",\"itunes\":\"https://itunes.apple.com/app/id942307965\",\"location\":\"New York, United States\",\"gender\":\"Female\",\"age\":12,\"birthday\":\"2003-02-18T16:00:00.000Z\",\"email\":\"thebluecat544@gmail.com\",\"lastName\":\"Cawley\",\"firstName\":\"Kiera\",\"screenshotThree\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_KieraCawley_screenshotThree.png\",\"screenshotTwo\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_KieraCawley_screenshotTwo.png\",\"screenshotOne\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_KieraCawley_screenshotOne.png\",\"profilePic\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_KieraCawley_profilePic_1459374683952.png\",\"acceptanceEmail\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_KieraCawley_acceptanceEmail.png\",\"__v\":0,\"numberOfTimesWWDCScholar\":1,\"statusComment\":\" \",\"updatedAt\":\"2016-03-28T16:29:30.098Z\",\"createdAt\":\"2016-03-28T16:29:30.098Z\",\"batchWWDC\":[\"WWDC15\"]},{\"_id\":\"56f95f52f79959c77d60aeaa\",\"latitude\":51.50852804400046,\"longtitude\":-0.12573890399954735,\"status\":\"Approved\",\"shortBio\":\"Hi! I'm a Imperial College Computing Student.\",\"website\":\"http://niket.london/\",\"linkedin\":\"https://www.linkedin.com/profile/view?id=192069109\",\"github\":\"http://github.com/mrniket\",\"facebook\":\"http://facebook.com/masterniket\",\"twitter\":\"http://twitter.com/masterniket\",\"location\":\"London, United Kingdom\",\"gender\":\"Male\",\"age\":22,\"birthday\":\"1993-01-17T16:00:00.000Z\",\"email\":\"niket.shah@outlook.com\",\"lastName\":\"Shah\",\"firstName\":\"Niket\",\"screenshotOne\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_NiketShah_screenshotOne.jpg\",\"profilePic\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_NiketShah_profilePic_1459375254552.png\",\"acceptanceEmail\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_NiketShah_acceptanceEmail.jpg\",\"__v\":0,\"numberOfTimesWWDCScholar\":1,\"updatedAt\":\"2016-03-28T16:44:02.022Z\",\"createdAt\":\"2016-03-28T16:44:02.022Z\",\"batchWWDC\":[\"WWDC15\"]},{\"_id\":\"56fc2ddaa5ac14970921ad6a\",\"latitude\":52.065619109000465,\"longtitude\":5.3727866690004475,\"status\":\"approved\",\"shortBio\":\"Hey there! I'm Matthijs, I'm 15 years old and I love programming iOS and Android apps. I started programming when I was about 12 years old, a roster app for my secondary school. I loved programming so much that I continued doing it and made it my side job beside school.\",\"numberOfTimesWWDCScholar\":1,\"website\":\"http://logicbit.nl\",\"linkedin\":\"http://linkedin.com/pub/matthijs-logemann/80/440/385/\",\"github\":\"http://github.com/matthijs2704\",\"facebook\":\"http://www.facebook.com/matthijs.logemann\",\"twitter\":\"http://twitter.com/matthijs2704\",\"videoLink\":\"http://youtu.be/Tni7pJ5qO2c\",\"location\":\"Maarn, The Netherlands\",\"gender\":\"Male\",\"age\":16,\"birthday\":\"1999-04-27T00:00:00.000Z\",\"email\":\"matthijs.logemann@xs4all.nl\",\"lastName\":\"Logemann\",\"firstName\":\"Matthijs\",\"screenshotThree\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_MatthijsLogemann_screenshotThree.jpg\",\"screenshotTwo\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_MatthijsLogemann_screenshotTwo.jpg\",\"screenshotOne\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_MatthijsLogemann_screenshotOne.jpg\",\"profilePic\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_MatthijsLogemann_profilePic.jpg\",\"acceptanceEmail\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_MatthijsLogemann_acceptanceEmail.jpg\",\"__v\":0,\"approvedBy\":\"sam0711er\",\"statusComment\":\"Miley Cyrus and Hannah Montana were the same people.\",\"updatedAt\":\"2016-03-30T19:49:46.136Z\",\"createdAt\":\"2016-03-30T19:49:46.136Z\",\"batchWWDC\":[\"WWDC15\"]},{\"_id\":\"56fc3b1ba5ac14970921ad78\",\"status\":\"approved\",\"age\":15,\"birthday\":\"2000-05-01T16:00:00.000Z\",\"lastName\":\"Eckert\",\"firstName\":\"Sam\",\"screenshotOne\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_SamEckert_screenshotOne.png\",\"profilePic\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_SamEckert_profilePic.jpg\",\"acceptanceEmail\":\"https://s3-us-west-2.amazonaws.com/wwdcscholars/scholarImages/2015_SamEckert_acceptanceEmail.png\",\"__v\":1,\"email\":\"sam@sam0711er.com\",\"gender\":\"Male\",\"github\":\"github.com/Sam0711er\",\"latitude\":48.78231896200049,\"linkedin\":\"www.linkedin.com/profile/view?id=433147002\",\"location\":\"Stuttgart, Germany\",\"longtitude\":9.177019089000453,\"numberOfTimesWWDCScholar\":1,\"shortBio\":\"iOS Developer // Author at Die-Smartwatch.de & Gadget-Rausch.de // YouTuber at iOSPilot.de // Interested in  & Smartwatches // Username on other social networks: Sam0711er\",\"twitter\":\"www.twitter.com/Sam0711er\",\"website\":\"https://github.com/Sam0711er\",\"approvedBy\":\"sam0711er\",\"statusComment\":\"Sam is cool\",\"updatedAt\":\"2016-03-30T20:46:19.296Z\",\"createdAt\":\"2016-03-30T20:46:19.296Z\",\"batchWWDC\":[\"WWDC15\"]}]"
//    
    private init() {
    }
    
    /**
     Loads scholars from the online database
     */
    func loadScholars(completionHandler: () -> Void) {
        request(.GET, "https://wwdcscholarsadmin.herokuapp.com/api/scholars")
            .responseString() { response in
            if let data = response.result.value {
                print (data)
                let json = JSON.parse(data)
                print("JSON: \(json)")
                if let array = json.array {
                    self.parseScholars(array)
                    completionHandler()
                }
            }
        }
    }
    
    func parseScholars(jsonArr: [JSON]) {
        for scholarJson in jsonArr {
            if let scholar = parseScholar(scholarJson) {
                dbManager.addScholar(scholar)
            }else {
                print("Scholar (with id \(scholarJson["_id"].string)) missing items!")
            }
        }
    }
    
    func parseScholar(json: JSON) -> Scholar? {
        if let id = json["_id"].string, let latitude = json["latitude"].double, let longitude = json["longtitude"].double, let shortBio = json["shortBio"].string, let location = json["location"].string, let gender = json["gender"].string, let age = json["age"].int, let birthday = json["birthday"].string,let profilePic = json["profilePic"].string, let email = json["email"].string, let lastName = json["lastName"].string, let firstName = json["firstName"].string, let numberOfTimesWWDCScholar = json["numberOfTimesWWDCScholar"].int, let batchWWDC = json["batchWWDC"].array {
            let newScholar = Scholar()
            newScholar.id = id
            newScholar.age = age
            newScholar.email = email
            newScholar.facebookURL = json["facebook"].string
            newScholar.firstName = firstName
            newScholar.lastName = lastName
            newScholar.githubURL = json["github"].string
            newScholar.gender = (gender == "Male") ? .Male : .Female
            newScholar.iTunesURL = json["itunes"].string
            newScholar.linkedInURL = json["linkedin"].string
            newScholar.numberOfTimesWWDCScholar = numberOfTimesWWDCScholar
            newScholar.shortBio = shortBio
            newScholar.websiteURL = json["website"].string
            newScholar.batchWWDC = batchWWDC.map { WWDC.forRawValue($0.string!) }
            newScholar.location = Location(name: location, longitude: longitude, latitude: latitude)
            newScholar.birthday = birthday.dateFromFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            newScholar.profilePicURL = profilePic
            return newScholar
        }else {
            return nil
        }
    }
}