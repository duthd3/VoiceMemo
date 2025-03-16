//
//  MemoView.swift
//  VoiceMemo
//
//  Created by jun on 4/23/24.
//

import SwiftUI

struct MemoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject var memoViewModel = MemoViewModel(memo: .init(title: "", content: "", date: Date()))
    @State var isCreateMode: Bool = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(
                    leftBtnAction: { // 뒤로가기
                        pathModel.paths.removeLast()
                    },
                    rightBtnAction: {
                        if isCreateMode {
                            memoListViewModel.addMemo(memoViewModel.memo)
                        } else {
                            memoListViewModel.updateMemo(memoViewModel.memo)
                        }
                        pathModel.paths.removeLast()
                    }
                    ,rightBtnType: isCreateMode ? .create : .complete
                )
                // 메모 타이틀 인풋 뷰
                MemoTitleInputView(memoViewModel: memoViewModel, isCreateMode: $isCreateMode)
                    .padding(.top, 20)
                // 메모 컨텐츠 인풋 뷰
                MemoContentInputView(memoViewModel: memoViewModel)
                    .padding(.top, 10)
            }
            if !isCreateMode {
                // 삭제 플로팅 버튼 뷰
                RemoveMemoBtnView(memoViewModel: memoViewModel)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - 메모 타이틀 인풋 뷰
private struct MemoTitleInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFieldFocus: Bool
    @Binding private var isCreateMode: Bool
    
    fileprivate init(memoViewModel: MemoViewModel, isCreateMode: Binding<Bool>) {
        self.memoViewModel = memoViewModel
        self._isCreateMode = isCreateMode
    }
    
    fileprivate var body: some View {
        TextField(
            "제목을 입력하세요.",
            text: $memoViewModel.memo.title
        )
        .font(.system(size: 30))
        .padding(.horizontal, 20)
        .focused($isTitleFieldFocus)
        .onAppear {
            if isCreateMode {
                isTitleFieldFocus = true
            }
        }
    }
}

// MARK: - 메모 컨텐츠 인풋 뷰
private struct MemoContentInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 20))
            
            if memoViewModel.memo.content.isEmpty {
                Text("메모를 입력하세요.")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.customGray1)
                    .allowsHitTesting(false) // 터치 인식 못하게 해서 TextEditor가 터치가 되도록
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 삭제 플로팅 버튼
private struct RemoveMemoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Button(action: {
                    memoListViewModel.removeMemo(memoViewModel.memo)
                    pathModel.paths.removeLast()
                }, label: {
                    Image("trash")
                        .resizable()
                        .frame(width: 40, height: 40)
                })
            }
        }
    }
}

#Preview {
    MemoView(memoViewModel: .init(memo:
            .init(title: "",
                  content: "",
                  date: Date())))
}
