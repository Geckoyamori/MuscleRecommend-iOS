//
//  TrainingMenuView.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/08/15.
//

import SwiftUI
import RealmSwift

// D-001:筋トレメニューのビュー
struct TrainingMenuView: View {
    // 筋トレメニューのビューモデル
    @ObservedObject private var trainingMenuViewModel = TrainingMenuViewModel()
    // 筋トレメニュー追加ポップアップの表示フラグ
    @State private var isAddMenuAlertPresented = false
    
    var body: some View {
        NavigationView {
            List {
                // 筋トレメニューidを識別IDとしてリストを作成
                ForEach(trainingMenuViewModel.trainingMenus, id: \.trainingMenuId) { trainingMenuModel in
                    // 筋トレメニュー押下時に、D-002に遷移（引数：筋トレメニューID）
                    NavigationLink(destination: NavigationLazyView(TrainingRecordHistoryView(trainingMenuId: trainingMenuModel.trainingMenuId))) {
                        Text(trainingMenuModel.trainingMenuName)
                    }
                }
                // リスト削除処理
                .onDelete(perform: rowRemove)
            }
            .listStyle(PlainListStyle())
            // ナビゲーションバーの設定
            .navigationBarTitle("筋トレメニュー", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    isAddMenuAlertPresented = true
                }) {
                    Image(systemName: "plus")
                })
        }
        // 追加するボタン押下時に筋トレメニュー追加ポップアップを表示
        .alert(isPresented: $isAddMenuAlertPresented,
               TextAlert(
                title: "筋トレメニューの追加",
                message: "追加する筋トレメニューを入力してください。",
                accept: "OK",
                cancel: "キャンセル") { result in
                if let inputText = result {
                    trainingMenuViewModel.addTrainingMenu(trainingMenuName: inputText)
                } 
               })
    }
    
    init() {
        // TODO:Realmファイルを表示するための処理
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func rowRemove(offsets: IndexSet) {
        if let index = offsets.first {
            trainingMenuViewModel.deleteTrainingMenu(trainingMenuModel: trainingMenuViewModel.trainingMenus[index])
        }
    }
}

struct TrainingMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingMenuView()
    }
}
