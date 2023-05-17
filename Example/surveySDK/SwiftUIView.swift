//
//  SwiftUIView.swift
//  surveySDK-example
//
//  Created by Winston on 2023/5/17.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SwiftUI
import surveySDK

@available(iOS 13.0, *)
struct SwiftUIView: View {
    @State private var show: Bool = true // 显示控制
    @State private var height: Int = 0   // 问卷高度
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                        
            Text("list#1")
            Text("list#2")
            if show {
                HYSurveyView(surveyId: "4186159406162944", channelId: "4186160160881664", parameters: ["externalUserId":"winston"], options: ["debug": false], callback: {event,arg  in
                    if event == "close" {
                        show = false
                    } else if event == "size" {
                        height = arg as! Int
                    }
                }, assets: "Assets")
                .border(.green)
                .frame(maxHeight: 200)
//                .frame( height: CGFloat(height))
            }
            Text("list#3")
            Text("list#4")
                
            
        }
//        .padding()
//        .border(.gray)
//        .frame(width: 300, height: 300, alignment: .center)
        
        
        
    }
    
    func handleClick() -> Void {
        print("click")
        
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    @available(iOS 13.0, *)
    static var previews: some View {
        SwiftUIView()
        
    }
}
