// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct aoc: ParsableCommand {
    mutating func run() throws {
        let input = try String(contentsOfFile: "Inputs/day01.txt", encoding: .utf8)
        let day1 = Day1()
        let input1 = try day1.parse(input: input)
        print("Part 1: \(day1.part1(input: input1))")
        print("Part 2: \(day1.part2(input: input1))")
    }
}
