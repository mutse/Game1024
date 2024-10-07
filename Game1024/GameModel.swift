//
//  GameModel.swift
//  Game1024
//
//  Created by Mutse Yang on 7/10/24.
//

import Foundation

struct GameModel {
    private(set) var board: [[Int]]
    private(set) var score: Int = 0
    let size: Int
    
    init(size: Int = 4) {
        self.size = size
        self.board = Array(repeating: Array(repeating: 0, count: size), count: size)
        addNewTile()
        addNewTile()
    }
    
    mutating func move(_ direction: MoveDirection) -> Bool {
        let originalBoard = board
        
        var moved = false
        switch direction {
        case .up:
            for col in 0..<size {
                moved = moveColumn(col, reverse: false) || moved
            }
        case .down:
            for col in 0..<size {
                moved = moveColumn(col, reverse: true) || moved
            }
        case .left:
            for row in 0..<size {
                moved = moveRow(row, reverse: false) || moved
            }
        case .right:
            for row in 0..<size {
                moved = moveRow(row, reverse: true) || moved
            }
        }
        
        if moved {
            addNewTile()
        }
        
        return board != originalBoard
    }
    
    private mutating func moveColumn(_ col: Int, reverse: Bool) -> Bool {
        var column = (0..<size).map { board[$0][col] }
        let (newColumn, points) = mergeLine(column, reverse: reverse)
        score += points
        
        var moved = false
        for row in 0..<size {
            if board[row][col] != newColumn[row] {
                board[row][col] = newColumn[row]
                moved = true
            }
        }
        return moved
    }
    
    private mutating func moveRow(_ row: Int, reverse: Bool) -> Bool {
        var line = board[row]
        let (newLine, points) = mergeLine(line, reverse: reverse)
        score += points
        
        var moved = false
        if board[row] != newLine {
            board[row] = newLine
            moved = true
        }
        return moved
    }
    
    private func mergeLine(_ line: [Int], reverse: Bool) -> ([Int], Int) {
        var newLine = line.filter { $0 != 0 }
        if reverse { newLine.reverse() }
        
        var points = 0
        var index = 0
        while index < newLine.count - 1 {
            if newLine[index] == newLine[index + 1] {
                newLine[index] *= 2
                points += newLine[index]
                newLine.remove(at: index + 1)
            }
            index += 1
        }
        
        while newLine.count < size {
            if reverse {
                newLine.insert(0, at: 0)
            } else {
                newLine.append(0)
            }
        }
        
        if reverse { newLine.reverse() }
        return (newLine, points)
    }
    
    mutating func addNewTile() {
        var emptyCells = [(Int, Int)]()
        for i in 0..<size {
            for j in 0..<size {
                if board[i][j] == 0 {
                    emptyCells.append((i, j))
                }
            }
        }
        
        guard let (row, col) = emptyCells.randomElement() else { return }
        board[row][col] = [2, 4].randomElement()!
    }
    
    func isGameOver() -> Bool {
        for i in 0..<size {
            for j in 0..<size {
                if board[i][j] == 0 {
                    return false
                }
                if i < size - 1 && board[i][j] == board[i + 1][j] {
                    return false
                }
                if j < size - 1 && board[i][j] == board[i][j + 1] {
                    return false
                }
            }
        }
        return true
    }
}

enum MoveDirection {
    case up, down, left, right
}
