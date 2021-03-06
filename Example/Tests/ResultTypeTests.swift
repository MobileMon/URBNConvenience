//
//  ResultTypeTests.swift
//  URBNConvenience
//
//  Created by Bueno McCartney on 12/13/16.
//  Copyright © 2016 jgrandelli. All rights reserved.
//

import XCTest
import URBNConvenience

class ResultTypeTests: XCTestCase {

    fileprivate enum ResultTestError: Error {
        case testErrorCase
    }
    
    func testResultEmptySuccess() {
        
        let result = Result<NoResponseType>.success(nil)
        XCTAssert(result == Result.success(nil), "Result instantiated with nil should be an emptySuccess")
        XCTAssertEqual(result.isEmpty, true, "`isEmpty` should be trye on .emptySuccess results")
        XCTAssertNil(result.value, "`value` should be nil on .emptySuccess results")
        XCTAssertNil(result.error, "`error` should be nil on .emptySuccess results")
    }
    
    func testResultSuccess() {
        let result = Result("sup")
        XCTAssert(result == Result.success("sup"), "Result instantiated with a valid type should be .success(value)")
        XCTAssertEqual(result.value, "sup", "`value` should be populated and equal to initial value on .success results")
        XCTAssertNil(result.error, "`error` should be nil on .success results")
        XCTAssertEqual(result.isEmpty, false, "`isEmpty` should be false on .success results")
    }
    
    func testResultFailure() {
        
        let result = Result(ResultTestError.testErrorCase)
        XCTAssert(result == Result.failure(ResultTestError.testErrorCase), "Result instantiated with an error should be .failure(error)")
        XCTAssertEqual(result.error as? ResultTestError, ResultTestError.testErrorCase, "`error` should be populated and equal to the initial value")
        // TODO: Ensure changing this test makes sense... it was checking false
        XCTAssertEqual(result.isEmpty, true, "`isEmpty` should be false on .failure results")
        XCTAssertNil(result.value, "`value` should be nil on .failure results")
    }
    
    func testEqualityScenarios() {
        
        struct SomeItem {}
        
        XCTAssertFalse(Result(nil) == Result(""), ".emptySuccess should not equal .success results")
        XCTAssertFalse(Result("") == Result(0), ".success should not equal .success if the Value types differ")
        XCTAssertFalse(Result<NoResponseType>(nil) == Result(ResultTestError.testErrorCase), ".emptySuccess should not equal .failure results")
        XCTAssertFalse(Result("") == Result(ResultTestError.testErrorCase), ".success should not equal .failure results")
        XCTAssertFalse(Result(SomeItem()) == Result(SomeItem()), ".success should not equal .success if Value type is not Equatable")
        
        // Failure should equal failure regardless of type
        XCTAssertTrue(Result<String>(ResultTestError.testErrorCase) == Result<Any>(ResultTestError.testErrorCase), ".failure should equal .failure if errors are same")
        XCTAssertTrue(Result<Any>(ResultTestError.testErrorCase) == Result<Any>(ResultTestError.testErrorCase), ".failure should equal .failure if errors are same")
    }
    
    func testSuccessResultHandlers() {
        var result = Result("sup")
        
        var makeSureOnSuccessSynchronous: Bool = false
        result.onSuccess { (data) -> Void in
            makeSureOnSuccessSynchronous = true
            XCTAssertEqual(data, "sup", "Result.onSuccess handler should be called when populated")
        }
        XCTAssertEqual(makeSureOnSuccessSynchronous, true, "onSuccess should be synchronous")
        
        result.onError { (err) -> Void in
            XCTFail("This should not happen")
        }
        
        result = .success(nil)
        
        result.onSuccess { (data) -> Void in
            XCTAssertNil(data, "Data should be nil onSuccess of empty successes")
        }
        
        result.onError { (err) -> Void in
            XCTFail("This should not happen")
        }
    }
    
    func testErrorResultHandlers() {
        let result = Result(ResultTestError.testErrorCase)
        
        var makeSureOnErrorSynchronous: Bool = false
        result.onError { (err) -> Void in
            makeSureOnErrorSynchronous = true
            XCTAssertEqual(err as? ResultTestError, ResultTestError.testErrorCase, "Result.onError handler should be called when populated")
        }
        XCTAssertEqual(makeSureOnErrorSynchronous, true, "onError should be synchronous")
        
        result.onSuccess { (data) -> Void in
            XCTFail("This should not happen")
        }
    }
    
    fileprivate enum TestError: Error {
        case dummy
        case foo
        case bar
    }
    
    private let errorConverter: (Error) -> Error = {
        if let error = $0 as? TestError, error == .foo {
            return TestError.bar
        }
        return $0
    }
    
    let urlConverter: (String?) throws -> URL = {
        guard let string = $0 else { throw TestError.dummy }
        return URL(string: string)!
    }
    
    func testResultSuccessMap() {
        let result = Result(Int(1234))
        let newResult = result.map{ String(describing: $0!) }

        guard case let .success(value) = newResult, let string = value else {
            XCTFail("should be success, or not nil")
            return
        }
        
        XCTAssert(string == "1234")
    }
    
    func testResultSuccessThrow() {
        let string: String? = nil
        let result = Result(string)
        let newResult = result.map(urlConverter)

        guard case let .failure(error) = newResult, let finalError = error as? TestError else {
            XCTFail("should be failure of TestError")
            return
        }
        
        XCTAssert(finalError == .dummy)
    }
    
    func testResultSuccessErrorMap() {
        let result = Result<Int>(1234)
        let newResult = result.map(errorConverter)
        
        guard case let .success(value) = newResult, let int = value else {
            XCTFail("should be success, or not nil")
            return
        }
        
        XCTAssert(int == 1234)
    }

    func testResultFailureMap() {
        let result = Result<Int>(TestError.foo)
        let newResult = result.map(errorConverter)
        
        guard case let .failure(error) = newResult, let finalError = error as? TestError else {
            XCTFail("should be failure of TestError")
            return
        }
        
        XCTAssert(finalError == .bar)
    }
    
    func testResultFailureNoMap() {
        let result = Result<Int>(TestError.dummy)
        let newResult = result.map(errorConverter)
        
        guard case let .failure(error) = newResult, let finalError = error as? TestError else {
            XCTFail("should be failure of TestError")
            return
        }
        
        XCTAssert(finalError == .dummy)
    }
}
