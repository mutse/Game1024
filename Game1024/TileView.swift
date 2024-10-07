//
//  TileView.swift
//  Game1024
//
//  Created by Mutse Yang on 7/10/24.
//

import SwiftUI

struct TileView: View {
    let value: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .cornerRadius(8)
            
            Text(value > 0 ? "\(value)" : "")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(foregroundColor)
        }
    }
    
    private var backgroundColor: Color {
        switch value {
        case 0: return .gray.opacity(0.1)
        case 2: return .yellow
        case 4: return .orange
        case 8: return .red
        case 16: return .pink
        case 32: return .purple
        case 64: return .blue
        case 128: return .green
        case 256: return .mint
        case 512: return .cyan
        default: return .indigo
        }
    }
    
    private var foregroundColor: Color {
        value <= 4 ? .black : .white
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(value: 1024)
            .frame(width: 100, height: 100)
    }
}
