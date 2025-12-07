class Day5: Day {
    let ranges: [ClosedRange<Int>]
    let availableIds: [Int]

    required init(input: String) {
        let split = input.split(separator: "\n\n")
        let ranges = split[0].split(separator: .newlineSequence).map { s in
            let rangeComponents = s.split(separator: "-")
            return (Int(rangeComponents[0])!)...(Int(rangeComponents[1])!)
        }.sorted(by: { (a, b) in a.lowerBound < b.lowerBound })
        self.availableIds = split[1].split(separator: .newlineSequence).map { Int($0)! }

        // Merge ranges
        var mergedRanges: [ClosedRange<Int>] = []
        for newRange in ranges {
            var found = false
            for (i, range) in mergedRanges.enumerated() {
                if newRange.overlaps(range) {
                    mergedRanges[i] =
                        ((min(newRange.lowerBound, range.lowerBound))...(max(
                            newRange.upperBound, range.upperBound)))
                    found = true
                    break
                }
            }
            if !found {
                mergedRanges.append(newRange)
            }
        }

        self.ranges = mergedRanges
    }

    var part1: Int {
        availableIds.count(where: { id in
            ranges.contains(where: { $0.contains(id) })
        })
    }
    var part2: Int {
        ranges.reduce(
            0,
            { acc, range in acc + range.upperBound - range.lowerBound + 1 })
    }
}
