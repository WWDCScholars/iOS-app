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
    case Saved = "Saved"
    
    /**
     Returns the enum value for the string returned by the webserver
     
     - parameter rawValue: String returned by the webserver
     
     - returns: Enum value of WWDC
     */
    static func forRawValue(rawValue: String) -> WWDC{
        switch rawValue {
        case "Saved":
            return .Saved
        case "WWDC16":
            return .WWDC2016
        case "WWDC15":
            return .WWDC2015
        case "WWDC14":
            return .WWDC2014
        case "WWDC13":
            return .WWDC2013
        case "WWDC12":
            return .WWDC2012
        case "WWDC11":
            return .WWDC2011
        default:
            return .WWDC2016
        }
    }
    
    func toRawValue() -> String{
        switch self {
        case .Saved:
            return "Saved"
        case .WWDC2016:
            return "WWDC16"
        case .WWDC2015:
            return "WWDC15"
        case .WWDC2014:
            return "WWDC14"
        case .WWDC2013:
            return "WWDC13"
        case .WWDC2012:
            return "WWDC12"
        case .WWDC2011:
            return "WWDC11"
        }
    }
    
    var shortVersion: String {
        switch self {
        case .Saved:
            return "Saved"
        case .WWDC2016:
            return "'16"
        case .WWDC2015:
            return "'15"
        case .WWDC2014:
            return "'14"
        case .WWDC2013:
            return "'13"
        case .WWDC2012:
            return "'12"
        case .WWDC2011:
            return "'11"
        }
    }
    
    var intValue: Int {
        switch self {
        case Saved:
            return -1
        case .WWDC2016:
            return 5
        case .WWDC2015:
            return 4
        case .WWDC2014:
            return 3
        case .WWDC2013:
            return 2
        case .WWDC2012:
            return 1
        case .WWDC2011:
            return 0
        }
    }
}
