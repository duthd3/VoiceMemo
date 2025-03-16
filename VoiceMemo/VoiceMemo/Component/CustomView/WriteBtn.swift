//
//  WriteBtn.swift
//  VoiceMemo
//
//  Created by juni on 10/3/24.
//

import SwiftUI

public struct WriteBtnViewModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: action, label: {Image("writeBtn")})
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}
