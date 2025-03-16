//
//  MemoViewModel.swift
//  VoiceMemo
//
//  Created by juni on 9/8/24.
//

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
}
