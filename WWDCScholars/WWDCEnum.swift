//
//  WWDCEnum.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

enum WWDC: String {
    case WWDC2016 = "2016"
    case WWDC2015 = "2015"
    case WWDC2014 = "2014"
    case WWDC2013 = "2013"
    case WWDC2012 = "2012"
    case WWDC2011 = "2011"
    
    /**
     Returns the enum value for the string returned by the webserver
     
     - parameter rawValue: String returned by the webserver
     
     - returns: Enum value of WWDC
     */
    static func forRawValue(rawValue: String) -> WWDC{
        switch rawValue {
        case "WWDC16":
            return .WWDC2016
        case "WWDC15":
            return .WWDC2015
        case "WWDC14":
            return .WWDC2014
        case "WWDC13":
            return .WWDC2013
        case "WWDC2012":
            return .WWDC2012
        case "WWDC11":
            return .WWDC2011
        default:
            return .WWDC2016
        }
    }
    
    var shortVersion: String {
        switch self {
        case WWDC2016:
            return "'16"
        case WWDC2015:
            return "'15"
        case WWDC2014:
            return "'14"
        case WWDC2013:
            return "'13"
        case WWDC2012:
            return "'12"
        case WWDC2011:
            return "'11"
        }
    }
}
