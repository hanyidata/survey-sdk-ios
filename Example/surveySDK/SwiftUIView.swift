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

    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                        
            Text("list#1")
            Text("list#2")
            if show {
                HYSurveyView(surveyId: "4186159406162944", channelId: "4186160160881664", parameters: ["externalUserId":"winston"], options: ["autoheight": true], onSubmit: {arg  in
                    showAlert(msg: "问卷已经填答")
                }, onCancel: {arg  in
                    showAlert(msg: "填答取消")
                }, onSize: {arg  in
                    height = arg as! Int
                }, onClose: {arg  in
                    show = false
                }, assets: "Assets")
//                .border(.green)
                .frame(maxHeight: 300, alignment: .top)
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
