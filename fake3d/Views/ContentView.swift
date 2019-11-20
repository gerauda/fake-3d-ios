//
//  ContentView.swift
//  fake3d
//
//  Created by Antoine GERAUD on 15/11/2019.
//  Copyright © 2019 Antoine GERAUD. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let STEP = 10
    let MAX_STEPS = 72
    
    @State var currentFrame = 1
    @State var moving = false
    @State var startLocation: CGFloat = 0.0
    @State var startFrame = 0
    @ObservedObject var dowloadManager: DownloadManager = DownloadManager()
    
    var body: some View {
        LoadingView(isShowing: $dowloadManager.isLoading, displayedText: $dowloadManager.displayedText)  {
            Image(uiImage: (
                self.dowloadManager.getSavedImage(named: String(format: "%02d.png", self.currentFrame as Int)) ?? UIImage(named: "placeholder")!))
                .resizable()
                .scaledToFit()
                .frame(width: 370, height: 370)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if (self.moving == false) {
                                self.moving = true
                                self.startLocation = value.location.x
                                self.startFrame = self.currentFrame
                            }

                            self.currentFrame = self.startFrame + Int(((value.location.x - self.startLocation) / CGFloat(self.STEP)))

                            while (self.currentFrame > self.MAX_STEPS) {
                                self.currentFrame -= self.MAX_STEPS
                            }
                            while (self.currentFrame < 1) {
                                self.currentFrame += self.MAX_STEPS
                            }
                    }
                    .onEnded { value in
                        self.moving = false
                    }
            )
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


