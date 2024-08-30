//
//  pastDiary.swift
//  Diary
//
//  Created by Kodai Hirata on 2024/08/30.
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

struct pastDiary: View {
    @State private var inputSearch = ""
    let diaryText = ["これはテストです。","これはテストで","これはテス","これ"]
    let diaryDay = ["2024.08.26","2024.08.25","2024.08.24","2024.08.23"]
    let Landscape = ["Landscape1","","Landscape1",""]
    
    @State private var isFocused: Bool = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
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
                        .frame(width: 274, height: 40)
                        .background(.white)
                        .clipShape( RoundedRectangle( cornerRadius:8 ) )
                    }
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
                        
                        Image("Filters")
                    }
                }
                .padding(.top, 32)
                .padding(.bottom, 16)
                
                ScrollView {
                    ForEach(diaryText.indices, id: \.self) { index in
                        HStack {
                            GeometryReader { geometry in
                                VStack {
                                    if !Landscape[index].isEmpty {
                                        Image("Landscape1")
                                            .frame(width: geometry.size.width, height: 110)
                                            .clipped()
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
                                                Text("これはテストのてきすとです。表示がどのようにssssssssss")
                                                    .font(.system(size: 10))
                                                    .lineLimit(1)
                                                Spacer()
                                            }
                                        }
                                        Spacer()
                                        VStack {
                                            Image("orange")
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
