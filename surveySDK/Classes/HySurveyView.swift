import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
struct HySurveyView: UIViewRepresentable {
    var surveyId : String = ""
    var channelId : String = ""
    var parameters : Dictionary<String, Any>!
    var options : Dictionary<String, Any>!
    
    func makeUIView(context: Context) -> SurveyView {
        let survey = SurveyView.makeSurveyController(surveyId: self.surveyId, channelId: self.channelId, parameters: self.parameters, options: self.options)
        return survey
    }
    
    func updateUIView(_ uiView: SurveyView, context: Context) {
    }

}
