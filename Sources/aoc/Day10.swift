import RegexBuilder

class Day10: Day {
    struct Machine {
        let targetState: [Bool]
        let buttons: Set<Set<Int>>
        let requirements: [Int]

        init(input: String.SubSequence) {
            let slices = input.split(separator: .whitespace)
            self.targetState = slices[0].matches(
                of: Regex {
                    Capture {
                        ChoiceOf {
                            "."
                            "#"
                        }
                    } transform: {
                        switch $0 {
                        case ".": false
                        case "#": true
                        default: fatalError()
                        }
                    }
                }
            ).map { $0.output.1 }

            let buttonRegex = Regex {
                "("
                Capture {
                    OneOrMore(.digit)
                    ZeroOrMore {
                        ","
                        OneOrMore(.digit)
                    }
                } transform: { nums in
                    Set(nums.split(separator: ",").map { Int($0)! })
                }
                ")"
            }

            self.buttons = Set(
                slices[1..<(slices.count - 1)].map {
                    return $0.wholeMatch(of: buttonRegex)!.output.1
                })

            let requirementRegex = Regex {
                "{"
                Capture {
                    OneOrMore(.digit)
                    ZeroOrMore {
                        ","
                        OneOrMore(.digit)
                    }
                } transform: { nums in
                    nums.split(separator: ",").map { Int($0)! }
                }
                "}"
            }

            self.requirements = slices.last!.wholeMatch(of: requirementRegex)!.output.1
        }

        func pressButton(state: [Bool], button: Set<Int>) -> [Bool] {
            button.reduce(
                state,
                { acc, light in
                    var new = acc
                    new[light] = !acc[light]
                    return new
                })
        }

        var initialState: [Bool] { targetState.map { _ in false } }
    }

    let machines: [Machine]

    required init(input: String) {
        self.machines = input.split(separator: .newlineSequence).map { Machine(input: $0) }
    }

    var part1: Int {
        var counter = 0

        for machine in machines {
            // There are two important facts we need to take into consideration:
            // 1. The order the buttons are pressed does not matter
            // 2. Pressing a button twice is the same as not pressing it
            // This means that, to find the shortest sequence of button presses, we can do a BFS on the existing buttons, discarding buttons which have already been pressed.

            // Current state, buttons tried, buttons remaining
            var currentStates: [([Bool], Int, Set<Set<Int>>)] = [
                (machine.initialState, 0, machine.buttons)
            ]
            var visited: Set<[Bool]> = [machine.initialState]

            outerLoop: while true {
                if let reached = currentStates.first(where: { state in
                    state.0 == machine.targetState
                }) {
                    counter += reached.1
                    break
                }

                var nextStates: [([Bool], Int, Set<Set<Int>>)] = []

                for (state, pressed, remaining) in currentStates {
                    for button in remaining {
                        let next = machine.pressButton(state: state, button: button)
                        if next == machine.targetState {
                            counter += pressed + 1
                            break outerLoop
                        }
                        if !visited.contains(next) {
                            visited.insert(next)
                            nextStates.append(
                                (
                                    next,
                                    pressed + 1,
                                    remaining.subtracting([button])
                                )
                            )
                        }
                    }
                }

                currentStates = nextStates
            }
        }

        return counter
    }

    var part2: Int { 0 }
}
