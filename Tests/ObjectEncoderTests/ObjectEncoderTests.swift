import XCTest
@testable import ObjectEncoder

// swiftlint:disable identifier_name

class ObjectEncoderTests: XCTestCase {
    func testValuesInSingleValueContainer() throws {
        _testRoundTrip(of: true)
        _testRoundTrip(of: false)

        _testFixedWidthInteger(type: Int.self)
        _testFixedWidthInteger(type: Int8.self)
        _testFixedWidthInteger(type: Int16.self)
        _testFixedWidthInteger(type: Int32.self)
        _testFixedWidthInteger(type: Int64.self)
        _testFixedWidthInteger(type: UInt.self)
        _testFixedWidthInteger(type: UInt8.self)
        _testFixedWidthInteger(type: UInt16.self)
        _testFixedWidthInteger(type: UInt32.self)
        _testFixedWidthInteger(type: UInt64.self)

        _testFloatingPoint(type: Float.self)
        _testFloatingPoint(type: Double.self)

        _testRoundTrip(of: "")
        _testRoundTrip(of: URL(string: "https://apple.com")!)
    }

    func testValuesInKeyedContainer() throws {
        _testRoundTrip(of: KeyedSynthesized(
            bool: true, int: .max, int8: .max, int16: .max, int32: .max, int64: .max,
            uint: .max, uint8: .max, uint16: .max, uint32: .max, uint64: .max,
            float: .greatestFiniteMagnitude, double: .greatestFiniteMagnitude, string: "", optionalString: nil,
            url: URL(string: "https://apple.com")!
        ))
    }

    func testValuesInUnkeyedContainer() throws {
        _testRoundTrip(of: Unkeyed(
            bool: true, int: .max, int8: .max, int16: .max, int32: .max, int64: .max,
            uint: .max, uint8: .max, uint16: .max, uint32: .max, uint64: .max,
            float: .greatestFiniteMagnitude, double: .greatestFiniteMagnitude, string: "", optionalString: nil,
            url: URL(string: "https://apple.com")!
        ))
    }

    func testNestedContainerCodingPaths() {
        _testRoundTrip(of: NestedContainersTestType())
    }

    func testSuperEncoderCodingPaths() {
        _testRoundTrip(of: NestedContainersTestType(testSuperCoder: true))
    }

    private func _testFixedWidthInteger<T>(type: T.Type,
                                           file: StaticString = #file,
                                           line: UInt = #line) where T: FixedWidthInteger & Codable {
        _testRoundTrip(of: type.min, file: file, line: line)
        _testRoundTrip(of: type.max, file: file, line: line)
    }

    private func _testFloatingPoint<T>(type: T.Type,
                                       file: StaticString = #file,
                                       line: UInt = #line) where T: FloatingPoint & Codable {
        _testRoundTrip(of: type.leastNormalMagnitude, file: file, line: line)
        _testRoundTrip(of: type.greatestFiniteMagnitude, file: file, line: line)
        _testRoundTrip(of: type.infinity, file: file, line: line)
    }

    private func _testRoundTrip<T>(of object: T,
                                   expectedObject: Any? = nil,
                                   file: StaticString = #file,
                                   line: UInt = #line) where T: Codable, T: Equatable {
        do {
            let producedOjbect = try ObjectEncoder().encode(object)
            let decoded = try ObjectDecoder().decode(T.self, from: producedOjbect)
            XCTAssertEqual(decoded, object, "\(T.self) did not round-trip to an equal value.",
                file: file, line: line)

        } catch let error as EncodingError {
            XCTFail("Failed to encode \(T.self) from Object by error: \(error)", file: file, line: line)
        } catch let error as DecodingError {
            XCTFail("Failed to decode \(T.self) from Object by error: \(error)", file: file, line: line)
        } catch {
            XCTFail("Rout trip test of \(T.self) failed with error: \(error)", file: file, line: line)
        }
    }

    static var allTests = [
        ("testValuesInSingleValueContainer", testValuesInSingleValueContainer),
        ("testValuesInKeyedContainer", testValuesInKeyedContainer),
        ("testValuesInUnkeyedContainer", testValuesInUnkeyedContainer),
        ("testNestedContainerCodingPaths", testNestedContainerCodingPaths),
        ("testSuperEncoderCodingPaths", testSuperEncoderCodingPaths)
    ]
}

struct KeyedSynthesized: Codable, Equatable {
    static func == (lhs: KeyedSynthesized, rhs: KeyedSynthesized) -> Bool {
        return lhs.bool == rhs.bool &&
            lhs.int == rhs.int && lhs.int8 == rhs.int8 &&  lhs.int16 == rhs.int16 &&
            lhs.int32 == rhs.int32 && lhs.int64 == rhs.int64 &&
            lhs.uint == rhs.uint && lhs.uint8 == rhs.uint8 &&  lhs.uint16 == rhs.uint16 &&
            lhs.uint32 == rhs.uint32 && lhs.uint64 == rhs.uint64 &&
            lhs.float == rhs.float && lhs.double == rhs.double &&
            lhs.string == rhs.string && lhs.optionalString == rhs.optionalString &&
            lhs.url == rhs.url
    }

    var bool: Bool = true
    let int: Int
    let int8: Int8
    let int16: Int16
    let int32: Int32
    let int64: Int64
    let uint: UInt
    let uint8: UInt8
    let uint16: UInt16
    let uint32: UInt32
    let uint64: UInt64
    let float: Float
    let double: Double
    let string: String
    let optionalString: String?
    let url: URL
}

struct Unkeyed: Codable, Equatable {
    static func == (lhs: Unkeyed, rhs: Unkeyed) -> Bool {
        return lhs.bool == rhs.bool &&
            lhs.int == rhs.int && lhs.int8 == rhs.int8 &&  lhs.int16 == rhs.int16 &&
            lhs.int32 == rhs.int32 && lhs.int64 == rhs.int64 &&
            lhs.uint == rhs.uint && lhs.uint8 == rhs.uint8 &&  lhs.uint16 == rhs.uint16 &&
            lhs.uint32 == rhs.uint32 && lhs.uint64 == rhs.uint64 &&
            lhs.float == rhs.float && lhs.double == rhs.double &&
            lhs.string == rhs.string && lhs.optionalString == rhs.optionalString &&
            lhs.url == rhs.url
    }

    let bool: Bool
    let int: Int
    let int8: Int8
    let int16: Int16
    let int32: Int32
    let int64: Int64
    let uint: UInt
    let uint8: UInt8
    let uint16: UInt16
    let uint32: UInt32
    let uint64: UInt64
    let float: Float
    let double: Double
    let string: String
    let optionalString: String?
    let url: URL

    init(
        bool: Bool, int: Int, int8: Int8, int16: Int16, int32: Int32, int64: Int64,
        uint: UInt, uint8: UInt8, uint16: UInt16, uint32: UInt32, uint64: UInt64,
        float: Float, double: Double, string: String, optionalString: String?, url: URL) {
        self.bool = bool
        self.int = int
        self.int8 = int8
        self.int16 = int16
        self.int32 = int32
        self.int64 = int64
        self.uint = uint
        self.uint8 = uint8
        self.uint16 = uint16
        self.uint32 = uint32
        self.uint64 = uint64
        self.float = float
        self.double = double
        self.string = string
        self.optionalString = optionalString
        self.url = url
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        bool = try container.decode(Bool.self)
        int = try container.decode(Int.self)
        int8 = try container.decode(Int8.self)
        int16 = try container.decode(Int16.self)
        int32 = try container.decode(Int32.self)
        int64 = try container.decode(Int64.self)
        uint = try container.decode(UInt.self)
        uint8 = try container.decode(UInt8.self)
        uint16 = try container.decode(UInt16.self)
        uint32 = try container.decode(UInt32.self)
        uint64 = try container.decode(UInt64.self)
        float = try container.decode(Float.self)
        double = try container.decode(Double.self)
        string = try container.decode(String.self)
        optionalString = try container.decode(String?.self)
        url = try container.decode(URL.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(bool)
        try container.encode(int)
        try container.encode(int8)
        try container.encode(int16)
        try container.encode(int32)
        try container.encode(int64)
        try container.encode(uint)
        try container.encode(uint8)
        try container.encode(uint16)
        try container.encode(uint32)
        try container.encode(uint64)
        try container.encode(float)
        try container.encode(double)
        try container.encode(string)
        try container.encode(optionalString)
        try container.encode(url)
    }
}

// Copied from https://github.com/apple/swift/blob/master/test/stdlib/TestJSONEncoder.swift
func expectEqualPaths(_ lhs: [CodingKey],
                      _ rhs: [CodingKey],
                      _ prefix: String,
                      file: StaticString = #file,
                      line: UInt = #line) {
    if lhs.count != rhs.count {
        XCTFail("\(prefix) [CodingKey].count mismatch: \(lhs.count) != \(rhs.count)", file: file, line: line)
        return
    }

    for (key1, key2) in zip(lhs, rhs) {
        switch (key1.intValue, key2.intValue) {
        case (.none, .none): break
        case (.some(let i1), .none):
            XCTFail("\(prefix) CodingKey.intValue mismatch: \(type(of: key1))(\(i1)) != nil", file: file, line: line)
            return
        case (.none, .some(let i2)):
            XCTFail("\(prefix) CodingKey.intValue mismatch: nil != \(type(of: key2))(\(i2))", file: file, line: line)
            return
        case (.some(let i1), .some(let i2)):
            guard i1 == i2 else {
                XCTFail("\(prefix) CodingKey.intValue mismatch: \(type(of: key1))(\(i1)) != \(type(of: key2))(\(i2))",
                    file: file, line: line)
                return
            }
        }

        XCTAssertEqual(key1.stringValue, key2.stringValue, """
            \(prefix) CodingKey.stringValue mismatch: \
            \(type(of: key1))('\(key1.stringValue)') != \(type(of: key2))('\(key2.stringValue)')
            """, file: file, line: line)
    }
}

private struct _TestKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }

    static let `super` = _TestKey(stringValue: "super")!
}

struct NestedContainersTestType: Codable, Equatable {
    let testSuperCoder: Bool

    static func == (lhs: NestedContainersTestType, rhs: NestedContainersTestType) -> Bool {
        return lhs.testSuperCoder == rhs.testSuperCoder
    }

    init(testSuperCoder: Bool = false) {
        self.testSuperCoder = testSuperCoder
    }

    enum TopLevelCodingKeys: Int, CodingKey {
        case testSuperCoder
        case a
        case b
        case c
    }

    enum IntermediateCodingKeys: Int, CodingKey {
        case one
        case two
    }

    // swiftlint:disable line_length
    func encode(to encoder: Encoder) throws {
        var topLevelContainer = encoder.container(keyedBy: TopLevelCodingKeys.self)
        try topLevelContainer.encode(testSuperCoder, forKey: .testSuperCoder)

        if self.testSuperCoder {
            expectEqualPaths(encoder.codingPath, [], "Top-level Encoder's codingPath changed.")
            expectEqualPaths(topLevelContainer.codingPath, [], "New first-level keyed container has non-empty codingPath.")

            let superEncoder = topLevelContainer.superEncoder(forKey: .a)
            expectEqualPaths(encoder.codingPath, [], "Top-level Encoder's codingPath changed.")
            expectEqualPaths(topLevelContainer.codingPath, [], "First-level keyed container's codingPath changed.")
            expectEqualPaths(superEncoder.codingPath, [TopLevelCodingKeys.a], "New superEncoder had unexpected codingPath.")
            _testNestedContainers(in: superEncoder, baseCodingPath: [TopLevelCodingKeys.a])
        } else {
            _testNestedContainers(in: encoder, baseCodingPath: [])
        }
    }

    func _testNestedContainers(in encoder: Encoder, baseCodingPath: [CodingKey]) {
        expectEqualPaths(encoder.codingPath, baseCodingPath, "New encoder has non-empty codingPath.")

        // codingPath should not change upon fetching a non-nested container.
        var firstLevelContainer = encoder.container(keyedBy: TopLevelCodingKeys.self)
        expectEqualPaths(encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed.")
        expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "New first-level keyed container has non-empty codingPath.")

        // Nested Keyed Container
        do {
            // Nested container for key should have a new key pushed on.
            var secondLevelContainer = firstLevelContainer.nestedContainer(keyedBy: IntermediateCodingKeys.self, forKey: .a)
            expectEqualPaths(encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a], "New second-level keyed container had unexpected codingPath.")

            // Inserting a keyed container should not change existing coding paths.
            let thirdLevelContainerKeyed = secondLevelContainer.nestedContainer(keyedBy: IntermediateCodingKeys.self, forKey: .one)
            expectEqualPaths(encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a], "Second-level keyed container's codingPath changed.")
            expectEqualPaths(thirdLevelContainerKeyed.codingPath, baseCodingPath + [TopLevelCodingKeys.a, IntermediateCodingKeys.one], "New third-level keyed container had unexpected codingPath.")

            // Inserting an unkeyed container should not change existing coding paths.
            let thirdLevelContainerUnkeyed = secondLevelContainer.nestedUnkeyedContainer(forKey: .two)
            expectEqualPaths(encoder.codingPath, baseCodingPath + [], "Top-level Encoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath + [], "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a], "Second-level keyed container's codingPath changed.")
            expectEqualPaths(thirdLevelContainerUnkeyed.codingPath, baseCodingPath + [TopLevelCodingKeys.a, IntermediateCodingKeys.two], "New third-level unkeyed container had unexpected codingPath.")
        }

        // Nested Unkeyed Container
        do {
            // Nested container for key should have a new key pushed on.
            var secondLevelContainer = firstLevelContainer.nestedUnkeyedContainer(forKey: .b)
            expectEqualPaths(encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b], "New second-level keyed container had unexpected codingPath.")

            // Appending a keyed container should not change existing coding paths.
            let thirdLevelContainerKeyed = secondLevelContainer.nestedContainer(keyedBy: IntermediateCodingKeys.self)
            expectEqualPaths(encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b], "Second-level unkeyed container's codingPath changed.")
            expectEqualPaths(thirdLevelContainerKeyed.codingPath, baseCodingPath + [TopLevelCodingKeys.b, _TestKey(index: 0)], "New third-level keyed container had unexpected codingPath.")

            // Appending an unkeyed container should not change existing coding paths.
            let thirdLevelContainerUnkeyed = secondLevelContainer.nestedUnkeyedContainer()
            expectEqualPaths(encoder.codingPath, baseCodingPath, "Top-level Encoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b], "Second-level unkeyed container's codingPath changed.")
            expectEqualPaths(thirdLevelContainerUnkeyed.codingPath, baseCodingPath + [TopLevelCodingKeys.b, _TestKey(index: 1)], "New third-level unkeyed container had unexpected codingPath.")
        }
    }

    init(from decoder: Decoder) throws {
        let topLevelContainer = try decoder.container(keyedBy: TopLevelCodingKeys.self)
        testSuperCoder = try topLevelContainer.decode(Bool.self, forKey: .testSuperCoder)
        if self.testSuperCoder {
            expectEqualPaths(decoder.codingPath, [], "Top-level Decoder's codingPath changed.")
            expectEqualPaths(topLevelContainer.codingPath, [], "New first-level keyed container has non-empty codingPath.")

            let superDecoder = try topLevelContainer.superDecoder(forKey: .a)
            expectEqualPaths(decoder.codingPath, [], "Top-level Decoder's codingPath changed.")
            expectEqualPaths(topLevelContainer.codingPath, [], "First-level keyed container's codingPath changed.")
            expectEqualPaths(superDecoder.codingPath, [TopLevelCodingKeys.a], "New superDecoder had unexpected codingPath.")
            try _testNestedContainers(in: superDecoder, baseCodingPath: [TopLevelCodingKeys.a])
        } else {
            try _testNestedContainers(in: decoder, baseCodingPath: [])
        }
    }

    func _testNestedContainers(in decoder: Decoder, baseCodingPath: [CodingKey]) throws {
        expectEqualPaths(decoder.codingPath, baseCodingPath, "New decoder has non-empty codingPath.")

        // codingPath should not change upon fetching a non-nested container.
        let firstLevelContainer = try decoder.container(keyedBy: TopLevelCodingKeys.self)
        expectEqualPaths(decoder.codingPath, baseCodingPath, "Top-level Decoder's codingPath changed.")
        expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "New first-level keyed container has non-empty codingPath.")

        // Nested Keyed Container
        do {
            // Nested container for key should have a new key pushed on.
            let secondLevelContainer = try firstLevelContainer.nestedContainer(keyedBy: IntermediateCodingKeys.self, forKey: .a)
            expectEqualPaths(decoder.codingPath, baseCodingPath, "Top-level Decoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a], "New second-level keyed container had unexpected codingPath.")

            // Inserting a keyed container should not change existing coding paths.
            let thirdLevelContainerKeyed = try secondLevelContainer.nestedContainer(keyedBy: IntermediateCodingKeys.self, forKey: .one)
            expectEqualPaths(decoder.codingPath, baseCodingPath, "Top-level Decoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a], "Second-level keyed container's codingPath changed.")
            expectEqualPaths(thirdLevelContainerKeyed.codingPath, baseCodingPath + [TopLevelCodingKeys.a, IntermediateCodingKeys.one], "New third-level keyed container had unexpected codingPath.")

            // Inserting an unkeyed container should not change existing coding paths.
            let thirdLevelContainerUnkeyed = try secondLevelContainer.nestedUnkeyedContainer(forKey: .two)
            expectEqualPaths(decoder.codingPath, baseCodingPath + [], "Top-level Decoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath + [], "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.a], "Second-level keyed container's codingPath changed.")
            expectEqualPaths(thirdLevelContainerUnkeyed.codingPath, baseCodingPath + [TopLevelCodingKeys.a, IntermediateCodingKeys.two], "New third-level unkeyed container had unexpected codingPath.")
        }

        // Nested Unkeyed Container
        do {
            // Nested container for key should have a new key pushed on.
            var secondLevelContainer = try firstLevelContainer.nestedUnkeyedContainer(forKey: .b)
            expectEqualPaths(decoder.codingPath, baseCodingPath, "Top-level Decoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b], "New second-level keyed container had unexpected codingPath.")

            // Appending a keyed container should not change existing coding paths.
            let thirdLevelContainerKeyed = try secondLevelContainer.nestedContainer(keyedBy: IntermediateCodingKeys.self)
            expectEqualPaths(decoder.codingPath, baseCodingPath, "Top-level Decoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b], "Second-level unkeyed container's codingPath changed.")
            expectEqualPaths(thirdLevelContainerKeyed.codingPath, baseCodingPath + [TopLevelCodingKeys.b, _TestKey(index: 0)], "New third-level keyed container had unexpected codingPath.")

            // Appending an unkeyed container should not change existing coding paths.
            let thirdLevelContainerUnkeyed = try secondLevelContainer.nestedUnkeyedContainer()
            expectEqualPaths(decoder.codingPath, baseCodingPath, "Top-level Decoder's codingPath changed.")
            expectEqualPaths(firstLevelContainer.codingPath, baseCodingPath, "First-level keyed container's codingPath changed.")
            expectEqualPaths(secondLevelContainer.codingPath, baseCodingPath + [TopLevelCodingKeys.b], "Second-level unkeyed container's codingPath changed.")
            expectEqualPaths(thirdLevelContainerUnkeyed.codingPath, baseCodingPath + [TopLevelCodingKeys.b, _TestKey(index: 1)], "New third-level unkeyed container had unexpected codingPath.")
        }
    }
} // swiftlint:disable:this file_length
