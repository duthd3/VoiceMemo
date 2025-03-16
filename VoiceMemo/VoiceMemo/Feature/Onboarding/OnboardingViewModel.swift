//
//  OnboardingViewModel.swift
//  VoiceMemo
//
//  Created by jun on 4/6/24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContent]
    init(onboardingContents: [OnboardingContent] = [
        .init(imageFileName: "onboarding_1", title: "오늘의 할일", subtitle: "To do list로 언제 어디서든 해야할일을 한눈에"),
        .init(imageFileName: "onboarding_1", title: "오늘의 할일", subtitle: "메모장으로 생각나는 기록은 언제든지"),
        .init(imageFileName: "onboarding_1", title: "오늘의 할일", subtitle: "음성메모 기능으로 놓치고 싶지않은 기록까지"),
        .init(imageFileName: "onboarding_1", title: "오늘의 할일", subtitle: "타이머 기능으로 원하는 시간을 확인"),
    ]
    
    ) {
        self.onboardingContents = onboardingContents
    }
}
