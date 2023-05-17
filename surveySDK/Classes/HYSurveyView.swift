import Foundation
import SwiftUI
import UIKit

public struct HYSurveyView: UIViewRepresentable {
    var surveyId : String = ""
    var channeld : String = ""
    var parameters : Dictionary<String, Any>!
    var options : Dictionary<String, Any>!
    
    public init(surveyId: String, channeld: String, parameters: Dictionary<String, Any> = Dictionary<String, Any>.init(), options: Dictionary<String, Any> = Dictionary<String, Any>.init()) {
        self.surveyId = surveyId
        self.channeld = channeld
        self.parameters = parameters
        self.options = options
    }
    
    public func makeUIView(context: Context) -> HYUISurveyView {
        let survey = HYUISurveyView.makeSurveyController(surveyId: self.surveyId, channelId: self.channeld, parameters: self.parameters, options: self.options)
        return survey
    }
    
    public func updateUIView(_ uiView: HYUISurveyView, context: Context) {
    }

}
