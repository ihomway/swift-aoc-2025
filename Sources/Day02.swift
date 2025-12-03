import Algorithms

/*
--- Day 2: Gift Shop ---

You get inside and take the elevator to its only other stop: the gift shop. "Thank you for visiting the North Pole!" gleefully exclaims a nearby sign. You aren't sure who is even allowed to visit the North Pole, but you know you can access the lobby through here, and from there you can access the rest of the North Pole base.

As you make your way through the surprisingly extensive selection, one of the clerks recognizes you and asks for your help.

As it turns out, one of the younger Elves was playing on a gift shop computer and managed to add a whole bunch of invalid product IDs to their gift shop database! Surely, it would be no trouble for you to identify the invalid product IDs for them, right?

They've even checked most of the product ID ranges already; they only have a few product ID ranges (your puzzle input) that you'll need to check. For example:

11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124
(The ID ranges are wrapped here for legibility; in your input, they appear on a single long line.)

The ranges are separated by commas (,); each range gives its first ID and last ID separated by a dash (-).

Since the young Elf was just doing silly patterns, you can find the invalid IDs by looking for any ID which is made only of some sequence of digits repeated twice. So, 55 (5 twice), 6464 (64 twice), and 123123 (123 twice) would all be invalid IDs.

None of the numbers have leading zeroes; 0101 isn't an ID at all. (101 is a valid ID that you would ignore.)

--- Part Two ---

The clerk quickly discovers that there are still invalid IDs in the ranges in your list. Maybe the young Elf was doing other silly patterns as well?

Now, an ID is invalid if it is made only of some sequence of digits repeated at least twice. So, 12341234 (1234 two times), 123123123 (123 three times), 1212121212 (12 five times), and 1111111 (1 seven times) are all invalid IDs.
*/

private typealias Pair = (lower: String, upper: String)

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    private var entities: [Pair] {
        data.split(separator: ",").map {
            let numbers = $0.split(separator: "-")
            return (String(numbers[0]), String(numbers[1]))
        }
    }

    func part1() -> Any {
        func invalidIDs(from lower: String, to upper: String) -> [Int] {
            let lowerFirstHalf = Int(lower.prefix(lower.count / 2))!
            let lowerSecondHalf = Int(lower.suffix(lower.count / 2))!

            let upperFirstHalf = Int(upper.prefix(upper.count / 2))!
            let upperSecondHalf = Int(upper.suffix(upper.count / 2))!

            let firstRange = lowerFirstHalf...upperFirstHalf
            let secondRange =
                if upperFirstHalf > lowerFirstHalf {
                    Int.power10(upper.count / 2 - 1)...(Int.power10(upper.count / 2) - 1)
                } else {
                    lowerSecondHalf...upperSecondHalf
                }
            guard firstRange.overlaps(secondRange) else {
                return []
            }
            return Array((lowerFirstHalf...upperFirstHalf).clamped(to: secondRange)).compactMap {
                let value = Int("\($0)\($0)")!
                guard (Int(lower)!...Int(upper)!).contains(value) else {
                    return nil
                }
                return value
            }
        }

        var numberOfInvalidIDs = 0
        for pair in entities {
            if pair.lower.count == pair.upper.count, pair.lower.count % 2 != 0 { continue }
            if pair.lower.count != pair.upper.count {
                for length in pair.lower.count...pair.upper.count where length % 2 == 0 {
                    if length == pair.lower.count {
                        numberOfInvalidIDs += invalidIDs(from: pair.lower, to: "\(Int.power10(length) - 1)").reduce(
                            0, +)
                    } else if length == pair.upper.count {
                        numberOfInvalidIDs += invalidIDs(from: "\(Int.power10(length - 1))", to: pair.upper).reduce(
                            0, +)
                    } else {
                        numberOfInvalidIDs += invalidIDs(
                            from: "\(Int.power10(length - 1))", to: "\(Int.power10(length) - 1)"
                        ).reduce(0, +)
                    }
                }
            } else {
                numberOfInvalidIDs += invalidIDs(from: pair.lower, to: pair.upper).reduce(0, +)
            }
        }

        return numberOfInvalidIDs
    }

    func part2() -> Any {
        func invalidIDs(from lower: String, to upper: String, chuck: Int) -> [Int] {
            let allElements = lower.split(every: chuck).compactMap(Int.init) + upper.split(every: chuck).compactMap(Int.init)

            let range = Int(lower)!...Int(upper)!
            return (allElements.min()!...allElements.max()!).compactMap {
              let value = Int(String(repeating: "\($0)", count: lower.count / chuck))!
              if range.contains(value) {
                if value < 10 {
                  return nil
                }
                return value
              } else {
                return nil
              }
            }
        }

        var numberOfInvalidIDs = 0
        var result: Set<Int> = []
        for pair in entities {
          for chuck in 1...(max(pair.lower.count, pair.upper.count) / 2) {
            if pair.lower.count == pair.upper.count {
              if pair.lower.count % chuck != 0 { continue }
              result.formUnion(invalidIDs(from: pair.lower, to: pair.upper, chuck: chuck))
            } else {
              for length in pair.lower.count...pair.upper.count where length % chuck == 0 {
                let lower = if pair.lower.count == length {
                  pair.lower
                } else {
                  "\(Int.power10(length - 1))"
                }
                let upper = if pair.upper.count == length {
                  pair.upper
                } else {
                  "\(Int.power10(length) - 1)"
                }
                result.formUnion(invalidIDs(from: lower, to: upper, chuck: chuck))
              }
            }
          }
        }
        numberOfInvalidIDs += result.reduce(0, +)
        return numberOfInvalidIDs
    }
}

extension Int {
    fileprivate static func power10(_ n: Int) -> Int {
        var result = 1
        for _ in 0..<n {
            result *= 10
        }
        return result
    }
}

private extension String {
    func split(every length: Int) -> [String] {
        var result: [String] = []
        var currentIndex = startIndex
        
        while currentIndex < endIndex {
            let nextIndex = index(currentIndex, offsetBy: length, limitedBy: endIndex) ?? endIndex
            result.append(String(self[currentIndex..<nextIndex]))
            currentIndex = nextIndex
        }
        
        return result
    }
}
