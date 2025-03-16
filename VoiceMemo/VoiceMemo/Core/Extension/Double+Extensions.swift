//
//  Double+Extensions.swift
//  VoiceMemo
//
//  Created by juni on 9/16/24.
//

import Foundation

extension Double {
    // 03:05
    var formattedTimeInterval: String {
        let totalSeconds = Int(self) // 전체 시간을 초로
        let seconds = totalSeconds % 60 // 초
        let minutes = (totalSeconds / 60) % 60 // 분
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
   
}
