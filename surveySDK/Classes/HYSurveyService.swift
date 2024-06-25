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
    
    /**
     HYService download channel embed config
     */
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
    
    private static func stringValue(for key: String, in dictionary: [String: Any]) -> String? {
        if let value = dictionary[key] {
            return "\(value)"
        }
        return nil
    }
    
    /**
     HYService get config by sendId
     */
    public static func downloadBySendId(server: String, sendId: String, accessCode: String, externalUserId: String, onCallback: Optional<( String?, String?, [String : Any]?, String?) -> Void> = nil) {
        if (onCallback == nil) {
            return;
        }
                
        let url = "\(server)/surveys/send-manage/\(sendId)";
        
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
                        let surveyId = stringValue(for: "surveyId", in: config!);
                        let channelId = stringValue(for: "channelId", in: config!);
                        if (surveyId != nil && channelId != nil) {
                            HYSurveyService.donwloadConfig(server: server, surveyId: surveyId!, channelId: channelId!, accessCode: accessCode, externalUserId: externalUserId, onCallback: { config, error in
                                onCallback!(surveyId!, channelId!, config, nil);
                            })
                        } else {
                            onCallback!(nil, nil, nil, "系统异常");
                        }
                    }
                    return;
                } else {
                    let error = json["message"] as? String;
                    
//                    donwloadConfig(server: server, surveyId: surveyId, channelId: channelId, accessCode: accessCode, externalUserId: <#T##String#>)
                    onCallback!(nil, nil, nil,  error);
                    return
                }
            } catch {
                onCallback!(nil, nil, nil, "系统异常");
            }
        }
        task.resume();
    }
}
