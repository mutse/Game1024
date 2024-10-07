//
//  GameView.swift
//  Game1024
//
//  Created by Mutse Yang on 7/10/24.
//

import SwiftUI

struct GameView: View {
    @State private var game = GameModel()
    @State private var isGameOver = false
    @State private var isSettingsPresented = false
    @FocusState private var isBoardFocused: Bool
    
    var body: some View {
        VStack {
            Text("Score: \(game.score)")
                .font(.title)
                .padding()
            
            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                ForEach(0..<game.size, id: \.self) { row in
                    GridRow {
                        ForEach(0..<game.size, id: \.self) { col in
                            TileView(value: game.board[row][col])
                        }
                    }
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .focusable()
            .focused($isBoardFocused)
            .onMoveCommand { direction in
                move(direction)
            }
            
            HStack {
                Button("New Game") {
                    startNewGame()
                }
                
                Spacer()
                
                Button("About") {
                    isSettingsPresented = true
                }
            }
            .padding()
        }
        .onAppear {
            isBoardFocused = true
        }
        .alert("Game Over", isPresented: $isGameOver) {
            Button("New Game", action: startNewGame)
        } message: {
            Text("Your score: \(game.score)")
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView()
        }
    }
    
  private func move(_ direction: MoveCommandDirection) {
        let gameDirection: MoveDirection
        switch direction {
        case .up:
            gameDirection = .up
        case .down:
            gameDirection = .down
        case .left:
            gameDirection = .left
        case .right:
            gameDirection = .right
        @unknown default:
            return
        }
        
        if game.move(gameDirection) {
            if game.isGameOver() {
                isGameOver = true
            }
        }
    }
    
    private func startNewGame() {
        game = GameModel()
        isGameOver = false
    }
}

struct SettingsView: View {
    let version = "1.0.0" // 您可以根据实际版本号进行修改
    let repo = "https://github.com/mutse/Game1024.git"
    
    var body: some View {
        VStack {
            Image("Image")
              .padding()

            Text("1024 Game")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Version: \(version)")
                .font(.title3)
            
            Text("A simple and addictive number puzzle game.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Github: \(repo)")
                .font(.title3)
                .padding()
            
            Text("© 2024 Orange Cat. All rights reversed.")
                .font(.footnote)
              
            Spacer()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
