//
//  Util.swift
//  surveySDK
//
//  Created by Winston on 2023/6/26.
//

import Foundation

/**
 问卷全局配置
 */
public class HYGlobalConfig : NSObject {
    static var accessCode : String = "";
    static var server : String = "https://www.xmplus.cn/api/survey";
    static var authRequired : Bool = false;
    static var verified : Bool = false;
    
    @objc public static func setup(server: String, accessCode: String, authRequired: Bool) -> Void {
        HYGlobalConfig.server = server;
        HYGlobalConfig.accessCode = accessCode;
        HYGlobalConfig.authRequired = authRequired;
        
        if (authRequired && !accessCode.isEmpty) {
            // verify the access code
            HYSurveyConfigService.authCheck(server: server, accessCode: accessCode, onCallback: { pass, error in
                if (pass) {
                    NSLog("auth check passed");
                    HYGlobalConfig.verified = true;
                } else {
                    NSLog("auth check failed \(error)");
                }
            });
        }
    }
    
    @objc public static func check() -> Bool {
        if (HYGlobalConfig.authRequired && !HYGlobalConfig.verified) {
            return false;
        }
        return true;
    }
}
