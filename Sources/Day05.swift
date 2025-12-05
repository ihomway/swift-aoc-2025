import Algorithms
import Foundation

/*
--- Day 5: Cafeteria ---

As the forklifts break through the wall, the Elves are delighted to discover that there was a cafeteria on the other side after all.

You can hear a commotion coming from the kitchen. "At this rate, we won't have any time left to put the wreaths up in the dining hall!" Resolute in your quest, you investigate.

"If only we hadn't switched to the new inventory management system right before Christmas!" another Elf exclaims. You ask what's going on.

The Elves in the kitchen explain the situation: because of their complicated new inventory management system, they can't figure out which of their ingredients are fresh and which are spoiled.

--- Part Two ---

The Elves start bringing their spoiled inventory to the trash chute at the back of the kitchen.

So that they can stop bugging you when they get new inventory, the Elves would like to know all of the IDs that the fresh ingredient ID ranges consider to be fresh. An ingredient ID is still considered fresh if it is in any range.
*/

struct Day05: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: (ranges: [ClosedRange<Int>], ids: [Int]) {
        let components = data.split(separator: "\n\n")
        let ranges = components[0].split(separator: "\n")
            .map { element in
                let items = element.split(separator: "-")
                return Int(items[0])!...Int(items[1])!
            }
        let ids = components[1].split(separator: "\n").compactMap({ Int($0) })
        return (ranges, ids)
    }

    func part1() -> Any {
        var numberOfFresh = 0
        let (ranges, ids) = entities
        for id in ids where ranges.contains(where: { $0.contains(id) }) {
            numberOfFresh += 1
        }
        return numberOfFresh
    }

    func part2() -> Any {
        // var modifiedRanges: [ClosedRange<Int>] = []
        // var set: Set<Int> = []
        //   for range in entities.ranges {
        //     set.formUnion(range)
        //   }
        // return set.count
        unionRanges(entities.ranges).map(\.count).reduce(0, +)
    }

    private func unionRanges(_ ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        var copied: [ClosedRange<Int>] = []
        var usedRange: [ClosedRange<Int>] = []
        for range in ranges {
            if usedRange.contains(range) { continue }
            copied.append(range)
            usedRange.append(range)

            while let otherRange = ranges.last(where: { $0.overlaps(range) }), !usedRange.contains(otherRange) {
                usedRange.append(otherRange)
                copied[copied.endIndex - 1] =
                    min(
                        copied[copied.endIndex - 1].lowerBound, otherRange.lowerBound)...max(
                        copied[copied.endIndex - 1].upperBound, otherRange.upperBound)
            }
        }

        guard usedRange == copied else {
            return unionRanges(copied)
        }
        return copied
    }
}
