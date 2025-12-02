import Foundation
import RegexBuilder

class Day1 {
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

    var dial = 50

    func parse(input: String) throws -> [Movement] {
        return try input.split(separator: "\n").map({ line in
            let match = try matching.wholeMatch(in: String(line))!.output
            let (_, dir, num) = match

            switch dir {
            case "L": return .left(num)
            case "R": return .right(num)
            default: fatalError()
            }
        })
    }

    func move(movement: Movement) {
        self.dial = (dial + movement.absolute()) % 100
    }

    func part1(input: [Movement]) -> Int {
        var counter = 0
        for movement in input {
            self.move(movement: movement)
            if self.dial == 0 { counter += 1 }
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

    func part2(input: [Movement]) -> Int {
        self.dial = 50
        var counter = 0
        for movement in input {
            counter += crossesZero(dial: self.dial, movement: movement)
            self.dial += movement.absolute()
            self.dial = (1_000_000 + self.dial) % 100
        }
        return counter
    }
}
