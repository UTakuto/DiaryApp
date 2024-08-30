//
//  PrimaryBtn.swift
//  Diary
//
//  Created by 本田有人 on 2024/08/31.
//

import SwiftUI

struct PrimaryBtn: View {
  let imageName: String

  var body: some View {
    ZStack {
      ZStack {
        HexagonShape()
          .stroke(Color("mainColor"), lineWidth: 0.5)
          .frame(width: 50, height: 44)

        HexagonShape()
          .fill(Color.white)
          .overlay(
            HexagonShape()
              .stroke(Color("mainColor"), lineWidth: 2.5)
          )
          .frame(width: 42, height: 36)
      }
      Image(imageName)
    }
  }
}

#Preview {
  PrimaryBtn(imageName: "1")
}
