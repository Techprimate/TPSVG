//
//  TPSVG_Spec.swift
//  TPSVG_Tests
//
//  Created by Philip Niedertscheider on 29.11.18.
//  Copyright © 2018 techprimate GmbH & Co. KG. All rights reserved.
//

import Quick
import Nimble
@testable import TPSVG

// swiftlint:disable type_name function_body_length

class TPSVG_Spec: QuickSpec {

    override func spec() {
        describe("TPSVG") {

            describe("initalizer") {

                it("can initialized with an url") {
                    let url = Bundle.main.url(forResource: "empty", withExtension: "svg")!
                    do {
                        let svg = try TPSVG(contentsOf: url)
                        expect(svg.raw) == "<svg></svg>\n"
                    } catch {
                        fail(error.localizedDescription)
                    }
                }

                it("cannot be initialized with an invalid url") {
                    do {
                        _ = try TPSVG(contentsOf: URL(fileURLWithPath: ""))
                        fail("Should have thrown!")
                    } catch {
                        expect(error).toNot(beNil())
                    }
                }

                it("can be initialized parse data") {
                    let url = Bundle.main.url(forResource: "empty", withExtension: "svg")!
                    do {
                        let data = try Data(contentsOf: url)
                        let svg = try TPSVG(data: data)
                        expect(svg.raw) == "<svg></svg>\n"
                    } catch {
                        fail(error.localizedDescription)
                    }
                }

                it("cannot be initialized with invalid UTF8 data") {
                    do {
                        _ = try TPSVG(data: Data(bytes: [0xAD]))
                        fail("Should have thrown!")
                    } catch TPSVGError.invalidData {
                        expect(true) == true // Success
                    } catch {
                        fail(error.localizedDescription)
                    }
                }

                it("can be initialized with raw string") {
                    do {
                        let raw = "<svg></svg>"
                        let svg = try TPSVG(raw: raw)
                        expect(svg.raw) == raw
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }

            describe("results") {

                it("should parse raw result") {
                    let url = Bundle.main.url(forResource: "empty", withExtension: "svg")!
                    do {
                        let data = try Data(contentsOf: url)
                        let svg = try TPSVG(data: data)
                        let engine = TPSVGEngine()
                        engine.parse(data)

                        expect(svg.paths) == engine.elements
                        expect(svg.styles) == engine.styles
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }

            describe("content bounds") {

                func loadSVG(name: String) -> TPSVG {
                    let url = Bundle.main.url(forResource: name, withExtension: "svg")!
                    do {
                        let data = try Data(contentsOf: url)
                        return try TPSVG(data: data)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }

                it("should return correct value") {
                    expect(loadSVG(name: "inline-01").contentBounds) == CGRect(x: 0, y: 7.5, width: 50, height: 35)

                    expect(loadSVG(name: "empty").contentBounds) == .null
                    expect(loadSVG(name: "file-1-rect").contentBounds) == CGRect(x: 100, y: 100, width: 300, height: 300)
                    expect(loadSVG(name: "file-2-polygon").contentBounds) == CGRect(x: 100, y: 120, width: 300, height: 260)
                    expect(loadSVG(name: "file-3-polyline").contentBounds) == CGRect(x: 53, y: 164, width: 380, height: 186)
                    expect(loadSVG(name: "file-4-circle").contentBounds) == CGRect(x: 100, y: 100, width: 300, height: 300)
                    expect(loadSVG(name: "file-5-ellipse").contentBounds) == CGRect(x: 25, y: 100, width: 450, height: 300)

                    let file6Bounds = loadSVG(name: "file-6-path").contentBounds
                    expect(file6Bounds.origin.x).to(beCloseTo(90))
                    expect(file6Bounds.origin.y).to(beCloseTo(170))
                    expect(file6Bounds.size.width).to(beCloseTo(340))
                    expect(file6Bounds.size.height).to(beCloseTo(180.06))

//                    expect(loadSVG(name: "file-7-text").contentBounds) == CGRect(x: 88.627, y: 212.2, width: 297.447, height: 38.7)
                    expect(loadSVG(name: "file-8").contentBounds) == CGRect(x: 38, y: 38, width: 425, height: 424)

                    let file9Bounds = loadSVG(name: "file-9").contentBounds
                    expect(file9Bounds.origin.x).to(beCloseTo(71))
                    expect(file9Bounds.origin.y).to(beCloseTo(64))
                    expect(file9Bounds.size.width).to(beCloseTo(358.3))
                    expect(file9Bounds.size.height).to(beCloseTo(228.1))

                    let file10Bounds = loadSVG(name: "file-10-tiger").contentBounds
                    expect(file10Bounds.origin.x).to(beCloseTo(0.07))
                    expect(file10Bounds.origin.y).to(beCloseTo(-0.021977940633297166))
                    expect(file10Bounds.size.width).to(beCloseTo(872.0088638741104))
                    expect(file10Bounds.size.height).to(beCloseTo(898.9919779406335))

                    expect(loadSVG(name: "file-11-line").contentBounds) == CGRect(x: 100, y: 250, width: 300, height: 0)


                    expect(loadSVG(name: "file-14-v-line").contentBounds) == CGRect(x: 100, y: 150, width: 100, height: 350)
                    expect(loadSVG(name: "file-15-h-line").contentBounds) == CGRect(x: 100, y: 200, width: 300, height: 100)

                    expect(loadSVG(name: "file-13-icon-01").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                    expect(loadSVG(name: "file-13-icon-02").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                    expect(loadSVG(name: "file-13-icon-03").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                    expect(loadSVG(name: "file-13-icon-04").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                    expect(loadSVG(name: "file-13-icon-05").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                    expect(loadSVG(name: "file-13-icon-06").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                    expect(loadSVG(name: "file-13-icon-07").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                    expect(loadSVG(name: "file-13-icon-08").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                    expect(loadSVG(name: "file-13-icon-09").contentBounds) == CGRect(x: 0, y: 0, width: 512, height: 512)
                }

                it("should use transform in calculation") {
                    let rawSVG = "<svg id=\"Layer_1\" data-name=\"Layer 1\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 896 896\">"
                        + "<title>verified</title><path d=\"M512,64C264.58,64,64,264.58,64,512S264.58,960,512,960,960,759.42,960,512,759.42,64,512,64Z"
                        + "M763.24,332.71,489.94,747.37c-16.12,24.45-49.5,27.72-69.7,6.84L263.37,592a29.14,29.14,0,0,1-.09-40.06l39-40.64a26.31,26.31,0"
                        + ",0,1,38.16-.16L430.8,604a15.07,15.07,0,0,0,23.6-2.38L673.25,268.29c8.46-12.88,25.33-16.17,37.68-7.33l45.31,32.46C768.57,302.25,"
                        + "771.71,319.85,763.24,332.71Z\" transform=\"translate(-64 -64)\"/></svg>"
                    let svg: TPSVG!
                    do {
                        svg = try TPSVG(raw: rawSVG)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                    expect(svg.contentBounds) == CGRect(x: 0, y: 0, width: 896, height: 896)
                }
            }
        }
    }
}
