//
//  TPSVGInstrVerticalLineTo.swift
//  TPSVG
//
//  Created by Philip Niedertscheider on 01.12.18.
//  Copyright © 2018 techprimate GmbH & Co. KG. All rights reserved.
//

/**
 TODO: Add documentation
 */
class TPSVGInstrVerticalLineTo: TPSVGInstruction {

    /**
     TODO: Add documentation
     */
    var length: CGFloat

    /**
     TODO: Add documentation
     */
    let relative: Bool

    /**
     TODO: Add documentation
     */
    init(length: CGFloat, relative: Bool = false) {
        self.length = length
        self.relative = relative
    }

    // MARK: - CustomStringConvertible

    /**
     TODO: Add documentation
     */
    override var description: String {
        return "TPSVGInstrVerticalLineTo {}"
    }

    // MARK: - CustomDebugStringConvertible

    /**
     TODO: Add documentation
     */
    override var debugDescription: String {
        return "TPSVGInstrVerticalLineTo { length: \(length), relative: \(relative) }"
    }

    // MARK: - Drawing

    /**
     TODO: Add documentation
     */
    override func modify(path: CGMutablePath, prev: TPSVGInstruction?, prevStartPoint: CGPoint?) {
        if relative {
            var end = path.currentPoint
            end.y += length
            path.move(to: end)
        } else {
            var end = path.currentPoint
            end.y = length
            path.move(to: end)
        }
    }

    // MARK: - Equatable

    /**
     TODO: Add documentation
     */
    public static func == (lhs: TPSVGInstrVerticalLineTo, rhs: TPSVGInstrVerticalLineTo) -> Bool {
        guard lhs.length == rhs.length else {
            return false
        }
        guard lhs.relative == rhs.relative else {
            return false
        }
        return true
    }
}
