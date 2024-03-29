//
//  HYSurveyService.swift
//  surveySDK
//
//  Created by Winston on 2023/6/26.
//

import Foundation

 /**
  HY Survey Service
  */
public struct HYSurveyService {
    
    public static func donwloadConfig(server: String, surveyId: String, channelId: String, accessCode: String, externalUserId: String, onCallback: Optional<([String : Any]?, String?) -> Void> = nil) {
        if (onCallback == nil) {
            return;
        }
                
        var url = "\(server)/surveys/\(surveyId)/embed?channelId=\(channelId)";
        
        if (!accessCode.isEmpty) {
            url = "\(url)&accessCode=\(accessCode)"
        }

        if (!externalUserId.isEmpty) {
            url = "\(url)&externalUserId=\(externalUserId)"
        }
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            guard let data = data else {
                  return
            }

            do {
                let json: [String : Any] = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String : Any]
                let code = json["code"] as? NSNumber;
                if (code == 200) {
                    let config = json["data"] as? [String : Any];
                    if (config != nil) {
                        let surveyStatus = config!["surveyStatus"] as? String;
                        let channelStatus = config!["channelStatus"] as? String;
                        let doNotDisturb = config!["doNotDisturb"] as? Bool;
                        if (surveyStatus == "STOPPED" && channelStatus == "PAUSE" ) {
                            onCallback!(config, "问卷停用");
                            return
                        } else if (doNotDisturb == true) {
                            onCallback!(config, "免打扰屏蔽");
                            return
                        }
                        onCallback!(config, nil);
                    }
                } else {
                    let error = json["message"] as? String;
                    onCallback!(nil,  error);
                    return
                }
            } catch {
                onCallback!(nil, "系统异常");
            }
        }
        task.resume();
    }
}
