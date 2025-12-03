import Algorithms

/*
--- Day 3: Lobby ---

You descend a short staircase, enter the surprisingly vast lobby, and are quickly cleared by the security checkpoint. When you get to the main elevators, however, you discover that each one has a red light above it: they're all offline.

"Sorry about that," an Elf apologizes as she tinkers with a nearby control panel. "Some kind of electrical surge seems to have fried them. I'll try to get them online soon."

You explain your need to get further underground. "Well, you could at least take the escalator down to the printing department, not that you'd get much further than that without the elevators working. That is, you could if the escalator weren't also offline."

"But, don't worry! It's not fried; it just needs power. Maybe you can get it running while I keep working on the elevators."

There are batteries nearby that can supply emergency power to the escalator for just such an occasion. The batteries are each labeled with their joltage rating, a value from 1 to 9. You make a note of their joltage ratings (your puzzle input).

--- Part Two ---

The escalator doesn't move. The Elf explains that it probably needs more joltage to overcome the static friction of the system and hits the big red "joltage limit safety override" button. You lose count of the number of times she needs to confirm "yes, I'm sure" and decorate the lobby a bit while you wait.

Now, you need to make the largest joltage by turning on exactly twelve batteries within each bank.

The joltage output for the bank is still the number formed by the digits of the batteries you've turned on; the only difference is that now there will be 12 digits in each bank's joltage output instead of two.
*/

private typealias Pair = (lower: String, upper: String)

struct Day03: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    private var banks: [[Int]] {
        data.split(separator: "\n").map { batteries in
            batteries.compactMap { Int("\($0)") }
        }
    }

    private func largestJoltage(batteries: [Int], digits: Int) -> Int {
        var startIndex = batteries.startIndex
        var numbers: [String] = []
        for off in (1...digits).reversed() {
            let maxNumber = batteries[startIndex...(batteries.endIndex - off)].max()!
            startIndex = batteries[startIndex...(batteries.endIndex - off)].firstIndex(of: maxNumber)! + 1
            numbers.append("\(maxNumber)")
        }
        return Int(numbers.joined())!
    }

    func part1() -> Any {
        banks.map { largestJoltage(batteries: $0, digits: 2) }
            .reduce(0, +)
    }

    func part2() -> Any {
        banks.map { largestJoltage(batteries: $0, digits: 12) }
            .reduce(0, +)
    }
}
