import ArgumentParser

protocol Day {
    init(input: String)

    var part1: Int { get }
    var part2: Int { get }
}

@main
struct aoc: ParsableCommand {
    @Flag(help: "Use sample input")
    var useSample = false

    @Argument(help: "The day to run")
    var day: Int

    mutating func run() throws {
        let days: [Int: Day.Type] = [
            1: Day1.self,
            2: Day2.self,
            3: Day3.self,
            4: Day4.self,
            5: Day5.self,
            6: Day6.self,
            7: Day7.self,
            8: Day8.self,
            9: Day9.self,
            10: Day10.self,
            11: Day11.self,
        ]

        let inputPath =
            "Inputs/day\(String(format: "%02d", self.day))\(self.useSample ? "-sample" : "").txt"
        let input = try String(contentsOfFile: inputPath, encoding: .utf8)

        guard let dayClass = days[self.day] else {
            print("Not yet implemented")
            return
        }

        let dayRunner = dayClass.init(input: input)
        print("Part 1: \(dayRunner.part1)")
        print("Part 2: \(dayRunner.part2)")
    }
}
