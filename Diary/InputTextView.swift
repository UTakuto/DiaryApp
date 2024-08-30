import SwiftUI

struct TextInputView: View {
    @Binding var userInput: String
    let onSend: () -> Void
    let accentColor: Color
    let buttonImageName: String // ボタンに使う画像の名前

    var body: some View {
        HStack {
            TextField("ここに返信を入力", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing, 10)
            
            Button(action: {
                onSend() // 送信ボタンが押されたときのアクション
            }) {
                // ボタンの画像を表示
                Image("send")
                    .resizable()
                    .frame(width:40 , height: 40) // 必要に応じてサイズを調整
                    .padding(0)
                    .background(accentColor)
                    .cornerRadius(5)
                    .border(Color.gray)
            }
        }
        .padding()
    }
}

#Preview {
    TextInputView(
        userInput: .constant(""),
        onSend: { print("送信ボタンが押されました") },
        accentColor: Color(red: 0/255, green: 130/255, blue: 153/255),
        buttonImageName: "send-button" // 使用する画像の名前を指定
    )
}
