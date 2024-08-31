//
//  ContentView.swift
//  Diary
//
//  Created by 上森拓翔 on 2024/08/28.
//

import SwiftUI

//日付設定
class DateView: ObservableObject {
  // 現在の日付を保持するPublishedプロパティ
  @Published var currentDate = Date()

  // タイマーオブジェクト
  private var timer: Timer?

  init() {
    // ViewModelの初期化時に次の日付更新を設定
    updateToNextDate()
  }

  // 次の日付の00:00に更新をかけるためのメソッド
  private func updateToNextDate() {
    // 現在のカレンダーを使用して、次の00:00を計算
    let calendar = Calendar.current
    if let nextMidnight = calendar.nextDate(
      after: currentDate, matching: DateComponents(hour: 0, minute: 0, second: 0),
      matchingPolicy: .nextTime)
    {
      // 次の00:00に達するまでの秒数を計算
      let interval = nextMidnight.timeIntervalSinceNow
      // 計算した秒数後に一度だけトリガーされるタイマーを設定
      timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
        self?.currentDate = Date()  // 日付を更新
        self?.updateToNextDate()  // 次の日付更新を再設定
      }
    }

  }

  // ViewModelが解放される際にタイマーを無効化
  deinit {
    timer?.invalidate()
  }

  // 現在の日付を "M.d" フォーマットに変換し、文字ごとに分割して返すメソッド
  func getDateDigits() -> [String] {
    let formatter = DateFormatter()
    formatter.dateFormat = "M.d"  // 日付フォーマットを月.日の形式に設定
    let dateString = formatter.string(from: currentDate)  // 日付を文字列に変換
    return Array(dateString).map { String($0) }  // 文字列を1文字ずつ分割して配列で返す
  }
}

//home画面デザイン
struct Home: View {
  //アクセントカラー設定
  @State private var accentColor = Color(red: 0 / 255, green: 130 / 255, blue: 153 / 255)
  // DateViewをStateObjectとして使用
  @StateObject private var viewModel = DateView()
  //キャラクター 初期位置は0
  @State private var offsetY: CGFloat = 0
  // 画像の移動方向を管理するプロパティ
  @State private var movingDown = true
  // タイマーを使ってアニメーションを制御 （2秒ごとにトリガーされる）
  let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

  @State var path = [String]()
  //画面遷移の時に使用するbool値
  @State private var isPresented: Bool = false

  var body: some View {
    NavigationStack(path: $path) {
      ZStack {
        //背景色設定
        Image("background")
          .resizable()
          .scaledToFill()
          .ignoresSafeArea()

        VStack {
          Spacer().frame(height: 70)
          VStack(spacing: 0) {
            HStack(spacing: 0) {  // 水平方向に要素を並べるHStack
              // 現在の日付を文字列にして、それぞれの文字を対応するビューに変換
              ForEach(viewModel.getDateDigits(), id: \.self) { character in
                if let _ = Int(character) {
                  // 数字である場合、その数字に対応する画像を表示
                  Image(character)  // アセットに数字の画像 (0.svg〜9.svg) を配置していることが前提
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)  // 画像のサイズを調整
                } else {
                  // 数字でない文字（例: ピリオド ".")の場合、テキストで表示
                  Text(character)
                    .font(.system(size: 30, weight: .light))  // フォントサイズとスタイルの設定
                    .foregroundColor(accentColor)  // 文字色の設定
                }
              }
            }
            //ドリンク画面
            HStack(alignment: .bottom) {

              Image("cola")
              VStack {
                Spacer().frame(height: 5)
                triangleView(accentColor: accentColor, rotation: 90)
                Spacer().frame(height: 50)
              }
              Image("soda")
                .resizable()
                .frame(width: 80, height: 130)

              VStack {
                Spacer().frame(height: 5)
                triangleView(accentColor: accentColor, rotation: 90)
                Spacer().frame(height: 50)
              }
              Spacer().frame(width: 70)
            }
          }

          Spacer().frame(height: 80)

          //キャラクター
          CharacterView()

          Spacer().frame(height: 80)

          //メニューバー設定

          ZStack {
            Image("menuber")
            HStack {
              NavigationLink(destination: Input()) {
                Image("profile")
              }

              NavigationLink(destination: Input()) {
                Image("list")
                  .padding(.horizontal, 30)
              }

              NavigationLink(destination: Input()) {
                Image("input")
              }
            }
          }

          Spacer()
        }
      }
    }

  }

  //三角形設定
  struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
      Path { path in
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
      }
    }
  }

  func triangleView(accentColor: Color, rotation: Double) -> some View {
    Triangle()
      .fill(accentColor)
      .frame(width: 10, height: 10)
      .rotationEffect(.degrees(rotation))
      .padding(.top, 10)
  }
}

#Preview {
  Home()
}
