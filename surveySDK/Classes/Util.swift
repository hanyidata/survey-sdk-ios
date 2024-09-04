//
//  Util.swift
//  surveySDK
//
//  Created by Winston on 2023/6/26.
//

import Foundation
import UIKit

public struct Util {
    /**
      计算像素
     */
    public static func parsePx(value: String, max: Int) -> Int {
        if (value.hasSuffix("px")) {
            return Int(value.dropLast(2))!;
        } else if (value.hasSuffix("%")) {
            return Int(Float(value.dropLast(1))! * Float(max) / 100);
        }
        return 0;
    }
    
    public static func optString(config: [String: Any], key: String, fallback: String) -> String {
        return config.index(forKey: key) != nil ? config[key] as! String : fallback
    }
    
    public static func optBool(config: [String: Any], key: String, fallback: Bool) -> Bool {
        return config.index(forKey: key) != nil ? config[key] as! Bool : fallback
    }
    
    /**
     颜色转换 注意FF透明度是放在最后
     */
    public static func colorFromHex(_ hex: String) -> UIColor {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 7: // RGB + Alpha (28-bit, assume last digit is alpha)
            (r, g, b, a) = (int >> 20 & 0xFF, int >> 12 & 0xFF, int >> 4 & 0xFF, (int & 0xF) * 17)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (1, 1, 1, 1)
        }
        return UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }

}
