//
//  HexagonShape.swift
//  Diary
//
//  Created by 本田有人 on 2024/08/31.
//

import SwiftUI

struct HexagonShape: Shape {
  func path(in rect: CGRect) -> Path {
    let width = rect.size.width
    let height = rect.size.height
    let centerX = rect.midX
    let centerY = rect.midY

    let radius = min(width, height) / 2
    let angle = 60.0 * (Double.pi / 180.0)

    var path = Path()

    for i in 0..<6 {
      let x = centerX + radius * CGFloat(cos(angle * Double(i)))
      let y = centerY + radius * CGFloat(sin(angle * Double(i)))
      if i == 0 {
        path.move(to: CGPoint(x: x, y: y))
      } else {
        path.addLine(to: CGPoint(x: x, y: y))
      }
    }

    path.closeSubpath()

    return path
  }
}

#Preview {
    HexagonShape()
}
