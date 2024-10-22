//
//  pastDiary.swift
//  Diary
//
//  Created by Kodai Hirata on 2024/08/30.
//

import SwiftUI


struct TopRoundedCorners: Shape {
    var radius: CGFloat = 8.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: bottomLeft)
        path.addLine(to: topLeft)
        path.addArc(center: CGPoint(x: topLeft.x + radius, y: topLeft.y + radius),
                    radius: radius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        path.addLine(to: CGPoint(x: topRight.x - radius, y: topRight.y))
        path.addArc(center: CGPoint(x: topRight.x - radius, y: topRight.y + radius),
                    radius: radius,
                    startAngle: Angle(degrees: 270),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.addLine(to: bottomRight)
        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        path.closeSubpath()

        return path
    }
}

struct pastDiary: View {
    let diaryText = ["はな","この世はなぜ暑いのか","この素晴らしい景色に祝福を","参加賞"]
    let diaryDay = ["2024.08.26","2024.08.25","2024.08.24","2024.08.23"]
    let diaryExplanation = ["何と見事な花なのでしょう","このような暑い日になぜ外に出ないといけないのかわかりません","今日という日を忘れないためにここに刻もうと思います","近所の小学校で行われた運動会近くに寄ったら知らない子に"]
    let diaryDrink = ["cola","orange","cola","orange"]
    let Landscape = ["Landscape1","","sea",""]
    let drink = ["orange","cola","cola","orange"]
    
    @State private var inputSearch = ""
    @State private var selectedDrinkIndex: Int? = nil
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.gray)
                                .padding(.leading, 8)
                            
                            TextField("日付、キーワード", text: $inputSearch)
                                .fixedSize()
                                .onSubmit {
                                    print("入力された値: \(inputSearch)")
                            }
                            Spacer()
                        }
                        .frame(width: 328, height: 40)
                        .background(.white)
                        .clipShape( RoundedRectangle( cornerRadius:8))
                    }
                    HStack {
                        ForEach(drink.indices, id: \.self) { index in
                            HStack {
                                Image(drink[index])
                            }
                            .scaleEffect(CGSize(width: 1.2, height: 1.2))
                            .frame(width: 76,height: 70)
                            .offset(y: 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedDrinkIndex == index ? Color("mainColor") : Color.white)
                            )
                            .clipped()
                            .onTapGesture {
                                selectedDrinkIndex = index
                            }
                        }
                    }
                    .frame(width: 328,height: 70)
                }
                .padding(.top, 32)
                .padding(.bottom, 16)
                
                ScrollView {
                    ForEach(diaryText.indices, id: \.self) { index in
                        HStack {
                            GeometryReader { geometry in
                                VStack {
                                    if !Landscape[index].isEmpty {
                                        Image(Landscape[index])
                                            .frame(width: geometry.size.width, height: 110)
                                            .clipped()
                                            .clipShape(TopRoundedCorners(radius: 8))
                                    }
                                    HStack(spacing: 0) {
                                        Spacer()
                                        VStack(spacing: 4) {
                                            HStack {
                                                Text(diaryDay[index])
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 12))
                                                Spacer()
                                            }
                                            HStack {
                                                Text(diaryText[index])
                                                    .font(.system(size: 16))
                                                Spacer()
                                            }
                                            HStack {
                                                Text(diaryExplanation[index])
                                                    .font(.system(size: 10))
                                                    .lineLimit(1)
                                                Spacer()
                                            }
                                        }
                                        Spacer()
                                        VStack {
                                            Image(diaryDrink[index])
                                                .offset(y: 8)
                                                .frame(width: geometry.size.width / 4, height: 72)
                                                .clipped()
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: 328, height: Landscape[index].isEmpty ? 72 : 187)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                        )
                        .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 2)
                        .padding(.top, 6)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    pastDiary()
}
