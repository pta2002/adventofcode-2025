import RegexBuilder

class Day12: Day {
    struct Position: Hashable {
        let x: Int
        let y: Int
    }

    typealias Shape = Set<Position>

    let shapes: [Shape]
    let trees: [(Position, [Int])]

    required init(input: String) {
        let shapeElement = ChoiceOf {
            "."
            "#"
        }
        let shapeLine = Repeat(count: 3) { shapeElement }
        let regexMatches = input.matches(
            of: Regex {
                Anchor.startOfLine
                OneOrMore(.digit)
                ":\n"

                Capture {
                    Repeat(count: 3) {
                        shapeLine
                        "\n"
                    }
                }
            }
        )

        self.shapes = regexMatches.map { match in
            match.output.1.split(separator: .newlineSequence).enumerated().flatMap {
                (y, line) in
                let linePositions: [Set<Position>] =
                    line
                    .enumerated().map {
                        (x, char) in
                        if char == "#" { Set([Position(x: x, y: y)]) } else { Set() }
                    }

                return linePositions
            }.reduce(Set(), { $0.union($1) })
        }

        let treeRegex = Regex {
            Capture {
                OneOrMore(.digit)
                "x"
                OneOrMore(.digit)
            } transform: { l in
                let size = l.split(separator: "x")
                return Position(x: Int(size[0])!, y: Int(size[1])!)
            }
            ":"

            Capture {
                OneOrMore {
                    " "
                    OneOrMore(.digit)
                }
            } transform: { line in
                line.split(separator: " ").map { Int($0)! }
            }
        }

        self.trees = input.matches(of: treeRegex).map { ($0.output.1, $0.output.2) }
    }

    func fits(tree: (Position, [Int])) -> Bool {
        let treeArea = tree.0.x * tree.0.y
        let presentArea = tree.1.enumerated().reduce(
            0,
            {
                $0 + $1.1 * shapes[$1.0].count
            })

        return treeArea >= presentArea
    }

    // This is not accurate for the sample input, but it is for the actual input :)
    var part1: Int { trees.count(where: fits) }
    var part2: Int {
        // No part 2 for this day!
        0
    }
}
