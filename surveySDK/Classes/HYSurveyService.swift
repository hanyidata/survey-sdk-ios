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
    
    public static func donwloadConfig(server: String, surveyId: String, channelId: String, accessCode: String, onCallback: Optional<([String : Any]?, String?) -> Void> = nil) {
        if (onCallback == nil) {
            return;
        }
        
        let url = URL(string:  "\(server)/surveys/\(surveyId)/embed?channelId=\(channelId)&accessCode=\(accessCode)")!;
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
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
                        if (surveyStatus == "STOPPED" && channelStatus == "STOPPED" ) {
                            onCallback!(config, "问卷停用");
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
