import SwiftUI

// home画面デザイン
struct Home: View {
    // アクセントカラー設定
    @State private var accentColor = Color(red: 0/255, green: 130/255, blue: 153/255)
    // DateViewをStateObjectとして使用
    @StateObject private var viewModel = DateView()
    // キャラクター 初期位置は0
    @State private var offsetY: CGFloat = 0
    // 画像の移動方向を管理するプロパティ
    @State private var movingDown = true
    // タイマーを使ってアニメーションを制御 （2秒ごとにトリガーされる）
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    @State var path = [String]()
    // 画面遷移の時に使用するbool値
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色設定
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 70)
                    TabView {
                        // First screen - 1日前の日付を表示
                        SlideView(imageName: "cola2", dateDigits: viewModel.getPreviousDateDigits())
                            .tag(0)
                        
                        // Second screen - 現在の日付を表示
                        SlideView(imageName: "soda5", dateDigits: viewModel.getDateDigits())
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    Spacer().frame(height: 80)
                    
                    // キャラクター
                    Image("character")
                        .resizable()
                        .frame(width: 270, height: 200)
                        .offset(y: offsetY)  // y軸のオフセットを適用
                        .onReceive(timer) { _ in
                            // タイマーが発火するたびにアニメーションをトリガー
                            withAnimation(.easeInOut(duration: 2)) {  // アニメーションの持続時間を設定
                                if movingDown {
                                    offsetY = 5
                                } else {
                                    offsetY = -20
                                }
                                movingDown.toggle()  // 次のアニメーションで逆方向に移動するように切り替える
                            }
                        }
                    
                    Spacer().frame(height: 80)
                    
                    // メニューバー設定
                    ZStack {
                        Image("menuber")
                        HStack {
                            Button {
                                print("profileが押されたよ")
                                isPresented = true // trueにしないと画面遷移されない
                            } label: {
                                Image("profile")
                            }.fullScreenCover(isPresented: $isPresented) {
                                // Profile() // フルスクリーンの画面遷移
                            }
                            
                            Button {
                                print("listが押されたよ")
                                isPresented = true
                            } label: {
                                Image("list")
                                    .padding(.horizontal, 30)
                            }.fullScreenCover(isPresented: $isPresented) {
                                // List()
                            }
                            
                            Button {
                                print("inputが押されたよ")
                                isPresented = true
                            } label: {
                                Image("input")
                            }.fullScreenCover(isPresented: $isPresented) {
                                Input()
                            }
                            
                        }
                    }
                    
                    Spacer().frame(height: 80)
                }
            }
        }
    }
    
    // 三角形設定
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

struct SlideView: View {
    var imageName: String
    var dateDigits: [String]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 日付表示を上に
                HStack(spacing: 0) {
                    ForEach(dateDigits, id: \.self) { character in
                        if let _ = Int(character) {
                            Image(character)  // アセットに対応する画像を読み込む（例：0.svg〜9.svg）
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        } else {
                            Text(character)
                                .font(.system(size: 30, weight: .light))
                                .foregroundColor(.blue) // 文字色を青に設定
                        }
                    }
                }
                .padding(.top, geometry.size.height * 0.1)
                
                Spacer()
                
                // 画像表示を中央に
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                
                Spacer()
            }
        }
    }
}

// 日付設定
class DateView: ObservableObject {
    @Published var currentDate = Date()
    private var timer: Timer?
    
    init() {
        updateToNextDate()
    }
    
    private func updateToNextDate() {
        let calendar = Calendar.current
        if let nextMidnight = calendar.nextDate(after: currentDate, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) {
            let interval = nextMidnight.timeIntervalSinceNow
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
                self?.currentDate = Date()
                self?.updateToNextDate()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func getDateDigits() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        let dateString = formatter.string(from: currentDate)
        return Array(dateString).map { String($0) }
    }
    
    func getPreviousDateDigits() -> [String] {
        let calendar = Calendar.current
        if let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "M.d"
            let dateString = formatter.string(from: previousDate)
            return Array(dateString).map { String($0) }
        }
        return []
    }
}

#Preview {
    Home()
}
