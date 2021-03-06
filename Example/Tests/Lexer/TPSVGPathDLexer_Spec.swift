//
//  TPSVGPathDLexer_Spec.swift
//  TPSVG_Tests
//
//  Created by Philip Niedertscheider on 01.12.18.
//  Copyright © 2018 techprimate GmbH & Co. KG. All rights reserved.
//

import Quick
import Nimble
@testable import TPSVG

// swiftlint:disable type_name function_body_length line_length

class TPSVGPathDLexer_Spec: QuickSpec {

    override func spec() {
        describe("TPSVGPathDLexer") {

            describe("initalizer") {

                describe("moveTo") {

                    it("should parse") {
                        let raw = "M 90 260"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrMoveTo(point: CGPoint(x: 90, y: 260))
                    }

                    it("should parse with floating values") {
                        let raw = "M 90.12352 260.125123"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrMoveTo(point: CGPoint(x: 90.12352, y: 260.125123))
                    }

                    it("should parse relative") {
                        let raw = "m 90 260"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrMoveTo(point: CGPoint(x: 90, y: 260), relative: true)
                    }

                    it("should parse partly minified") {
                        let raw = "M 90,260"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrMoveTo(point: CGPoint(x: 90, y: 260))
                    }

                    it("should parse minified") {
                        let raw = "M90,260"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrMoveTo(point: CGPoint(x: 90, y: 260))
                    }
                }

                describe("cubic curve") {

                    it("should parse") {
                        let raw = "C100 100 250 100 250 200"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrCubicCurve(control1: CGPoint(x: 100, y: 100), control2: CGPoint(x: 250, y: 100), end: CGPoint(x: 250, y: 200))
                    }

                    it("should parse with floating values") {
                        let raw = "C123.456 654.321 123.123 567.567 876.876 465.465"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrCubicCurve(control1: CGPoint(x: 123.456, y: 654.321), control2: CGPoint(x: 123.123, y: 567.567), end: CGPoint(x: 876.876, y: 465.465))
                    }

                    it("should parse relative") {
                        let raw = "c100 100 250 100 250 200"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrCubicCurve(control1: CGPoint(x: 100, y: 100), control2: CGPoint(x: 250, y: 100), end: CGPoint(x: 250, y: 200), relative: true)
                    }

                    it("should parse partly minified") {
                        let raw = "C100,100 250,100 250,200"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrCubicCurve(control1: CGPoint(x: 100, y: 100), control2: CGPoint(x: 250, y: 100), end: CGPoint(x: 250, y: 200))
                    }

                    it("should parse minified") {
                        let raw = "C100,100,250,100,250,200"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrCubicCurve(control1: CGPoint(x: 100, y: 100), control2: CGPoint(x: 250, y: 100), end: CGPoint(x: 250, y: 200))
                    }
                }

                describe("elliptical arc") {

                    it("should parse") {
                        let raw = "A 70 50 10 0 0 250,150"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrEllipticalArcCurve(radius: CGVector(dx: 70, dy: 50),
                                                                                xAxisRotation: 10,
                                                                                largeArcFlag: false,
                                                                                sweepFlag: false,
                                                                                end: CGPoint(x: 250, y: 150))
                    }

                    it("should parse with floating values") {
                        let raw = "A 70.1234 50.1234 10.1234 1 1 250.1234,150.1234"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrEllipticalArcCurve(radius: CGVector(dx: 70.1234, dy: 50.1234),
                                                                                xAxisRotation: 10.1234,
                                                                                largeArcFlag: true,
                                                                                sweepFlag: true,
                                                                                end: CGPoint(x: 250.1234, y: 150.1234))
                    }

                    it("should parse relative") {
                        let raw = "a70 50 10 0 0 250,150"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrEllipticalArcCurve(radius: CGVector(dx: 70, dy: 50),
                                                                                xAxisRotation: 10,
                                                                                largeArcFlag: false,
                                                                                sweepFlag: false,
                                                                                end: CGPoint(x: 250, y: 150),
                                                                                relative: true)
                    }

                    it("should parse partly minified") {
                        let raw = "A70 50 10 0 0 250,150"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrEllipticalArcCurve(radius: CGVector(dx: 70, dy: 50),
                                                                                xAxisRotation: 10,
                                                                                largeArcFlag: false,
                                                                                sweepFlag: false,
                                                                                end: CGPoint(x: 250, y: 150))
                    }

                    it("should parse minified") {
                        let raw = "A70,50,10,0,0,250,150"
                        let instructions = TPSVGPathDLexer(raw: raw).parse()

                        expect(instructions).to(haveCount(1))
                        expect(instructions[0]) == TPSVGInstrEllipticalArcCurve(radius: CGVector(dx: 70, dy: 50),
                                                                                xAxisRotation: 10,
                                                                                largeArcFlag: false,
                                                                                sweepFlag: false,
                                                                                end: CGPoint(x: 250, y: 150))
                    }
                }

                describe("multiple elements") {

                    it("should parse space separated values") {
                        let raw = "M 0 7.5 L 0 12.5 L 50 12.5 L 50 7.5 Z M 0 22.5 L 0 27.5 L 50 27.5 L 50 22.5 Z M 0 37.5 L 0 42.5 L 50 42.5 L 50 37.5 Z"
                        expect(TPSVGPathDLexer(raw: raw).parse()) == [
                            TPSVGInstrMoveTo(point: CGPoint(x: 0, y: 7.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 0, y: 12.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 50, y: 12.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 50, y: 7.5)),
                            TPSVGInstrClosePath(),

                            TPSVGInstrMoveTo(point: CGPoint(x: 0, y: 22.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 0, y: 27.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 50, y: 27.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 50, y: 22.5)),
                            TPSVGInstrClosePath(),


                            TPSVGInstrMoveTo(point: CGPoint(x: 0, y: 37.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 0, y: 42.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 50, y: 42.5)),
                            TPSVGInstrLineTo(point: CGPoint(x: 50, y: 37.5)),
                            TPSVGInstrClosePath()
                        ]
                    }
                }
            }
        }
    }
}
