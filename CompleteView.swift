//
//  CompleteView.swift
//  Diary
//
//  Created by 中川楓翔 on 2024/08/31.
//

import SwiftUI

struct CompleteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isHomeActive = false // 状態を管理する変数
    
    var body: some View {
        ZStack {
            // 背景
            Color(UIColor(red: 0.9, green: 0.98, blue: 1.0, alpha: 1.0)).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // ヘッダー
                Text("日記に追加されました!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding()
                
                // 日記カード
                VStack(alignment: .leading, spacing: 10) {
                    Text("2024.08.31")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.top, -250)
                    
                    Text("HackUに出場した日")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, -240)
                    
                    Text("今日はHackUに出場した。仲間とがんばった作品を外に発信できて、楽しかった。本当は東京に行くはずだったが、台風が来てしまったので、次の機会に期待したい。もし、次も出る機会があれば、タスク管理を頑張りたいと思った。")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .lineLimit(10)
                        .padding(.top, -210)
                }
                .padding()
                .frame(height: 600)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                
                Spacer()
                
                // 閉じるボタン
                Button(action: {
                    isHomeActive = true // ボタンが押されたらHomeに遷移する
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .navigationDestination(isPresented: $isHomeActive) {
                    Home() // ここに戻りたいHome画面を指定
                }
            }
            .padding()
        }
    }
}

struct DiaryEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteView()
    }
}
