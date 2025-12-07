import Foundation
import RegexBuilder

class Day1: Day {
    enum Movement {
        case left(Int)
        case right(Int)

        func absolute() -> Int {
            switch self {
            case .left(let m): -m
            case .right(let m): m
            }
        }
    }

    let input: [Movement]

    required init(input: String) {
        let matching = Regex {
            Capture {
                ChoiceOf {
                    "L"
                    "R"
                }
            }
            Capture {
                OneOrMore(.digit)
            } transform: {
                Int($0)!
            }
        }

        self.input = input.split(separator: "\n").map({ line in
            let match = try! matching.wholeMatch(in: String(line))!.output
            let (_, dir, num) = match

            switch dir {
            case "L": return .left(num)
            case "R": return .right(num)
            default: fatalError()
            }
        })
    }

    func move(dial: Int, movement: Movement) -> Int {
        return (dial + movement.absolute()) % 100
    }

    var part1: Int {
        var counter = 0
        var dial = 50
        for movement in input {
            dial = self.move(dial: dial, movement: movement)
            if dial == 0 { counter += 1 }
        }
        return counter
    }

    func crossesZero(dial: Int, movement: Movement) -> Int {
        var counter = 0
        switch movement {
        case .left(let m):
            do {
                counter += m / 100
                if dial != 0 && m % 100 >= dial {
                    counter += 1
                }
            }
        case .right(let m):
            do {
                counter += (dial + m) / 100
            }
        }
        return counter
    }

    var part2: Int {
        var dial = 50
        var counter = 0
        for movement in input {
            counter += crossesZero(dial: dial, movement: movement)
            dial += movement.absolute()
            dial = (1_000_000 + dial) % 100
        }
        return counter
    }
}
