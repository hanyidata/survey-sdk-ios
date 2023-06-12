import Foundation
import SwiftUI
import UIKit

/**
  问卷视图 (Swift版本)
 */
@available(iOS 13.0, *)
public struct HYSurveyView: UIViewRepresentable {
    var surveyId : String = ""
    var channelId : String = ""
    var parameters : Dictionary<String, Any> = Dictionary()
    var options : Dictionary<String, Any> = Dictionary()
    var assets : String = ""
    var onSubmit: Optional<() -> Void> = nil
    var onCancel: Optional<() -> Void> = nil
    var onSize: Optional<(_ height: Int) -> Void> = nil
    var onClose: Optional<() -> Void> = nil

    
    /**
     初始化问卷
     - surveyId 问卷id
     - channelId 渠道id
     - parameters 参数 可选
     - options 设置项目 可选
     - callback 回调
     */
    public init(surveyId: String, channelId: String, parameters: Dictionary<String, Any> = Dictionary<String, Any>.init(), options: Dictionary<String, Any> = Dictionary<String, Any>.init(),
                onSubmit: Optional<() -> Void> = nil,
                onCancel: Optional<() -> Void> = nil,
                onSize: Optional<(_ height: Any?) -> Void> = nil,
                onClose: Optional<() -> Void> = nil,
                assets: String = "") {
        self.surveyId = surveyId
        self.channelId = channelId
        self.parameters = parameters
        self.options = options
        self.assets = assets
        self.onSubmit = onSubmit
        self.onSize = onSize
        self.onCancel = onCancel
        self.onClose = onClose

    }
    
    /**
        Swift 版本接口
     */
    public func makeUIView(context: Context) -> HYUISurveyView {
        let survey = HYUISurveyView.makeSurveyController(surveyId: self.surveyId, channelId: self.channelId, parameters: self.parameters, options: self.options, onSubmit: self.onSubmit, onCancel: self.onCancel, onSize: self.onSize, onClose: self.onClose, assets: self.assets)
        return survey
    }
    
    /**
     
     */
    public func updateUIView(_ uiView: HYUISurveyView, context: Context) {
    }

}
