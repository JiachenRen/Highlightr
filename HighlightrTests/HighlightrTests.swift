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
    
    let swiftCodeSegment =
"""
    //
    //  Scope.swift
    //  Kelvin
    //
    //  Created by Jiachen Ren on 1/21/19.
    //  Copyright © 2019 Jiachen Ren. All rights reserved.
    //

    import Foundation

    public struct Scope {
        
        /// An array that keeps track of variable definitions and operations.
        private static var stack = [Scope]()
        
        private var definitions: [String: Node]
        private var operations: [String: [Operation]]
        private static var restricted = [String: Node]()
        
        init(_ definitions: [String: Node], _ operations: [String: [Operation]]) {
            self.definitions = definitions
            self.operations = operations
        }
        
        /**
         Capture and save current scope - that is, all variable definitions,
         operations, and function definitions.
         */
        public static func save() {
            let curScope = Scope(Variable.definitions, Operation.registered)
            stack.append(curScope)
        }
        
        /**
         Restore to default operations, variable & constant definitions.
         */
        public static func restoreDefault() {
            Variable.restoreDefault()
            Operation.restoreDefault()
        }
        
        /**
         Pop the last saved scope from the stack and use it as a blueprint
         to restore function and variable definitions.
         */
        public static func restore() {
            let scope = stack.removeLast()
            Operation.registered = scope.operations
            Variable.definitions = scope.definitions
        }
        
        /// Discard last saved scope
        @discardableResult
        public static func popLast() -> Scope {
            return stack.removeLast()
        }
        
        /**
         Temporarily withhold any attempts to access the variable.
         */
        public static func withholdAccess(to vars: Variable...) {
            vars.forEach {v in
                let n = v.name
                if let def = Variable.definitions[n] {
                    restricted[n] = def
                    Variable.definitions.removeValue(forKey: n)
                }
            }
        }
        
        public static func withholdAccess(to vars: [Variable]) {
            vars.forEach {withholdAccess(to: $0)}
        }
        
        public static func releaseRestrictions() {
            for (key, value) in restricted {
                Variable.define(key, value)
            }
            restricted.removeAll()
        }
    }

"""
    let highlightr = Highlightr()!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func getFormatedHtml() -> String {
        guard let html = highlightr.formatHtml(swiftCodeSegment, as: "swift") else {
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
        
        // Test fast render performance
        self.measure {
            guard let _ = highlightr.render(html, fastRender: true) else {
                XCTFail("failed to fast render")
                return
            }
        }
    }

}
