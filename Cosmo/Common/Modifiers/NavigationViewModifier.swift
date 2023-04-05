//
//  NavigationViewModifier.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 04/04/2023.
//

import SwiftUI

struct NavigationViewModifier: ViewModifier {
    // Properties
    private var title: String
    private var displayMode: NavigationBarItem.TitleDisplayMode
    
    // MARK: - Initializer
    init(
        title: String = "",
        displayMode: NavigationBarItem.TitleDisplayMode,
        backgroundColor: Color
    ) {
        self.title = title
        self.displayMode = displayMode
        
        let standardAppearance = UINavigationBarAppearance()
        let scrollAppearance = UINavigationBarAppearance()
        
        standardAppearance.shadowColor = .clear
        standardAppearance.backgroundColor = UIColor(backgroundColor)
        
        scrollAppearance.backgroundColor = UIColor(backgroundColor)
        scrollAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = standardAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = scrollAppearance
    }
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(displayMode)
    }
}
