//
//  DismissToolbarModifier.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import SwiftUI

struct DismissToolbarModifier: ViewModifier {
    @Environment(\.presentationMode) private var presentationMode
    
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(
                placement: .navigationBarLeading,
                content: {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: Asset.chevronDown.rawValue)
                            .foregroundColor(Color.black)
                    })
                }
            )
        }
    }
}
