import RegexBuilder

class Day2 {
    let input: [ClosedRange<Int>]

    let p1_regex = Regex {
        let startRef = Reference(Substring.self)

        Anchor.startOfLine
        Capture(OneOrMore(.digit), as: startRef)
        startRef
        Anchor.endOfLine
    }

    let p2_regex = Regex {
        let startRef = Reference(Substring.self)

        Anchor.startOfLine
        Capture(OneOrMore(.digit), as: startRef)
        OneOrMore(startRef)
        Anchor.endOfLine
    }

    init(input: String) {
        self.input = input.split(separator: ",").map { range in
            let split = range.split(separator: "-")
            let start = Int(split[0].trimmingCharacters(in: .whitespacesAndNewlines))!
            let end = Int(split[1].trimmingCharacters(in: .whitespacesAndNewlines))!
            return start...end
        }
    }

    var part1: Int {
        var total = 0
        for range in self.input {
            for i in range {
                let str_i = "\(i)"
                if str_i.firstMatch(of: p1_regex) != nil {
                    total += i
                }
            }
        }
        return total
    }

    var part2: Int {
        var total = 0
        for range in self.input {
            for i in range {
                let str_i = "\(i)"
                if str_i.firstMatch(of: p2_regex) != nil {
                    total += i
                }
            }
        }
        return total
    }
}
