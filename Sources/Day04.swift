import Algorithms

/*
--- Day 4: Printing Department ---

You ride the escalator down to the printing department. They're clearly getting ready for Christmas; they have lots of large rolls of paper everywhere, and there's even a massive printer in the corner (to handle the really big print jobs).

Decorating here will be easy: they can make their own decorations. What you really need is a way to get further into the North Pole base while the elevators are offline.

"Actually, maybe we can help with that," one of the Elves replies when you ask for help. "We're pretty sure there's a cafeteria on the other side of the back wall. If we could break through the wall, you'd be able to keep moving. It's too bad all of our forklifts are so busy moving those big rolls of paper around."

If you can optimize the work the forklifts are doing, maybe they would have time to spare to break through the wall.

The rolls of paper (@) are arranged on a large grid; the Elves even have a helpful diagram (your puzzle input) indicating where everything is located.

--- Part Two ---

Now, the Elves just need help accessing as much of the paper as they can.

Once a roll of paper can be accessed by a forklift, it can be removed. Once a roll of paper is removed, the forklifts might be able to access more rolls of paper, which they might also be able to remove. How many total rolls of paper could the Elves remove if they keep repeating this process?
*/

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Substring]] {
    data.split(separator: "\n").map {
      $0.split(separator: "")
    }
  }

  private func removableRolls(in entities: [[Substring]]) -> (modified: [[Substring]], count: Int) {
    var numberOfRolls = 0
    var removedIndex: [(Int, Int)] = []
    for (row, rolls) in entities.enumerated() {
      for (column, paper) in rolls.enumerated() {
        if paper == "." { continue }
        var numberOfEmptySet = 0
        // top
        if row == 0 {
          numberOfEmptySet += 1
        } else {
          numberOfEmptySet += (entities[row - 1][column] == "." ? 1 : 0)
        }
        // top-right
        if row == 0 || column == rolls.count - 1 {
          numberOfEmptySet += 1
        } else {
          numberOfEmptySet += (entities[row - 1][column + 1] == "." ? 1 : 0) 
        }
        // right
        if column == rolls.count - 1 {
          numberOfEmptySet += 1
        } else {
          numberOfEmptySet += (rolls[column + 1] == "." ? 1 : 0)  
        }
        // bottom-right
        if row == entities.count - 1 || column == rolls.count - 1 {
          numberOfEmptySet += 1
        } else {
          numberOfEmptySet += (entities[row + 1][column + 1] == "." ? 1 : 0) 
        }
        // bottom
        if row == entities.count - 1 {
          numberOfEmptySet += 1 
        } else {
          numberOfEmptySet += (entities[row + 1][column] == "." ? 1 : 0)  
        }
        if numberOfEmptySet > 4 { 
          removedIndex.append((row, column))
          numberOfRolls += 1
          continue
        }
        // bottom-left
        if row == entities.count - 1 || column == 0 {
          numberOfEmptySet += 1 
        } else {
          numberOfEmptySet += (entities[row + 1][column - 1] == "." ? 1 : 0)  
        }
        if numberOfEmptySet > 4 { 
          removedIndex.append((row, column))
          numberOfRolls += 1
          continue
        }
        // left
        if column == 0 {
          numberOfEmptySet += 1 
        } else {
          numberOfEmptySet += (rolls[column - 1] == "." ? 1 : 0)  
        }
        if numberOfEmptySet > 4 { 
          removedIndex.append((row, column))
          numberOfRolls += 1
          continue
        }
        // top-left
        if row == 0 || column == 0 {
          numberOfEmptySet += 1 
        } else {
          numberOfEmptySet += (entities[row - 1][column - 1] == "." ? 1 : 0)  
        }
        if numberOfEmptySet > 4 { 
          removedIndex.append((row, column))
          numberOfRolls += 1
          continue
        }
      }
    }

    var copied = entities
    if !removedIndex.isEmpty {
      for (row, column) in removedIndex {
        copied[row][column] = "."
      }
    }

    return (copied, numberOfRolls)
  }

  func part1() -> Any {
    return removableRolls(in: entities).count
  }

  func part2() -> Any {
    var numberOfRolls = 0
    var rolls = entities
    while true {
      let (copies, count) = removableRolls(in: rolls)
      if count > 0 {
        rolls = copies
        numberOfRolls += count
      } else {
        break
      }
    }
    return numberOfRolls
  }
}
