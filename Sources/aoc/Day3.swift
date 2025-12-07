import Foundation

class Day3: Day {
    let input: [[Int]]

    required init(input: String) {
        self.input = input.split(separator: .newlineSequence).map { line in
            line.unicodeScalars.map({ Int(String($0))! })
        }
    }

    func largestSubsequence(sequence: [Int], size: Int) -> Int {
        if size <= 0 { return 0 }

        assert(sequence.count >= size)

        let largestDigit = sequence[..<(sequence.count - (size - 1))].max()!
        let largestLocation = sequence.firstIndex(of: largestDigit)!
        let remainingSequence = sequence[(largestLocation + 1)...]

        return largestDigit * Int(pow(10.0, Double(size - 1)))
            + largestSubsequence(sequence: Array(remainingSequence), size: size - 1)
    }

    var part1: Int {
        input.reduce(0, { $0 + largestSubsequence(sequence: $1, size: 2) })
    }

    var part2: Int {
        input.reduce(0, { $0 + largestSubsequence(sequence: $1, size: 12) })
    }
}
