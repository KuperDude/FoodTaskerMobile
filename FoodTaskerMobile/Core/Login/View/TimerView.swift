//
//  TimerView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 18.02.2024.
//

import SwiftUI

struct TimerView: View {
    
    @State var timeRemaining = 60
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var action: ()->Void
    
    var body: some View {
        Text("Отправить код повторно" + (timeRemaining > 0 ? " (\(timeRemaining) сек.)" : ""))
            .font(.caption)
            .foregroundColor(timeRemaining > 0 ? Color.init(uiColor: .lightGray) : Color.blue)
            .underline()
            .onTapGesture {
                if timeRemaining > 0 {
                    return
                }
                
                timeRemaining = 60
                self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                
                action()
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer.upstream.connect().cancel()
                }
            }
    }
}

#Preview {
    TimerView(action: {})
}
