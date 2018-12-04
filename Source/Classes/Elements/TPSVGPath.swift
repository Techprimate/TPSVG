//
//  TPSVGPath.swift
//  TPSVG
//
//  Created by Philip Niedertscheider on 30.11.18.
//  Copyright © 2018 techprimate GmbH & Co. KG. All rights reserved.
//

/**
 TODO: Add documentation
 */
class TPSVGPath: TPSVGElement {

    /**
     TODO: Add documentation
     */
    public var instructions: [TPSVGInstruction]

    /**
     TODO: Add documentation
     */
    public init(classNames: [String] = [], instructions: [TPSVGInstruction] = []) {
        self.instructions = instructions
        super.init(classNames: classNames)
    }

    /**
     TODO: Add documentation
     */
    public override init?(attributes: [String: String]) {
        guard let rawD = attributes["d"] else {
            return nil
        }
        self.instructions = TPSVGPathDLexer(raw: rawD).parse()
        super.init(attributes: attributes)
    }

    // MARK: - Equatable

    /**
     TODO: Add documentation
     */
    public static func == (lhs: TPSVGPath, rhs: TPSVGPath) -> Bool {
        guard lhs.classNames == rhs.classNames else {
            return false
        }
        guard lhs.instructions == rhs.instructions else {
            return false
        }
        return true
    }

    // MARK: - Drawing

    /**
     TODO: Add documentation
     */
    override func draw(in context: CGContext) {
        let path = CGMutablePath()

        var prev: TPSVGInstruction?
        var lastStartPoint: CGPoint?
        for inst in instructions {
            let point = path.currentPoint
            inst.modify(path: path, prev: prev, prevStartPoint: lastStartPoint)
            lastStartPoint = point
            prev = inst
        }

        context.addPath(path)
        context.fillPath()
        context.addPath(path)
        context.strokePath()
    }

    // MARK: - CustomStringConvertible

    /**
     TODO: Add documentation
     */
    override public var description: String {
        return "TPSVGPath {}"
    }

    // MARK: - CustomDebugStringConvertible

    /**
     TODO: Add documentation
     */
    override public var debugDescription: String {
        return "TPSVGPath { classes: \(classNames), instructions: \(instructions) }"
    }
}
