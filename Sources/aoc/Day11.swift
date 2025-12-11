import RegexBuilder

class Day11: Day {
    class Device {
        let name: String
        let attached: Set<String>
        init(name: String, attached: Set<String>) {
            self.name = name
            self.attached = attached
        }
    }

    let devices: [String: Device]
    let start: Device
    let end: Device

    required init(input: String) {
        let re = Regex {
            Anchor.startOfLine
            Capture(OneOrMore(.word))
            ":"
            Capture {
                OneOrMore {
                    OneOrMore(.whitespace)
                    OneOrMore(.word)
                }
            } transform: {
                $0.split(separator: .whitespace)
            }
            Anchor.endOfLine
        }

        self.devices = Dictionary(
            uniqueKeysWithValues: input.matches(of: re).map { match in
                let name = String(match.output.1)
                let attached = match.output.2.map { String($0) }

                return (name, Device(name: name, attached: Set(attached)))
            } + [("out", Device(name: "out", attached: []))])

        self.start = self.devices["you"]!
        self.end = self.devices["out"]!
    }

    func traverse1(device: Device) -> Int {
        if device === end {
            return 1
        }

        return device.attached.reduce(0, { $0 + traverse1(device: devices[$1]!) })
    }

    struct Traverse2Key: Hashable {
        let name: String
        let visitedFft: Bool
        let visitedDac: Bool
    }

    var traverse2Cache: [Traverse2Key: Int] = [:]

    func traverse2(device: Device, visitedFft: Bool, visitedDac: Bool) -> Int {
        let cacheKey = Traverse2Key(
            name: device.name, visitedFft: visitedFft, visitedDac: visitedDac)

        if let cached = traverse2Cache[cacheKey] {
            return cached
        }

        if device === end {
            if visitedFft && visitedDac {
                traverse2Cache[cacheKey] = 1
            } else {
                traverse2Cache[cacheKey] = 0
            }
        } else {
            traverse2Cache[cacheKey] = device.attached.reduce(
                0,
                {
                    return $0
                        + traverse2(
                            device: devices[$1]!, visitedFft: visitedFft || device.name == "fft",
                            visitedDac: visitedDac || device.name == "dac")
                })
        }
        return traverse2Cache[cacheKey]!
    }

    var part1: Int {
        return traverse1(device: self.devices["you"]!)
    }
    var part2: Int {
        return traverse2(device: self.devices["svr"]!, visitedFft: false, visitedDac: false)
    }
}
