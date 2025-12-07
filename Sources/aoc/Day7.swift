class Day7: Day {
    let start: Int
    let splits: [Set<Int>]

    required init(input: String) {
        var foundStart: Int = 0
        var foundSplits: [Set<Int>] = []
        for (y, line) in input.split(separator: .newlineSequence).enumerated() {
            var lineSplits: Set<Int> = Set()
            for (x, char) in line.enumerated() {
                if char == "S" {
                    foundStart = x
                }

                if char == "^" {
                    lineSplits.insert(x)
                }
            }

            if y != 0 {
                foundSplits.append(lineSplits)
            }
        }

        self.start = foundStart
        self.splits = foundSplits
    }

    var part1: Int {
        var hitSplits = 0
        var currentBeams: Set<Int> = Set([start])

        for split in splits {
            let shouldSplit = currentBeams.intersection(split)
            var next = currentBeams.subtracting(shouldSplit)

            for splitting in shouldSplit {
                next.insert(splitting - 1)
                next.insert(splitting + 1)
                hitSplits += 1
            }

            currentBeams = next
        }

        return hitSplits
    }

    var part2: Int {
        var currentBeams: [Int: Int] = [start: 1]

        for split in splits {
            var nextBeams: [Int: Int] = [:]
            for (pos, count) in currentBeams {
                if split.contains(pos) {
                    nextBeams[pos - 1] = (nextBeams[pos - 1] ?? 0) + count
                    nextBeams[pos + 1] = (nextBeams[pos + 1] ?? 0) + count
                } else {
                    nextBeams[pos] = (nextBeams[pos] ?? 0) + count
                }
            }
            currentBeams = nextBeams
        }

        return currentBeams.reduce(0, { $0 + $1.value })
    }
}
