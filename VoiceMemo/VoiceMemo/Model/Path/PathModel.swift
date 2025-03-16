//
//  PathModel.swift
//  VoiceMemo
//
//  Created by jun on 4/23/24.
//

import Foundation

class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
