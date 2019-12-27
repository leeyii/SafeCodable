//
//  SafeCodable.swift
//  SafeCodable
//
//  Created by leeyii on 2019/12/25.
//  Copyright © 2019 leeyii. All rights reserved.
//

import UIKit

//MARK: - SafeEncodable

protocol _SafeEncodable {
    associatedtype Value: Encodable
    var value: Value { get }
    var originValue: Any { get }
    init(_ value: Value)
}

extension _SafeEncodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(AnyCodable(originValue))
    }
    
    public var description: String {
        var result: String = "value: \(value)"
        switch originValue {
        case is Void:
            result += String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            result += value.description
        default:
            result += String(describing: value)
        }
        return result
    }
    
    public var debugDescription: String {
        var originValueDesc: String
        switch originValue {
        case let value as CustomDebugStringConvertible:
            originValueDesc = value.debugDescription
        default:
            originValueDesc = String(describing: originValue)
        }
        
        return "\(Self.self)(value: \(value), originValue: \(originValueDesc))"
    }
}

extension _SafeEncodable where Self: Equatable {
    
    internal static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs.originValue, rhs.originValue) {
        case is (Void, Void):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: AnyCodable], rhs as [String: AnyCodable]):
            return lhs == rhs
        case let (lhs as [AnyCodable], rhs as [AnyCodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}


//MARK: - SafeDecodable

protocol _SafeDecodable where Self : Decodable {
    associatedtype Value: Decodable
    var value: Value { get  }
    var originValue: Any { get }
    init(_ value: Value)
    
    init(container: SingleValueDecodingContainer) throws
    init(_ value: Bool, container: SingleValueDecodingContainer) throws
    init(_ value: Int, container: SingleValueDecodingContainer) throws
    init(_ value: UInt, container: SingleValueDecodingContainer) throws
    init(_ value: Double, container: SingleValueDecodingContainer) throws
    init(_ value: String, container: SingleValueDecodingContainer) throws
    init(_ value: [Self], container: SingleValueDecodingContainer) throws
    init(_ value: [String : Self], container: SingleValueDecodingContainer) throws
    
}

extension _SafeDecodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            try self.init(container: container)
        } else if let bool = try? container.decode(Bool.self) {
            try self.init(bool, container: container)
        } else if let int = try? container.decode(Int.self) {
            try self.init(int, container: container)
        } else if let uint = try? container.decode(UInt.self) {
            try self.init(uint, container: container)
        } else if let double = try? container.decode(Double.self) {
            try self.init(double, container: container)
        } else if let string = try? container.decode(String.self) {
            try self.init(string, container: container)
        } else if let array = try? container.decode([Self].self) {
            try self.init(array, container: container)
        } else if let dictionary = try? container.decode([String : Self].self) {
            try self.init(dictionary, container: container)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
        }
    }
    
    init(container: SingleValueDecodingContainer) throws {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
    }
    
    init(_ value: Bool, container: SingleValueDecodingContainer) throws {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
    }
    init(_ value: Int, container: SingleValueDecodingContainer) throws {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
    }
    init(_ value: UInt, container: SingleValueDecodingContainer) throws {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
    }
    init(_ value: Double, container: SingleValueDecodingContainer) throws {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
    }
    init(_ value: String, container: SingleValueDecodingContainer) throws {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
    }
    init(_ value: [Self], container: SingleValueDecodingContainer) throws {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
    }
    init(_ value: [String : Self], container: SingleValueDecodingContainer) throws {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "\(Self.self) value cannot be decoded")
    }
}

//MARK: - SafeStringCodable

public struct SafeStringCodable: Codable {
    
    typealias Value = String
    
    public var value: String
    
    public var originValue: Any
    
    public init(_ value: String) {
        self.value = value
        self.originValue = value
    }
    
    internal init(container: SingleValueDecodingContainer) throws {
        self.value = ""
        self.originValue = NSNull()
    }
    
    internal init(_ value: Bool, container: SingleValueDecodingContainer) throws {
        self.value = String(value)
        self.originValue = value
    }
    
    internal init(_ value: Int, container: SingleValueDecodingContainer) throws {
        self.value = String(value)
        self.originValue = value
    }
    
    internal init(_ value: UInt, container: SingleValueDecodingContainer) throws {
        self.value = String(value)
        self.originValue = value
    }
    
    internal init(_ value: Double, container: SingleValueDecodingContainer) throws {
        self.value = String(value)
        self.originValue = value
    }
    
    internal init(_ value: String, container: SingleValueDecodingContainer) throws {
        self.value = String(value)
        self.originValue = value
    }
    
    internal init(_ value: [SafeStringCodable], container: SingleValueDecodingContainer) throws {
        self.value = value.map({$0.value}).description
        self.originValue = value.map({$0.originValue})
    }
    
    internal init(_ value: [String : SafeStringCodable], container: SingleValueDecodingContainer) throws {
        self.value = value.mapValues({$0.value}).description
        self.originValue = value.mapValues({$0.originValue})
    }
}

extension SafeStringCodable: _SafeDecodable, _SafeEncodable {}

extension SafeStringCodable: CustomStringConvertible, CustomDebugStringConvertible {}

extension SafeStringCodable: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

//MARK: - SafeBoolCodable

public struct SafeBoolCodable: Codable {
    
    typealias Value = Bool
    
    public var value: Bool
    
    public var originValue: Any
    
    public init(_ value: Bool) {
        self.value = value
        self.originValue = value
    }
    
    internal init(container: SingleValueDecodingContainer) throws {
        self.value = false
        self.originValue = NSNull()
    }
    
    internal init(_ value: Bool, container: SingleValueDecodingContainer) throws {
        self.value = value
        self.originValue = value
    }
    
    internal init(_ value: Int, container: SingleValueDecodingContainer) throws {
        self.value = value > 0
        self.originValue = value
    }
    
    internal init(_ value: UInt, container: SingleValueDecodingContainer) throws {
        self.value = value > 0
        self.originValue = value
    }
    
    internal init(_ value: String, container: SingleValueDecodingContainer) throws {
        self.value = Bool.init(value) ?? false
        self.originValue = value
    }
}

extension SafeBoolCodable: _SafeDecodable, _SafeEncodable {}

extension SafeBoolCodable: CustomStringConvertible, CustomDebugStringConvertible {}

extension SafeBoolCodable: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
}

//MARK: - SafeIntCodable

public struct SafeIntCodable: Codable {
    
    typealias Value = Int
    
    public var value: Int
    
    public var originValue: Any
    
    public init(_ value: Int) {
        self.value = value
        self.originValue = value
    }
    
    internal init(container: SingleValueDecodingContainer) throws {
        self.value = 0
        self.originValue = NSNull()
    }
    
    internal init(_ value: Bool, container: SingleValueDecodingContainer) throws {
        self.value = Int.init(truncating: NSNumber(booleanLiteral: value))
        self.originValue = value
    }
    
    internal init(_ value: Int, container: SingleValueDecodingContainer) throws {
        self.value = value
        self.originValue = value
    }
    
    internal init(_ value: UInt, container: SingleValueDecodingContainer) throws {
        self.value = Int(value)
        self.originValue = value
    }
    
    internal init(_ value: Double, container: SingleValueDecodingContainer) throws {
        self.value = Int(value)
        self.originValue = value
    }
    
    internal init(_ value: String, container: SingleValueDecodingContainer) throws {
        self.value = Int.init(value) ?? 0
        self.originValue = value
    }
    
}

extension SafeIntCodable: _SafeEncodable, _SafeDecodable {}

extension SafeIntCodable: CustomStringConvertible, CustomDebugStringConvertible {}

extension SafeIntCodable: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

//MARK: - SafeDoubleCodable

public struct SafeDoubleCodable: Codable {
    
    typealias Value = Double
    
    public var value: Double
    
    public var originValue: Any
    
    public init(_ value: Double) {
        self.value = value
        self.originValue = value
    }
    
    internal init(container: SingleValueDecodingContainer) throws {
        self.value = 0
        self.originValue = NSNull()
    }
    
    internal init(_ value: Bool, container: SingleValueDecodingContainer) throws {
        self.value = Double.init(truncating: NSNumber(booleanLiteral: value))
        self.originValue = value
    }
    
    internal init(_ value: Int, container: SingleValueDecodingContainer) throws {
        self.value = Double(value)
        self.originValue = value
    }
    
    internal init(_ value: UInt, container: SingleValueDecodingContainer) throws {
        self.value = Double(value)
        self.originValue = value
    }
    
    internal init(_ value: Double, container: SingleValueDecodingContainer) throws {
        self.value = value
        self.originValue = value
    }
    
    internal init(_ value: String, container: SingleValueDecodingContainer) throws {
        self.value = Double.init(value) ?? 0
        self.originValue = value
    }
    
}

extension SafeDoubleCodable: _SafeEncodable, _SafeDecodable {}

extension SafeDoubleCodable: CustomStringConvertible, CustomDebugStringConvertible {}

extension SafeDoubleCodable: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self.init(Double(value))
    }
}


