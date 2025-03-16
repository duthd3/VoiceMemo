//
//  OnboardingContent.swift
//  VoiceMemo
//
//  Created by jun on 4/6/24.
//

import Foundation

struct OnboardingContent: Hashable {
    var imageFileName: String
    var title: String
    var subtitle: String
    
    init(imageFileName: String, title: String, subtitle: String) {
        self.imageFileName = imageFileName
        self.title = title
        self.subtitle = subtitle
    }
    
}
