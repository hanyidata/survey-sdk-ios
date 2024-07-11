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
            统一开始
     */
    public static func unionStart(server: String, sendId: String?, surveyId: String?, channelId: String?, parameters: Dictionary<String, Any>, onCallback: Optional<([String : Any]?, String?) -> Void> = nil) {
        if (onCallback == nil) {
            return;
        }
        if !(sendId != nil || (surveyId != nil && channelId != nil)) {
            onCallback!(nil, "参数错误");
            return;
        }

        let url = "\(server)/surveys/union-start";
        let clientId = UUID().uuidString;
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a dictionary with the data you want to send
        let systemParametersWhiteList = ["externalUserId", "departmentCode", "externalCompanyId", "customerName", "customerGender"];
        var json: [String: Any] = ["clientId": clientId];
        
        if (sendId != nil) {
            json["sendToken"] = sendId;
        } else {
            if (surveyId != nil) {
                json["surveyId"] = surveyId;
            }
            if (channelId != nil) {
                json["channelId"] = channelId;
            }
        }
        for item in systemParametersWhiteList {
            if (parameters.index(forKey: item) != nil) {
                json[item] = parameters[item];
            }
        }
        if (parameters.index(forKey: "parameters") != nil) {
            json["parameters"] = parameters["parameters"];
        }

        // Convert the dictionary to JSON data
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])

        // Set the JSON data as the HTTP body of the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                  return
            }

            do {
                let json: [String : Any] = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String : Any]
                let code = json["code"] as? NSNumber;
                if (code == 200) {
                    let survey = json["data"] as? [String : Any];
                    if (survey == nil || survey?.index(forKey: "channel") == nil) {
                        onCallback!(nil,  "参数错误");
                    }
                    let surveyStatus = survey!["status"] as? String;
                    let channel = survey!["channel"] as! [String : Any];
                    let channelStatus = channel["status"] as? String;
                    let doNotDisturb = survey!["doNotDisturb"] as? Bool;
                    if (surveyStatus == "STOPPED" && channelStatus == "PAUSE" ) {
                        onCallback!(survey, "问卷停用");
                        return
                    } else if (doNotDisturb == true) {
                        onCallback!(survey, "免打扰屏蔽");
                        return
                    }
                    onCallback!(survey, nil);
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
