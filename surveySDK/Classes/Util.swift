//
//  Util.swift
//  surveySDK
//
//  Created by Winston on 2023/6/26.
//

import Foundation

public struct Util {
    public static func parsePx(value: String, max: Int) -> Int {
        if (value.hasSuffix("px")) {
            return Int(value.dropLast(2))!;
        } else if (value.hasSuffix("%")) {
            return Int(Float(value.dropLast(1))! * Float(max));
        }
        return 0;
    }
    
    public static func optString(config: [String: Any], key: String, fallback: String) -> String {
        return config.index(forKey: key) != nil ? config[key] as! String : fallback
    }
    
    public static func optBool(config: [String: Any], key: String, fallback: Bool) -> Bool {
        return config.index(forKey: key) != nil ? config[key] as! Bool : fallback
    }
}
