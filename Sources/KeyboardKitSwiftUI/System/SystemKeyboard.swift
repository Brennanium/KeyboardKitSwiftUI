//
//  SystemKeyboard.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-02.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import SwiftUI

/**
 This view mimics native system keyboards, like the standard
 alphabetic, numeric and symbolic keyboards.
 
 You can provide the keyboard with a `KeyboardLayout` and it
 will convert the layout actions to buttons. You can provide
 a custom `buttonBuilder`. By default, `SystemKeyboardButton`
 views will be generated.
 */
public struct SystemKeyboard: View {
    
    public init(
        layout: KeyboardLayout,
        buttonBuilder: @escaping ButtonBuilder = standardButtonBuilder) {
        self.rows = layout.actionRows
        self.buttonBuilder = buttonBuilder
    }
    
    private let buttonBuilder: ButtonBuilder
    private let rows: KeyboardActionRows
    
    public typealias ButtonBuilder = (KeyboardAction) -> AnyView
    
    @EnvironmentObject private var style: SystemKeyboardStyle
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(rows.enumerated().map { $0 }, id: \.offset) {
                row(at: $0.offset, actions: $0.element)
            }
        }
    }
}

public extension SystemKeyboard {

    /**
     This is the standard `buttonBuilder`, that will be used
     when no custom builder is provided to the view.
     */
    static func standardButtonBuilder(action: KeyboardAction) -> AnyView {
        AnyView(SystemKeyboardButtonRowItem(action: action))
    }
}


private extension SystemKeyboard {
    
    func row(at index: Int, actions: KeyboardActionRow) -> some View {
        HStack(spacing: 0) {
            rowEdgeSpacer(at: index)
            ForEach(Array(actions.enumerated()), id: \.offset) {
                buttonBuilder($0.element)
            }
            rowEdgeSpacer(at: index)
        }
    }
    
    @ViewBuilder
    func rowEdgeSpacer(at index: Int) -> some View {
        if index == 1 {
            Spacer(minLength: secondRowPadding)
        } else {
            EmptyView()
        }
    }
    
    /**
     A temp. way to get side padding on each side on English
     iPhone keyboards.
     */
    var secondRowPadding: CGFloat {
        guard Locale.current.identifier.starts(with: "en") else { return 0 }
        return max(0, 20 * CGFloat(rows[0].count - rows[1].count))
    }
}
