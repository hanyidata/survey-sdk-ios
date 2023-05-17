import Foundation
import SwiftUI
import UIKit


public struct HYSurveyView: UIViewRepresentable {
    var surveyId : String = ""
    var channelId : String = ""
    var parameters : Dictionary<String, Any>!
    var options : Dictionary<String, Any>!
    var assets : String = ""
    var callback: Optional<(_ event: String, _ params: Any?) -> Void> = nil

    
    public init(surveyId: String, channelId: String, parameters: Dictionary<String, Any> = Dictionary<String, Any>.init(), options: Dictionary<String, Any> = Dictionary<String, Any>.init(), callback: Optional<(_ event: String, _ params: Any?) -> Void> = nil, assets: String = "") {
        self.surveyId = surveyId
        self.channelId = channelId
        self.parameters = parameters
        self.options = options
        self.assets = assets
        self.callback = callback

    }
    
    public static func dismantleUIView(_ uiView: HYUISurveyView, coordinator: Coordinator) {
        print("dismantleUIView")
    }
    
    public func makeUIView(context: Context) -> HYUISurveyView {
        let survey = HYUISurveyView.makeSurveyController(surveyId: self.surveyId, channelId: self.channelId, parameters: self.parameters, options: self.options, callback: self.callback, assets: self.assets)
        return survey
    }
    
    public func updateUIView(_ uiView: HYUISurveyView, context: Context) {
    }

}
