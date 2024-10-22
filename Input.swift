import SwiftUI

struct Input: View {
    @State private var accentColor = Color(red: 0 / 255, green: 130 / 255, blue: 153 / 255)
    @State private var offsetY: CGFloat = 0
    @State private var movingDown = true
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    @State private var userInput: String = ""
    @State private var currentMessage: String? = "今日はどんな1日だった？"  // 初期の質問
    @State private var showNextScreen = false  // 次の画面に遷移するためのフラグ
    @State private var showWhiteScreen = false  // 白い画面を表示するためのフラグ
    
    struct AnimationValues {
        var scale: CGFloat
    }
    
    var body: some View {
        NavigationStack {  // NavigationViewをNavigationStackに変更
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 235)
                    
                    Image("character")
                        .resizable()
                        .frame(width: 278, height: 200)
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
                    
                    Spacer().frame(height: 50)
                    
                    VStack {
                        ZStack {
                            Image("menuber")
                            
                            VStack {
                                if let message = currentMessage {
                                    Text(message)
                                        .padding()
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(10)
                                        .padding(.bottom, 10)
                                }
                            }
                            .padding()
                        }
                        
                        // TextInputViewをここで使用
                        TextInputView(
                            userInput: $userInput,
                            onSend: {
                                // ボタンが押されたときのアクション
                                if currentMessage == "今日はどんな1日だった？" {
                                    currentMessage = "それは楽しかったね。詳しく教えて。"  // 次の質問に更新
                                    userInput = ""  // 入力フィールドをクリア
                                } else if currentMessage == "それは楽しかったね。詳しく教えて。" {
                                    withAnimation(.easeInOut(duration: 1)) {  // 1秒かけて白い画面にフェードイン
                                        showWhiteScreen = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showNextScreen = true  // 1秒後に次の画面に遷移
                                    }
                                }
                            },
                            accentColor: accentColor,
                            buttonImageName: "send-button"
                        )
                    }
                    
                    Spacer()
                }
                
                // 白い画面をフェードインで表示
                if showWhiteScreen {
                    Color.white
                        .ignoresSafeArea()
                        .transition(.opacity)
                }
            }
            .navigationBarBackButtonHidden(true)
            .animation(.easeInOut(duration: 1), value: showWhiteScreen)
            .navigationDestination(isPresented: $showNextScreen) {
                CompleteView()
            }
        }
    }
    
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
    Input()
}
