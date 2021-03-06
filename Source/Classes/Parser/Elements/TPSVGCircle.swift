//
//  TPSVGCircle.swift
//  TPSVG
//
//  Created by Philip Niedertscheider on 30.11.18.
//  Copyright © 2018 techprimate GmbH & Co. KG. All rights reserved.
//

/**
 TODO: Add documentation
 */
class TPSVGCircle: TPSVGElement {

    /**
     TODO: Add documentation
     */
    internal var center: CGPoint

    /**
     TODO: Add documentation
     */
    internal var radius: CGFloat

    /**
     TODO: Add documentation
     */
    internal init(classNames: [String] = [], center: CGPoint = .zero, radius: CGFloat = 0) {
        self.center = center
        self.radius = radius
        super.init(classNames: classNames)
    }

    /**
     TODO: Add documentation
     */
    internal override init?(attributes: [String: String]) {
        center = .zero
        if let rawX = attributes["cx"], let x = TPSVGNumberParser.parse(rawX) {
            center.x = x.value
        }
        if let rawY = attributes["cy"], let y = TPSVGNumberParser.parse(rawY) {
            center.y = y.value
        }

        radius = 0
        if let rawRadius = attributes["r"], let radius = TPSVGNumberParser.parse(rawRadius) {
            if radius.value < 0 {
                print("Negative radii are not allowed for circles!")
            } else {
                self.radius = radius.value
            }
        }

        super.init(attributes: attributes)
    }

    // MARK: - Equatable

    /**
     TODO: Add documentation
     */
    internal static func == (lhs: TPSVGCircle, rhs: TPSVGCircle) -> Bool {
        guard lhs.classNames == rhs.classNames else {
            return false
        }
        guard lhs.center == rhs.center else {
            return false
        }
        guard lhs.radius == rhs.radius else {
            return false
        }
        return true
    }

    // MARK: - Drawing

    /**
     TODO: Add documentation
     */
    override func draw(in context: CGContext) {
        let path = createPath()
        context.addPath(path)
        context.fillPath()
        context.addPath(path)
        context.strokePath()
    }

    // MARK: - CustomStringConvertible

    /**
     TODO: Add documentation
     */
    override internal var description: String {
        return String(format: "TPSVGCircle {}")
    }

    // MARK: - CustomDebugStringConvertible

    /**
     TODO: Add documentation
     */
    override internal var debugDescription: String {
        return String(format: "TPSVGCircle { classes: %@, styles: %@, center: %@, radius: %f }",
                      classNames.joined(separator: ", "),
                      styles.map({ $0.name }).joined(separator: ", "),
                      center.debugDescription,
                      radius)
    }

    // MARK: - Calculations

    override internal var bounds: CGRect {
        return createPath().boundingBoxOfPath
    }

    // MARK: - Path

    private func createPath() -> CGPath {
        let path = UIBezierPath(ovalIn: CGRect(x: center.x - radius,
                                               y: center.y - radius,
                                               width: 2 * radius,
                                               height: 2 * radius))
        path.apply(resolvedTransform)
        return path.cgPath
    }
}
