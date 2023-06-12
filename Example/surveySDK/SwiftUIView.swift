//
//  SwiftUIView.swift
//  surveySDK-example
//
//  Created by Winston on 2023/5/17.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SwiftUI
import surveySDK

@available(iOS 15.0, *)
struct SwiftUIView: View {
    @State private var show: Bool = true // 显示控制
    @State private var height: Int = 0   // 问卷高度
    @State private var showingAlert = false
    @State private var message = ""
//    @State private var version = HYSurveyView.getVersion()

    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
//            Text("Version: " + version)
            Text("list#1")
            Text("list#2")
            if show {
                HYSurveyView(surveyId: "3512748182348800", channelId: "3512750347396096", parameters: ["externalUserId":"winston"], options: ["server": "test", "debug": true, "autoheight": false], onSubmit: {
                    showAlert(msg: "问卷填答完成")
                }, onCancel: {
                    showAlert(msg: "填答取消")
                }, onSize: {arg  in
                    height = arg as! Int
                }, onClose: {show = false}, assets: "Assets")
//                .border(.green)
//                .frame(maxHeight: 300, alignment: .top)
                .frame(height: CGFloat(height))
            }
            Text("list#3")
            Text("list#4")
                
            
        }
        .alert(message, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }

//        .padding()
//        .border(.gray)
//        .frame(width: 300, height: 300, alignment: .center)
        
        
        
    }
    
    func showAlert(msg: String) -> Void {
        message = msg
        showingAlert = true
    }
}

@available(iOS 15.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
        
    }
}
