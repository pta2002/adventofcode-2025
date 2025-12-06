class Day6 {
    enum Operation {
        case add, multiply
    }

    struct Column {
        let operation: Operation
        let numbers: [Int]

        var value: Int {
            switch operation {
            case .multiply: self.numbers.reduce(1, *)
            case .add: self.numbers.reduce(0, +)
            }
        }
    }

    let columns1: [Column]
    let columns2: [Column]

    init(input: String) {
        let lines = input.split(separator: .newlineSequence)
        let operations = lines.last!.matches(of: /(\*|\+)\s+/).map {
            let op =
                switch $0.output.1 {
                case "*": Operation.multiply
                case "+": Operation.add
                default: fatalError()
                }

            return ($0.output.0.count, op)
        }

        let numbers = lines.dropLast().map { line in
            var curIndex = line.startIndex
            return operations.map { op in
                let endIndex = line.index(curIndex, offsetBy: op.0)
                let ret = line[curIndex..<endIndex]
                curIndex = endIndex
                return ret
            }
        }

        let strColumns = numbers.first!.indices.map { i in
            numbers.map { $0[i] }
        }

        self.columns1 = strColumns.enumerated().map { (i, col) in
            Column(
                operation: operations[i].1,
                numbers: col.map {
                    return Int($0.trimmingCharacters(in: .whitespaces))!
                })
        }

        let transposedAgain = strColumns.map { col in
            (0..<col.first!.count).map { i in
                let transpoedCol = col.map { num in
                    String(num[num.index(num.startIndex, offsetBy: i)])
                }

                return transpoedCol.joined(separator: "").trimmingCharacters(in: .whitespaces)
            }.filter { $0.count > 0 }.map { Int($0)! }
        }

        self.columns2 = transposedAgain.enumerated().map {
            Column(operation: operations[$0.0].1, numbers: $0.1)
        }
    }

    var part1: Int {
        columns1.reduce(0, { $0 + $1.value })
    }
    var part2: Int {
        columns2.reduce(0, { $0 + $1.value })
    }
}
