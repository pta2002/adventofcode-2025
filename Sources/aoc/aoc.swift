// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct aoc: ParsableCommand {
    @Flag(help: "Use sample input")
    var useSample = false

    @Argument(help: "The day to run")
    var day: Int

    mutating func run() throws {
        let inputPath =
            "Inputs/day\(String(format: "%02d", self.day))\(self.useSample ? "-sample" : "").txt"
        let input = try String(contentsOfFile: inputPath, encoding: .utf8)

        switch self.day {
        case 1:
            do {
                let day1 = Day1()
                let input1 = try day1.parse(input: input)
                print("Part 1: \(day1.part1(input: input1))")
                print("Part 2: \(day1.part2(input: input1))")
            }
        case 2:
            do {
                let day2 = Day2(input: input)
                print("Part 1: \(day2.part1)")
                print("Part 2: \(day2.part2)")
            }
        case 3:
            do {
                let day3 = Day3(input: input)
                print("Part 1: \(day3.part1)")
                print("Part 2: \(day3.part2)")
            }
        case 4:
            do {
                let day4 = Day4(input: input)
                print("Part 1: \(day4.part1)")
                print("Part 2: \(day4.part2)")
            }
        case 5:
            do {
                let day5 = Day5(input: input)
                print("Part 1: \(day5.part1)")
                print("Part 2: \(day5.part2)")
            }
        default: fatalError("Not implemented")
        }
    }
}
