//
//  Util.swift
//  surveySDK
//
//  Created by Winston on 2023/6/26.
//

import Foundation

/**
 问卷全局配置b
 */
public class HYGlobalConfig : NSObject {
    static var accessCode : String = "";
    static var server : String = "https://www.xmplus.cn/api/survey";
    static var authRequired : Bool = false;
    static var verified : Bool = false;
    static var project : String = "";
    
    /**
       全局配置问卷服务器
     */
    @objc public static func setup(server: String) -> Void {
        HYGlobalConfig.server = server;
    }
    
    /**
       全局配置问卷项目 专属项目定制相关谨慎使用
     */
    @objc public static func setupProject(project: String) -> Void {
        HYGlobalConfig.project = project;
    }

    /**
       全局配置问卷服务器，认证设置
     */
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
