//
//  View+Navigation.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import SwiftUI

extension View {
    
    func navigation(
        title: String = "",
        displayMode: NavigationBarItem.TitleDisplayMode = .automatic,
        backgroundColor: Color = .clear
    ) -> some View {
        modifier(
            NavigationViewModifier(
                title: title,
                displayMode: displayMode,
                backgroundColor: backgroundColor
            )
        )
    }
    
    func addDismissToolbar() -> some View {
        modifier(DismissToolbarModifier())
    }

}
