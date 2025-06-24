//
//  ContentView.swift
//  Animations
//
//  Created by Jorge Encinas on 6/23/25.
//

import SwiftUI

struct CornerRotateModifier : ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect( //We want you to rotate by the specified amount, from the anchor (corner for us) specified
                .degrees(amount),
                anchor: anchor
            )
            .clipped() //Parts lying OUTSIDE of the natural rectangle are NOT drawn
    }
}

extension AnyTransition {
    static var pivot : AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}


struct ContentView: View {
    //let letters = Array("Hello SwiftUI")
    //@State private var enabled = false
    //@State private var dragAmount = CGSize.zero //Stores the amount of drag
    @State private var isShowingRed = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }.onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
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

// CUSTOM TRANSITIONS WITH `.modifier` transition
//  BUT we need to be able to instantiate the modifier
//      That means we need to create it ourselves.
    
// PIVOT ANIMATION in Keynote
//      a new slide rotates in from its top-left corner.
//      Creating a view modifier that causes our view to rotate IN from one corenr,
//      without escaping the bounds it's supposed to be in.

//  rotationEffect() to rotate a view in 2D space
//  clipped() stops the view from being drawn outside of its rectangular space.

// rotationEffect() is similar to rotation3DEffect()
//  except it always rotates around the Z Axis.
//  AND it gives us the ability to control the ANCHOR POINT of the rotation (so we can set it to anchor from one corner)

//  SwiftUI gives us a UnitPoint type
//      controls the ANCHOR, specifying exact XY point for the rotation, as well as ability to use the options.
//  .topLeading, .bottomTrailing, .center

#Preview {
    ContentView()
}
