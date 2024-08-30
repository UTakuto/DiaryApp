//
//  SplashScreen.swift
//  Diary
//
//  Created by 本田有人 on 2024/08/31.
//

import SwiftUI

struct SplashImage: View {
  let number: Int
  let rotation: Angle

  var body: some View {
    Image("spl\(number)")
      .rotationEffect(rotation)
  }
}

struct SplashScreen: View {
  @State private var isActive = false
  @State private var scales: [CGFloat]
  @State private var opacities: [Double]
  @State private var rotations: [Angle]
  private let splashDuration: Double = 2.0
  private let imageCount = 13

  init() {
    _scales = State(initialValue: Array(repeating: 1, count: imageCount))
    _opacities = State(initialValue: Array(repeating: 1, count: imageCount))
    _rotations = State(initialValue: Array(repeating: .degrees(0), count: imageCount))
  }

  var body: some View {
    Group {
      if isActive {
        Home()
      } else {
        splashContent
      }
    }
    .onAppear(perform: setTimer)
  }

  private var splashContent: some View {
    ZStack {
      ForEach(0..<imageCount, id: \.self) { number in
        SplashImage(number: number, rotation: rotations[number])
          .scaleEffect(scales[number])
          .opacity(opacities[number])
          .animation(.easeInOut(duration: splashDuration), value: scales[number])
          .animation(.easeInOut(duration: splashDuration), value: opacities[number])
          .animation(.easeInOut(duration: splashDuration), value: rotations[number])
      }
    }
  }

  private func setTimer() {
    withAnimation(.easeInOut(duration: splashDuration)) {
      for i in 0..<imageCount {
        scales[i] = CGFloat.random(in: 2...20)
        opacities[i] = 0  // フェードアウト
        rotations[i] = .degrees(Double.random(in: -520...520))  // 180度から720度までランダムに回転
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
      withAnimation {
        self.isActive = true
      }
    }
  }
}

#Preview {
  SplashScreen()
}
