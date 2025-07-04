//
//  ContentView.swift
//  Animations
//
//  Created by Jorge Encinas on 6/23/25.
//

import SwiftUI

struct ImplicitAnimationButton : View {
    @State private var animationAmount = 1.0
    
    var body : some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount) //With just this one, it skips immediately to the next state
        .blur(
            radius: (animationAmount - 1) * 3
        )
        .animation(
            .default, //.linear, .easeInOut(duration), .spring(duration, bounce)
            value: animationAmount
        )
    }
}

struct AnimatedButton1 : View {
    @State private var animationAmount = 1.0
    
    var body : some View {
        Button("Tap Me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount)
        .animation(.easeInOut(duration: 2)
                        .delay(1)
                        .repeatCount(3, autoreverses: true), //the instance of the Animation struct has its own modifiers!
                   value: animationAmount
        )
    }
}

struct PulsatingButton : View {
    @State private var animationAmount = 1.0
    
    var body : some View {
        Button("Tap Me") {
        }
        .clipShape(.circle)
        .overlay( //A modifier to create new views at the same size and position as the view we're overlaying
            Circle() //So we create a circle right on top of our button
                .stroke(.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeOut(duration: 1)
                    .repeatForever(autoreverses: false),
                    value: animationAmount
                )
        )
        .onAppear {
            animationAmount = 2
        }
    }
}

struct BindingsAnimation1 : View {
    @State private var animationAmount = 1.0
    
    
    var body : some View {
        print(animationAmount)
        
        return VStack {
            Stepper(
                "Scale Amount",
                value: $animationAmount.animation(), //However, pressing the stepper DOES have an effect
                in: 1...10
            )
            Spacer()
            Button("Tap Me") { //If you tap, no animation takes place
                animationAmount += 1
            }
            .padding(40)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmount)
        }
    }
}

struct BindingsAnimation2 : View  {
    @State private var animationAmount = 1.0

    var body : some View {
        Stepper(
            "Scale amount",
            value: $animationAmount.animation(
                .easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true)
            ),
            in: 1...10
        )
        Spacer()
        Button("Tap Me") {
            
        }
        .padding(40)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount)
        Spacer()
       
    }
}

struct ExplicitAnimation1 : View {
    @State private var animationAmount = 0.0
    
    var body : some View {
        Button("Tap Me") {
            //withAnimation(.spring(duration: 1, bounce: 0.5)) {
            //    animationAmount += 360
            //}
            withAnimation {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .rotation3DEffect(
            .degrees(animationAmount),
            axis: (x: 0, y: 1, z: 0)
        )
    }
}

struct StackAnimation : View {
    var body : some View {
        Button("Tap Me") {
            
        }
        .background(.blue)
        .frame(width: 200, height: 200)
        .foregroundStyle(.white)
        Button("Different") {
            
        }
        .frame(width: 200, height: 200)
        .background(.blue)
        .foregroundStyle(.white)
    }
}

struct StackAnimation2 : View {
    @State private var enabled = false
    
    var body : some View {
        Button("Tap Me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red) //We'll see here that modifier order matters!
        .foregroundStyle(.white)
        .animation(.default, value: enabled)
        .clipShape(
            .rect(cornerRadius: enabled ? 60 : 0)
        )
        .animation( //Now we have a tiered animation. the first one handles the changes above it.
            .spring(duration: 1, bounce: 0.6),
            value: enabled
        )
        .scaleEffect(enabled ? 1.0 : 0.5)
        .animation(nil, value: enabled) //Note that the size change is IMMEDIATE!
    }
}

struct GestureAnimation1 : View {
    @State private var dragAmount = CGSize.zero
    
    var body : some View {
        LinearGradient(
            colors: [.yellow, .red],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: 300, height: 200)
        .clipShape(
            .rect(cornerRadius: 10)
        )
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in dragAmount = .zero }
        )
        .animation(.bouncy, value: dragAmount)
    }
}

struct GestureAnimation2 : View {
    @State private var dragAmount = CGSize.zero
    
    var body : some View {
        LinearGradient(
            colors: [.yellow, .red],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(width: 300, height: 200)
        .clipShape(
            .rect(cornerRadius: 20)
        )
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged {
                    //withAnimation(.spring) { //You can't call the animation here because it would be call too often and unreliably!
                        dragAmount = $0.translation
                    //} //So note that this way, the animation is on ONLY for when you finish dragging
                }
                .onEnded { _ in
                    withAnimation(.bouncy) { //Explicit animation instead!
                        dragAmount = CGSize.zero
                    }
                }
        )
        //.animation(
        //    .bouncy,
        //    value: dragAmount
        //)
    }
}

struct GestureAnimation3 : View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body : some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id:\.self) { (num : Int) in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(
                        .linear.delay(Double(num) / 20),
                        value: dragAmount
                    )
            }
        }.gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = CGSize.zero
                    enabled.toggle()
                }
            
        )
    }
}

struct TransitionView : View {
    @State private var isShowingRed = false
    
    var body : some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.scale) //Without it, the "Tap Me" button slides up!
            }
        }
    }
}

struct TransitionView2 : View {
    @State private var isShowingRed = false
    
    var body : some View {
        VStack {
            Button("Tap Me") {
                // If you don't specify 'withAnimation' then it won't work. using .animation() does not work either, that might be because when isShowingRed = false, then we don't enter the block, thus the view does not exist! something of the sort.
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(
                        .asymmetric(
                            insertion: .scale,
                            removal: .opacity
                        )
                    )
            }
        }
    }
}

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

struct PivotAnimation : View {
    @State private var isShowingRed = false
    
    var body : some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(
                    width: 200,
                    height: 200
                )
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

struct ContentView: View {
    //let letters = Array("Hello SwiftUI")
    //@State private var enabled = false
    //@State private var dragAmount = CGSize.zero //Stores the amount of drag
    //@State private var isShowingRed = false
    
    var body: some View {
        //BindingsAnimation2()
        //StackAnimation2()
        //GestureAnimation3()
        //TransitionView2()
        PivotAnimation()
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
