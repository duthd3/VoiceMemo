//
//  OnboardingView.swift
//  VoiceMemo
//
//  Created by jun on 4/6/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()
    
    var body: some View {
        // TODO: - 화면 전환 구현 필요
 
        NavigationStack(path: $pathModel.paths) {
            OnboardingContentView(onboardingViewModel: onboardingViewModel)
                .navigationDestination(for: PathType.self, destination: { pathType in
                    switch pathType {
                    case .homeView:
                        HomeView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(todoListViewModel)
                            .environmentObject(memoListViewModel)
                    case .todoView:
                        TodoView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(todoListViewModel)
                    case let .memoView(isCreateMode, memo):
                        MemoView(
                            memoViewModel: isCreateMode ? .init(memo: .init(title: "", content: "", date: .now)) : .init(memo: memo ?? .init(title: "", content: "", date: .now)), isCreateMode: isCreateMode
                        )
                            .navigationBarBackButtonHidden()
                            .environmentObject(memoListViewModel)
                    }
                }
            )
        }
        .environmentObject(pathModel)
    }
}

// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 온보딩 셀리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            // 시작 버튼 뷰
            StartBtnView()
        }
        .ignoresSafeArea(.container)
    }
}


// MARK: - 온보딩 셀리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectionIndex: Int
    
    fileprivate init(onboardingViewModel: OnboardingViewModel, selectionIndex: Int = 0) {
        self.onboardingViewModel = onboardingViewModel
        self.selectionIndex = selectionIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectionIndex) {
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) {
                index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background(
            selectionIndex % 2 == 0 ? Color.customSky : Color.customGreen
        )
        .clipped()
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                        .frame(height: 5)
                    Text(onboardingContent.subtitle)
                        .font(.system(size: 16))
                }
                Spacer()
            }
            .background(Color.customWhite)
            .cornerRadius(0)
        }
        .shadow(radius: 10)
    }
}

// MARK: - 시작하기 버튼 뷰
private struct StartBtnView: View{
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        Button(action: { pathModel.paths.append(.homeView)},
               label: {
            HStack(spacing: 0) {
                Text("시작하기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.key)
       
                Image("arrow")
                    .renderingMode(.template)
                    .foregroundStyle(.key)
            }
        })
        .padding(.bottom, 50)
    }
}

#Preview {
    OnboardingView()
}
