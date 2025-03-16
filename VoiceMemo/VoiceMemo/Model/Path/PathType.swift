//
//  PathType.swift
//  VoiceMemo
//
//  Created by jun on 4/23/24.
//

import Foundation

// 패스 타입 설정
enum PathType: Hashable {
    case homeView
    case todoView
    case memoView(isCreateMode: Bool, memo: Memo?)
}
