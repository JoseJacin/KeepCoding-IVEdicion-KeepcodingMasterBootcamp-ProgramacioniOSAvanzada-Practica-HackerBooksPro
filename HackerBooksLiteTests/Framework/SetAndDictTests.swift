//
//  SetTests.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 7/29/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import XCTest

class SetTests: XCTestCase {
    
    let maybe   : Set<Int>? = nil
    let nums    : Set<Int> = [1,2,3,4,5,8]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatUnionWithNilSetDoesNotCreateANewSet(){
        
        XCTAssertNil(maybe?.union(nums))
        
 
    }
    
    func testThatAddingAnEmptyOptionalToADictIsANOP(){
        
        var d = ["uno" : 1, "dos" : 2]
        
        XCTAssertNil(d["tres"])
        
        var perhaps : Int? = nil
        let dd = d
        d["cuatro"] = perhaps
        
        XCTAssertEqual(d, dd)

        
        perhaps = 42
        d["cinco"] = perhaps
    }


}






