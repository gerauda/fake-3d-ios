//
//  ContentView.swift
//  fake3d
//
//  Created by Antoine GERAUD on 15/11/2019.
//  Copyright © 2019 Antoine GERAUD. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var STEP = 10
    var MAX_STEPS = 44
    
    @State var currentFrame = 0
    @State var moving = false
    @State var startLocation: CGFloat = 0.0;
    @State var startFrame = 0;
    
    var body: some View {
        Image(String(format: "frame_%02d_delay-0.09s", self.currentFrame as Int))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if (self.moving == false) {
                            self.moving = true
                            self.startLocation = value.location.x
                            self.startFrame = self.currentFrame
                        }
                        
                        self.currentFrame = self.startFrame + Int(((value.location.x - self.startLocation) / CGFloat(self.STEP)))
                        
                        while (self.currentFrame >= self.MAX_STEPS) {
                            self.currentFrame -= self.MAX_STEPS
                        }
                        
                        while (self.currentFrame < 0) {
                            self.currentFrame += self.MAX_STEPS
                        }
                }
                .onEnded { value in
                    self.moving = false
                }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
