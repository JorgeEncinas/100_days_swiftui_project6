//
//  ContentView.swift
//  Animations
//
//  Created by Jorge Encinas on 6/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        VStack {
            Button("Tap tap") {
                animationAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmount)
            .blur(
                radius: (animationAmount - 1) * 3
            )
            .animation( //Implicit animation
                .default,
                value: animationAmount
            )
        }
        .padding()
    }
}

// ANIMATIONS
//  implicit animation ----
//      Tell our views ahead of time
//      SwiftUI makes sure any changes follow the animation requested

// Make the button bigger with each tap.
//  `scaleEffect()`

// IMPLICIT ANIMATION
//  Nowhere did we say what each frame of the animation should look like
//  We did not specify when the animation
//      should start and end either
//  Instead, our animation becomes a function
//      of our STATE,
//      just like the views themselves.


#Preview {
    ContentView()
}
