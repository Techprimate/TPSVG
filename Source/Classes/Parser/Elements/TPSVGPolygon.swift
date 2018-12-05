//
//  TPSVGPolygon.swift
//  TPSVG
//
//  Created by Philip Niedertscheider on 30.11.18.
//  Copyright © 2018 techprimate GmbH & Co. KG. All rights reserved.
//

/**
 TODO: Add documentation
 */
class TPSVGPolygon: TPSVGElement {

    /**
     TODO: Add documentation
     */
    public var points: [CGPoint]

    /**
     TODO: Add documentation
     */
    public init(classNames: [String] = [], points: [CGPoint] = []) {
        self.points = points
        super.init(classNames: classNames)
    }

    /**
     TODO: Add documentation
     */
    public override init?(attributes: [String: String]) {
        self.points = []

        if let rawPoints = attributes["points"] {
            self.points = TPSVGValueLexer.parsePoints(from: rawPoints)
        }
        super.init(attributes: attributes)
    }

    // MARK: - Equatable

    /**
     TODO: Add documentation
     */
    public static func == (lhs: TPSVGPolygon, rhs: TPSVGPolygon) -> Bool {
        guard lhs.classNames == rhs.classNames else {
            return false
        }
        guard lhs.points == rhs.points else {
            return false
        }
        return true
    }

    // MARK: - Draw

    /**
     TODO: Add documentation
     */
    override func draw(in context: CGContext) {
        guard points.count > 0 else {
            return
        }
        let path = CGMutablePath()
        for (idx, point) in points.enumerated() {
            if idx == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()

        context.addPath(path)
        context.fillPath()
        context.addPath(path)
        context.strokePath()
    }

    // MARK: - Calculations

    /// :nodoc:
    override public var bounds: CGRect {
        let path = CGMutablePath()

        for (idx, point) in points.enumerated() {
            if idx == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()

        return path.boundingBoxOfPath
    }
}