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
    
    public static func donwloadConfig(server: String, surveyId: String, channelId: String, onCallback: Optional<([String : Any]?, String?) -> Void> = nil) {
        let url = URL(string:  "\(server)/surveys/\(surveyId)/embed?channelId=\(channelId)")!;
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                  return
            }

            do {
                let json: [String : Any] = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String : Any]
                if (onCallback != nil && json.index(forKey: "data") != nil) {
                    let config = json["data"] as? [String : Any];
                    if (config != nil) {
                        let surveyStatus = config!["surveyStatus"] as? String;
                        let channelStatus = config!["channelStatus"] as? String;
                        if (surveyStatus != "STOPPED" && channelStatus != "STOPPED" ) {
                            onCallback!(config, nil);
                            return
                        }
                    }
                }
                onCallback!(nil, "问卷停用");
            } catch {
                print("didnt work")
            }

        }
        task.resume();
    }
}
