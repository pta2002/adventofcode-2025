import RegexBuilder

class Day8: Day {
    let positions: [(Int, Int, Int)]

    class Circuit {
        let nodes: Set<Int>
        init(nodes: Set<Int>) {
            self.nodes = nodes
        }
    }

    required init(input: String) {
        let re = Regex {
            Anchor.startOfLine
            Capture(OneOrMore(.digit), transform: { Int($0)! })
            ","
            Capture(OneOrMore(.digit), transform: { Int($0)! })
            ","
            Capture(OneOrMore(.digit), transform: { Int($0)! })
            Anchor.endOfLine
        }

        self.positions = input.matches(of: re).map { match in
            (match.output.1, match.output.2, match.output.3)
        }
    }

    func norm2(_ a: (Int, Int, Int), _ b: (Int, Int, Int)) -> Int {
        let dx = Int64(a.0 - b.0)
        let dy = Int64(a.1 - b.1)
        let dz = Int64(a.2 - b.2)
        return Int(dx * dx + dy * dy + dz * dz)
    }

    var part1: Int {
        // Kruskal's algorithm
        let edgesToProcess = 1000
        var circuits = positions.enumerated().map { Circuit(nodes: Set([$0.0])) }

        var edges = positions.indices.flatMap { i in
            positions.indices[(i + 1)...].map { (i, $0) }
        }

        edges.sort(by: { a, b in
            norm2(positions[a.0], positions[a.1]) < norm2(positions[b.0], positions[b.1])
        })

        for (a, b) in edges[..<min(edgesToProcess, edges.count)] {
            circuits[a] = Circuit(nodes: circuits[a].nodes.union(circuits[b].nodes))
            for node in circuits[a].nodes {
                circuits[node] = circuits[a]
            }
        }

        circuits.sort(by: { $0.nodes.count > $1.nodes.count })

        var uniqueNodes: [Circuit] = []
        for item in circuits {
            guard let l = uniqueNodes.last else {
                uniqueNodes.append(item)
                continue
            }
            if l !== item { uniqueNodes.append(item) }
        }

        return uniqueNodes[..<min(uniqueNodes.count, 3)].reduce(
            1, { $1.nodes.count * $0 })
    }

    var part2: Int {
        var edges = positions.indices.flatMap { i in
            positions.indices[(i + 1)...].map { (i, $0) }
        }

        edges.sort(by: { a, b in
            norm2(positions[a.0], positions[a.1]) < norm2(positions[b.0], positions[b.1])
        })

        // We don't need kruskal's algorithm here, we just need to see the last edge!
        let lastEdge = edges.last!
        print(positions[edges.last!.0].0 * positions[edges.last!.1].0)

        return positions[lastEdge.0].0 * positions[lastEdge.1].0
    }
}
