//
//  TimerViewModel.swift
//  VoiceMemo
//
//  Created by juni on 9/22/24.
//

import Foundation
import UIKit

class TimerViewModel: ObservableObject {
    @Published var isDisplaySetTimeView: Bool
    @Published var time: Time
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool
    var notificationService: NotificationService
    
    init(isDisplaySetTimeView: Bool = true,
         time: Time = .init(hours: 0, minutes: 0, seconds: 0),
         timer: Timer? = nil,
         timeRemaining: Int = 0,
         isPaused: Bool = false,
         notificationService: NotificationService = .init()) {
        self.isDisplaySetTimeView = isDisplaySetTimeView
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
        self.notificationService = notificationService
    }
}

extension TimerViewModel {
    func settingBtnTapped() {
        isDisplaySetTimeView = false
        timeRemaining = time.convertedSeconds
        startTimer()
    }
    
    func cancelBtnTapped() {
        stopTimer()
        isDisplaySetTimeView = true
    }
    
    func pauseOrRestartBtnTapped() {
        if isPaused {
            startTimer()
        } else {
            timer?.invalidate()
            timer = nil
        }
        isPaused.toggle()
    }
}

private extension TimerViewModel {
    func startTimer() { // 타이머 시작 메서드
        guard timer == nil else { return }
        
        var backgroundTaskID: UIBackgroundTaskIdentifier?
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { // 앱이 백그라운드로 전환되었을 때도 작업을 수행할 수 있게
            if let task = backgroundTaskID {
                UIApplication.shared.endBackgroundTask(task)
                backgroundTaskID = .invalid
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 { // 남은시간이 0초보다 클 때
                self.timeRemaining -= 1 // 1초씩 줄인다.
            } else { // 시간이 다 되었을 때
                self.stopTimer()
                self.notificationService.sendNotification()
                
                if let task = backgroundTaskID {
                    UIApplication.shared.endBackgroundTask(task)
                    backgroundTaskID = .invalid
                }
            }
        }
    }
    
    func stopTimer() { // 타이머 스탑 메서드
        timer?.invalidate()
        timer = nil
    }
}
