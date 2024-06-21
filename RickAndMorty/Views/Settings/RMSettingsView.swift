//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 11/06/2024.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel
    
    let strings = ["A", "B", "C"]
    
    var body: some View {
        
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.red)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.bottom, 5)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
            
        }
    }
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    RMSettingsView(viewModel: .init(
        cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewViewModel(type: $0) { option in
                
            }
        })
    ))
}
