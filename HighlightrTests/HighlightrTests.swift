//
//  HighlightrTests.swift
//  HighlightrTests
//
//  Created by Jiachen Ren on 3/3/19.
//  Copyright © 2019 Illanes, Juan Pablo. All rights reserved.
//

import XCTest
import Highlightr

class HighlightrTests: XCTestCase {
    
    let kelvinCodeSegment =
"""
# This is a comment
def f(x) {
    if (x > 3) {
        println factor(x)
    }
    exit()
    while (true) {
        x := 3.14159
        $10
        $a
        @list
        "sdfsdf" as @string
    }
    {
        a: b
    }
}
f(x^2+log(x)^2*x)
"""
    let highlightr = Highlightr()!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func getFormatedHtml() -> String {
        guard let html = highlightr.formatHtml(kelvinCodeSegment, as: "kelvin") else {
            XCTFail("failed to format code as html")
            fatalError()
        }
        return html
    }
    
    /// Test default render perfomance
    func testPerformanceRender() {
        let html = getFormatedHtml()
        
        self.measure {
            guard let _ = highlightr.render(html, fastRender: false) else {
                XCTFail("failed to render")
                return
            }
        }
    }
    
    func testPerformanceFastRender() {
        let html = getFormatedHtml()
        print(html)
        // Test fast render performance
        self.measure {
            guard let _ = highlightr.render(html, fastRender: true) else {
                XCTFail("failed to fast render")
                return
            }
        }
    }

}
