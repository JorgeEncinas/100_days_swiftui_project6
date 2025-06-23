//
//  ContentView.swift
//  Animations
//
//  Created by Jorge Encinas on 6/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        print(animationAmount)
        return VStack {
            Button("Tap Me") {
                withAnimation(.spring(duration: 1, bounce: 0.5)) {
                    animationAmount += 360
                }
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .rotation3DEffect(
                .degrees(animationAmount),
                axis: (x: 1, y: 0, z: 0)
            )
        }
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

// CUSTOMIZING ANIMATIONS =================
//  When we attach the `animation` modifier to a view
//      SwiftUI will automatically animate
//      any changes that happen to that view
//  Using whatever is the default system animation
//      whenever the value we're watching changes.

// In practice it's a gentle "Spring"
//  starts slow, picks up speed, then overshoots slightly,
//  then goes back a little, until it reaches its end state.

// `.linear`
//      This one instead moves at a constant speed.

// IMPLICIT ANIMATIONS must always watch a PARTICULAR VALUE
//  otherwise, animations would be triggered for every small change.
//  Even rotating the device from Portrait to Landscape would trigger the animation, which would look strange.

// WHY `SPRING` ANIMATIONS?
//  They mimic what we're used to.
//  You can control...
//      - how long the spring should take to complete
//      - how bouncy the spring should be
//      - whether it should bounce back and forwards more or less (1 = max bounciness, 0 = no bounciness)

// .animation(
//      .spring(
//          duration: 1,
//          bounce: 0.9
//      ),
//      value: animationAmount
//)

// WHAT DOES EASEINOUT DO?
//  We're creating an INSTANCE of an `Animation` struct
//  that has its own set of modifiers.

// So we can attach modifiers DIRECTLY to the animation
//  to add a delay like this:
//      .animation(
//          .easeInOut(duration: 2)
//              .delay(1),
//      value: animationAmount
//      )

#Preview {
    ContentView()
}
