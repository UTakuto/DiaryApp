//
//  CharacterView.swift
//  Diary
//
//  Created by 本田有人 on 2024/08/31.
//

import SwiftUI

struct CharacterView: View {
    @State private var offsetY: CGFloat = 0
    @State private var movingDown = true
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Image("character")
            .resizable()
            .frame(width: 270, height: 200)
            .offset(y: offsetY)
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 2)) {
                    if movingDown {
                        offsetY = 5
                    } else {
                        offsetY = -20
                    }
                    movingDown.toggle()
                }
            }
    }
}

#Preview {
    CharacterView()
}
