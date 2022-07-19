//
//  CoreDataStackTests.swift
//  apod
//
//  Created by vivek on 19/07/22.
//

import XCTest
import CoreData



class CoreDataStackTests: XCTestCase {

    var coreDatastack: CoreDataStack?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDatastack = CoreDataStack.sharedInstance
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    // MARK: Our test cases
    
    /*this test case test for the proper initialization of CoreDataStack class :)*/
    func test_init_coreDataManager(){
          let instance = CoreDataStack.sharedInstance
          /*Asserts that an expression is not nil.
           Generates a failure when expression == nil.*/
          XCTAssertNotNil( instance )
    }
      
      /*test if NSPersistentContainer(the actual core data stack) initializes successfully
       */
      func test_coreDataStackInitialization() {
        let coreDataStack = CoreDataStack.sharedInstance.persistentContainer
        
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( coreDataStack )
      }
        
}
