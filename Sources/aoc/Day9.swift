class Day9: Day {
    struct Rectangle: Hashable {
        let x: Int
        let y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        func isIntersectedBy(points: [(Int, Int)], a: (Int, Int), b: (Int, Int)) -> Bool {
            let xPos = points[x]
            let yPos = points[y]
            let myXMin = min(xPos.0, yPos.0)
            let myXMax = max(xPos.0, yPos.0)
            let myYMin = min(xPos.1, yPos.1)
            let myYMax = max(xPos.1, yPos.1)

            if a.1 == b.1 {
                // Edge is horizontal. We check if this edge intersects the current rectangle
                if myYMin < a.1 && a.1 < myYMax
                    && (min(a.0, b.0) <= myXMin && myXMin < max(a.0, b.0)
                        || min(a.0, b.0) < myXMax && myXMax <= max(a.0, b.0))
                {
                    return true
                }
            } else if a.0 == b.0 {
                // Edge is vertical. We check if this edge intersects the current rectangle
                if myXMin < a.0 && a.0 < myXMax
                    && (min(a.1, b.1) <= myYMin && myYMin < max(a.1, b.1)
                        || min(a.1, b.1) < myYMax && myYMax <= max(a.1, b.1))
                {
                    return true
                }
            } else {
                fatalError("Edge is not a straight line")
            }

            return false
        }
    }

    let points: [(Int, Int)]
    let rects: [Rectangle: Int]

    required init(input: String) {
        let points = input.split(separator: .newlineSequence).map { pointStr in
            let coords = pointStr.split(separator: ",")
            return (Int(coords[0])!, Int(coords[1])!)
        }

        self.points = points
        self.rects = Dictionary(
            uniqueKeysWithValues: points.enumerated().flatMap { (i, a) in
                points.indices[(i + 1)...].map {
                    let b = points[$0]
                    let area = (abs(a.0 - b.0) + 1) * (abs(a.1 - b.1) + 1)
                    return (Rectangle(i, $0), area)
                }
            })
    }

    func isInside(_ rect: Rectangle) -> Bool {
        for i in points.indices {
            let p1 = points[i]
            let p2 = points[(i + 1) % points.count]

            if rect.isIntersectedBy(points: points, a: p1, b: p2) { return false }
        }

        return true
    }

    var part1: Int {
        return self.rects.values.max(by: <)!
    }

    var part2: Int {
        return self.rects.sorted(by: { $0.value > $1.value })
            .first(where: { isInside($0.key) })!.value
    }
}
