//
//  InclusiveGreeting.swift
//  Object Capture Create
//
//  Created by Bertan on 23.06.2021.
//

import SwiftUI
import Combine

// Pretty self explanatory :))
// A weaving hand emoji emoji that cycles between skin colors. #BlackLivesMatter
public struct InclusiveGreeting: View {
    @State private var currentHand = ""
    private var greetingMessage: String
    private let gradient: Gradient
    private let cycleDelay: Double
    private let hands = ["\u{1F44B}", "\u{1F44B}\u{1F3FB}", "\u{1F44B}\u{1F3FC}", "\u{1F44B}\u{1F3FD}", "\u{1F44B}\u{1F3FE}", "\u{1F44B}\u{1F3FF}"]
    // This timer will make sure the hands will switch periodically
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    public init(greetingMessage: String, gradient: Gradient, cycleDelay: Double = 3) {
        self.greetingMessage = greetingMessage
        self.gradient = gradient
        self.cycleDelay = cycleDelay
        timer = Timer.publish(every: cycleDelay, on: .main, in: .common).autoconnect()
    }
    
    public var body: some View {
        HStack {
            Text(currentHand)
                .roundedFont(.largeTitle)
                .transition(.opacity)
                .id(currentHand)
            Text(greetingMessage)
                .bold()
                .roundedFont(.largeTitle)
                .gradientBackground(gradient: gradient)
        }
        // Choose a random hand as soon as the view appears
        .onAppear {
            currentHand = hands.randomElement()!
        }
        // Switch to another weaving hand emoji when the timer fires, making sure it's a different one
        // Animation duration is equal to cycleDelay so that it can looks like a continuous cycle
        .onReceive(timer) { _ in
            withAnimation(.easeIn(duration: cycleDelay)) {
                currentHand = hands.filter { $0 != currentHand }.randomElement()!
            }
        }
    }
}

struct InclusiveGreeting_Previews: PreviewProvider {
    static var previews: some View {
        InclusiveGreeting(greetingMessage: "Hey!", gradient: .indigoGradient)
    }
}
