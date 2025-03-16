//
//  VoiceRecorderView.swift
//  VoiceMemo
//
//  Created by juni on 9/16/24.
//

import SwiftUI

struct VoiceRecorderView: View {
    @StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 타이틀 뷰
                TitleView()
                // 안내 뷰
                if voiceRecorderViewModel.recordedFiles.isEmpty {
                    AnnouncementView()
                } else {
                    // 보이스 리코더 리스트 뷰
                    VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
                        .padding(.top, 15)
                }
                Spacer()
            }
            // 녹음 버튼 뷰
            RecordBtnView(voiceRecorderViewModel: voiceRecorderViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "선택된 음성메모를 삭제하시겠습니까?", isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecorderAlert
        ) {
            Button("삭제", role: .destructive) {
                voiceRecorderViewModel.removeSelectedVoiceRecord()
            }
            Button("취소", role: .cancel) {
                
            }
        }
        .alert(
            voiceRecorderViewModel.errorAlertMessage, isPresented: $voiceRecorderViewModel.isDisplayErrorAlert
        ) {
            Button("확인", role: .cancel) { }
        }
        .onChange(of: voiceRecorderViewModel.recordedFiles, perform: { recordedFiles in
            homeViewModel.setVoiceRecorderCount(recordedFiles.count)
        })
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack(spacing: 0) {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.customBlack)
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 음성메모 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Image("pencil")
                .padding(.bottom, 8)
            Text("현재 등록된 음성메모가 없습니다.")
            Text("하단의 녹음버튼을 눌러 음성 메모를 시작해주세요.")
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.gray2)
    }
}

// MARK: - 음성메모 리스트 뷰
private struct VoiceRecorderListView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.customGray2)
                    .frame(height: 1)
                    .padding(.bottom ,10)
                ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordedFile in
                    // 음성메모 셀 뷰 호출
                    VoiceRecorderCellView(voiceRecorderViewModel: voiceRecorderViewModel, recordedFile: recordedFile)
                }
            }
        }
    }
}

// MARK: - 음성메모 셀 뷰
private struct VoiceRecorderCellView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progressBarValue: Float {
        if voiceRecorderViewModel.selectedRecordFile == recordedFile && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel, recordedFile: URL) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            Button {
                voiceRecorderViewModel.voiceRecorderCellTapped(recordedFile)
            } label: {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(recordedFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.customBlack)
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 5)
                    HStack(spacing: 0) {
                        if let creationDate = creationDate {
                            Text(creationDate.formattedVoiceRecorderTime)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.customIconGray)
                        }
                        Spacer()
                        if voiceRecorderViewModel.selectedRecordFile != recordedFile, let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.customIconGray)
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            
            if voiceRecorderViewModel.selectedRecordFile == recordedFile { // 녹음파일을 클릭 했을 때
                VStack(spacing: 0) {
                    // 프로그래스 바
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                        .padding(.top, 10)
                    Spacer()
                        .frame(height: 5)
                    
                    HStack(spacing: 0) {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color.customIconGray)
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size:10, weight: .medium))
                                .foregroundStyle(Color.customIconGray)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            if voiceRecorderViewModel.isPaused { // 정지된 상태라면
                                voiceRecorderViewModel.resumePlaying() // 플레이버튼
                            } else { // 시작이 안되어 있을 경우
                                voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        }, label: {
                            Image("play")
                                .renderingMode(.template)
                                .foregroundStyle(Color.customBlack)
                        })
                        Spacer()
                            .frame(width: 10)
                        Button {
                            if voiceRecorderViewModel.isPlaying {
                                voiceRecorderViewModel.pausePlaying()
                            }
                        } label: {
                            Image("pause")
                                .renderingMode(.template)
                                .foregroundStyle(Color.customBlack)
                        }
                        Spacer()
                        Button(action: {
                            voiceRecorderViewModel.removeBtnTapped()
                        }, label: {
                            Image("trash")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width:30, height: 30)
                                .foregroundStyle(Color.customBlack)
                        }
                        )

                    }
             
                }
                .padding(.horizontal, 20)
                
        
            }
            Rectangle()
                .fill(Color.customGray2)
                .frame(height: 1)
                .padding(.top, 10)
                .padding(.bottom, 10)
        }
    }
}

// MARK: - 프로그레스 바
private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.customGray2)
                Rectangle()
                    .fill(Color.customGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

// MARK: - 녹음 버튼 뷰
private struct RecordBtnView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    @State private var isAnimation: Bool
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel, isAnimation: Bool = false) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.isAnimation = isAnimation
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: {
                        voiceRecorderViewModel.recordBtnTapped()
                    }, label: {
                        if voiceRecorderViewModel.isRecording {
                            Image("mic_recording")
                                .scaleEffect(isAnimation ? 1.5 : 1)
                                .onAppear {
                                    withAnimation(.spring().repeatForever()) {
                                        isAnimation.toggle()
                                    }
                                }
                                .onDisappear {
                                    isAnimation = false
                                }
                        } else {
                            Image("mic")
                        }
                  
                    })
                }
            }
        }
    }
}

#Preview {
    VoiceRecorderView()
}
