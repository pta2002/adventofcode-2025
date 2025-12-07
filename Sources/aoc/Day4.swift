class Day4: Day {
    struct Coordinates: Hashable, Equatable {
        let x: Int
        let y: Int
    }

    let map: [Coordinates: Int]

    required init(input: String) {
        var tmp: Set<Coordinates> = []
        for (y, line) in input.split(separator: .newlineSequence).enumerated() {
            for (x, char) in line.unicodeScalars.enumerated() {
                if char == "@" {
                    tmp.insert(Coordinates(x: x, y: y))
                }
            }
        }

        var adjacency: [Coordinates: Int] = [:]
        for coordinates in tmp {
            adjacency[coordinates] = Day4.countAdjacent(coordinate: coordinates, in: tmp)
        }
        self.map = adjacency
    }

    static func countAdjacent(coordinate: Coordinates, in input: Set<Coordinates>) -> Int {
        let xs = (coordinate.x - 1)...(coordinate.x + 1)
        let ys = (coordinate.y - 1)...(coordinate.y + 1)
        var count = 0

        for x in xs {
            for y in ys {
                if input.contains(Coordinates(x: x, y: y)) {
                    count += 1
                }
            }
        }

        return count
    }

    var part1: Int {
        map.count(where: { $0.value < 5 })
    }

    var part2: Int {
        var changingMap = map

        var totalRemoved = 0
        var justRemoved = 0
        repeat {
            justRemoved = 0

            for (coordinate, neighbors) in changingMap {
                if neighbors < 5 {
                    changingMap.removeValue(forKey: coordinate)
                    justRemoved += 1

                    // Update the neighors
                    let xs = (coordinate.x - 1)...(coordinate.x + 1)
                    let ys = (coordinate.y - 1)...(coordinate.y + 1)
                    for x in xs {
                        for y in ys {
                            let coordinate = Coordinates(x: x, y: y)
                            if let prevVal = changingMap[coordinate] {
                                changingMap[coordinate] = prevVal - 1
                            }
                        }
                    }
                }
            }

            totalRemoved += justRemoved
        } while justRemoved > 0

        return totalRemoved
    }
}
