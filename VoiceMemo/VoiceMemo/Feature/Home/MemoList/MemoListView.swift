//
//  MemoListView.swift
//  VoiceMemo
//
//  Created by juni on 9/8/24.
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel // 전역으로 사용
    @EnvironmentObject private var homeViewModel: HomeViewModel
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 메모가 있을 경우
                if !memoListViewModel.memos.isEmpty {
                    CustomNavigationBar(isDisplayLeftBtn: false,
                                        rightBtnAction: {
                        memoListViewModel.navigationRightBtnTapped()
                    },
                                        rightBtnType: memoListViewModel.navigationBarRightBtnMode)
                } else { // 메모가 없을경우
                    Spacer()
                        .frame(height: 30)
                }
                // 타이틀 뷰
                TitleView()
                    .padding(.top, 20)
                
                if memoListViewModel.memos.isEmpty {
                    AnnouncementView()
                } else {
                    // 메모리스트 컨텐츠 뷰
                    MemoListContentView()
                        .padding(.top, 20)
                }

             
                Spacer()
            }
            // 메모작성 플로팅 아이콘 버튼 뷰
            WriteMemoButtonView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?", isPresented: $memoListViewModel.isDisplayRemoveMemoAlert
        ) {
            Button("삭제", role: .destructive) {
                memoListViewModel.removeBtnTapped()
            }
            Button("취소", role: .cancel) {
                
            }
        }
        .onChange(of: memoListViewModel.memos, perform: { memos in
            homeViewModel.setMemosCount(memos.count)
        })
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    fileprivate var body: some View {
        HStack(spacing: 0) {
            if memoListViewModel.memos.isEmpty { // 메모가 비어있을 경우
                Text("메모를\n추가해보세요")
            } else {
                Text("메모\(memoListViewModel.memos.count)개가\n있습니다")
            }
            
            Spacer()
        }
        .font(.system(size: 26, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - 메모없을 경우 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Image("pencil")
            Text("\"퇴근 9시간 전 메모\"")
            Text("\"기획서 작성 후 퇴근하기 메모\"")
            Text("\"밀린 집안일 하기 메모\"")
            
        }
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(Color.customGray2)
    }
}

// MARK: - 메모 리스트 컨텐츠 뷰
private struct MemoListContentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    fileprivate var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("메모목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                    .padding(.bottom, 20)
                Spacer()
            }
          
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(memoListViewModel.memos, id: \.self) { memo in
                        // 메모 셀 뷰 호출
                        MemoCellView(memo: memo)
                    }
                }
            }
        }
    }
}

private struct MemoCellView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool
    
    private var memo: Memo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        memo: Memo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button {
            pathModel.paths.append(.memoView(isCreateMode: false, memo: memo))
            
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(memo.title)")
                            .lineLimit(1)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.customBlack)
                        
                        Text("\(memo.convertedDate)")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.customIconGray)
                    }
                    
                    Spacer()
                    if memoListViewModel.isEditMemoMode {
                        Button {
                            isRemoveSelected.toggle()
                            memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                        } label: {
                            isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
            }
        }
    }
}

// MARK: - 메모 작성 버튼 뷰
private struct WriteMemoButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Button {
                    pathModel.paths.append(.memoView(isCreateMode: true, memo: nil))
                } label: {
                    Image("writeBtn")
                }

            }
        }
    }
}

#Preview {
    MemoListView()
        .environmentObject(PathModel())
        .environmentObject(MemoListViewModel())
}
