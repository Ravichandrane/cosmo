//
//  DiscoveryDetailView.swift
//  Cosmo
//
//  Created by Ravi Rajendran on 05/04/2023.
//

import SwiftUI

struct DiscoveryDetailView: View {
    // Properties
    private let viewModel: DiscoveryDetailViewModel
    
    // Initializer
    init(viewModel: DiscoveryDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // Body
    var body: some View {
        List {
            Section(content: {
                ForEach(viewModel.characteristics, id: \.self) { value in
                    Text(value)
                }
            }, header: {
                Text(L10n.DiscoveryDetail.Section.Title.characteristics)
            })
        }
    }
}
