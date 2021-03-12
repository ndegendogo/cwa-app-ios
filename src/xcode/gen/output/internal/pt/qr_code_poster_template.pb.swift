// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: internal/pt/qr_code_poster_template.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

/// This file is auto-generated, DO NOT make any changes here

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct SAP_Internal_Pt_QRCodePosterTemplateAndroid {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// SVG
  var template: Data = Data()

  var offsetX: Float = 0

  var offsetY: Float = 0

  var qrCodeSideLength: UInt32 = 0

  var descriptionTextBox: SAP_Internal_Pt_QRCodePosterTemplateAndroid.QRCodeTextBoxAndroid {
    get {return _descriptionTextBox ?? SAP_Internal_Pt_QRCodePosterTemplateAndroid.QRCodeTextBoxAndroid()}
    set {_descriptionTextBox = newValue}
  }
  /// Returns true if `descriptionTextBox` has been explicitly set.
  var hasDescriptionTextBox: Bool {return self._descriptionTextBox != nil}
  /// Clears the value of `descriptionTextBox`. Subsequent reads from it will return its default value.
  mutating func clearDescriptionTextBox() {self._descriptionTextBox = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  struct QRCodeTextBoxAndroid {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var offsetX: UInt32 = 0

    var offsetY: UInt32 = 0

    var width: UInt32 = 0

    var height: UInt32 = 0

    var fontSize: UInt32 = 0

    var fontColor: String = String()

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
  }

  init() {}

  fileprivate var _descriptionTextBox: SAP_Internal_Pt_QRCodePosterTemplateAndroid.QRCodeTextBoxAndroid? = nil
}

struct SAP_Internal_Pt_QRCodePosterTemplateIOS {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// PDF
  var template: Data = Data()

  var offsetX: UInt32 = 0

  var offsetY: UInt32 = 0

  var qrCodeSideLength: UInt32 = 0

  var descriptionTextBox: SAP_Internal_Pt_QRCodePosterTemplateIOS.QRCodeTextBoxIOS {
    get {return _descriptionTextBox ?? SAP_Internal_Pt_QRCodePosterTemplateIOS.QRCodeTextBoxIOS()}
    set {_descriptionTextBox = newValue}
  }
  /// Returns true if `descriptionTextBox` has been explicitly set.
  var hasDescriptionTextBox: Bool {return self._descriptionTextBox != nil}
  /// Clears the value of `descriptionTextBox`. Subsequent reads from it will return its default value.
  mutating func clearDescriptionTextBox() {self._descriptionTextBox = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  struct QRCodeTextBoxIOS {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var offsetX: UInt32 = 0

    var offsetY: UInt32 = 0

    var width: UInt32 = 0

    var height: UInt32 = 0

    var fontSize: UInt32 = 0

    var fontColor: String = String()

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
  }

  init() {}

  fileprivate var _descriptionTextBox: SAP_Internal_Pt_QRCodePosterTemplateIOS.QRCodeTextBoxIOS? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "SAP.internal.pt"

extension SAP_Internal_Pt_QRCodePosterTemplateAndroid: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".QRCodePosterTemplateAndroid"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "template"),
    2: .same(proto: "offsetX"),
    3: .same(proto: "offsetY"),
    4: .same(proto: "qrCodeSideLength"),
    5: .same(proto: "descriptionTextBox"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.template) }()
      case 2: try { try decoder.decodeSingularFloatField(value: &self.offsetX) }()
      case 3: try { try decoder.decodeSingularFloatField(value: &self.offsetY) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.qrCodeSideLength) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._descriptionTextBox) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.template.isEmpty {
      try visitor.visitSingularBytesField(value: self.template, fieldNumber: 1)
    }
    if self.offsetX != 0 {
      try visitor.visitSingularFloatField(value: self.offsetX, fieldNumber: 2)
    }
    if self.offsetY != 0 {
      try visitor.visitSingularFloatField(value: self.offsetY, fieldNumber: 3)
    }
    if self.qrCodeSideLength != 0 {
      try visitor.visitSingularUInt32Field(value: self.qrCodeSideLength, fieldNumber: 4)
    }
    if let v = self._descriptionTextBox {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_Pt_QRCodePosterTemplateAndroid, rhs: SAP_Internal_Pt_QRCodePosterTemplateAndroid) -> Bool {
    if lhs.template != rhs.template {return false}
    if lhs.offsetX != rhs.offsetX {return false}
    if lhs.offsetY != rhs.offsetY {return false}
    if lhs.qrCodeSideLength != rhs.qrCodeSideLength {return false}
    if lhs._descriptionTextBox != rhs._descriptionTextBox {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SAP_Internal_Pt_QRCodePosterTemplateAndroid.QRCodeTextBoxAndroid: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = SAP_Internal_Pt_QRCodePosterTemplateAndroid.protoMessageName + ".QRCodeTextBoxAndroid"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "offsetX"),
    2: .same(proto: "offsetY"),
    3: .same(proto: "width"),
    4: .same(proto: "height"),
    5: .same(proto: "fontSize"),
    6: .same(proto: "fontColor"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.offsetX) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.offsetY) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.width) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.height) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.fontSize) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.fontColor) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.offsetX != 0 {
      try visitor.visitSingularUInt32Field(value: self.offsetX, fieldNumber: 1)
    }
    if self.offsetY != 0 {
      try visitor.visitSingularUInt32Field(value: self.offsetY, fieldNumber: 2)
    }
    if self.width != 0 {
      try visitor.visitSingularUInt32Field(value: self.width, fieldNumber: 3)
    }
    if self.height != 0 {
      try visitor.visitSingularUInt32Field(value: self.height, fieldNumber: 4)
    }
    if self.fontSize != 0 {
      try visitor.visitSingularUInt32Field(value: self.fontSize, fieldNumber: 5)
    }
    if !self.fontColor.isEmpty {
      try visitor.visitSingularStringField(value: self.fontColor, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_Pt_QRCodePosterTemplateAndroid.QRCodeTextBoxAndroid, rhs: SAP_Internal_Pt_QRCodePosterTemplateAndroid.QRCodeTextBoxAndroid) -> Bool {
    if lhs.offsetX != rhs.offsetX {return false}
    if lhs.offsetY != rhs.offsetY {return false}
    if lhs.width != rhs.width {return false}
    if lhs.height != rhs.height {return false}
    if lhs.fontSize != rhs.fontSize {return false}
    if lhs.fontColor != rhs.fontColor {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SAP_Internal_Pt_QRCodePosterTemplateIOS: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".QRCodePosterTemplateIOS"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "template"),
    2: .same(proto: "offsetX"),
    3: .same(proto: "offsetY"),
    4: .same(proto: "qrCodeSideLength"),
    5: .same(proto: "descriptionTextBox"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.template) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.offsetX) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.offsetY) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.qrCodeSideLength) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._descriptionTextBox) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.template.isEmpty {
      try visitor.visitSingularBytesField(value: self.template, fieldNumber: 1)
    }
    if self.offsetX != 0 {
      try visitor.visitSingularUInt32Field(value: self.offsetX, fieldNumber: 2)
    }
    if self.offsetY != 0 {
      try visitor.visitSingularUInt32Field(value: self.offsetY, fieldNumber: 3)
    }
    if self.qrCodeSideLength != 0 {
      try visitor.visitSingularUInt32Field(value: self.qrCodeSideLength, fieldNumber: 4)
    }
    if let v = self._descriptionTextBox {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_Pt_QRCodePosterTemplateIOS, rhs: SAP_Internal_Pt_QRCodePosterTemplateIOS) -> Bool {
    if lhs.template != rhs.template {return false}
    if lhs.offsetX != rhs.offsetX {return false}
    if lhs.offsetY != rhs.offsetY {return false}
    if lhs.qrCodeSideLength != rhs.qrCodeSideLength {return false}
    if lhs._descriptionTextBox != rhs._descriptionTextBox {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SAP_Internal_Pt_QRCodePosterTemplateIOS.QRCodeTextBoxIOS: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = SAP_Internal_Pt_QRCodePosterTemplateIOS.protoMessageName + ".QRCodeTextBoxIOS"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "offsetX"),
    2: .same(proto: "offsetY"),
    3: .same(proto: "width"),
    4: .same(proto: "height"),
    5: .same(proto: "fontSize"),
    6: .same(proto: "fontColor"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.offsetX) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.offsetY) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.width) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.height) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.fontSize) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.fontColor) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.offsetX != 0 {
      try visitor.visitSingularUInt32Field(value: self.offsetX, fieldNumber: 1)
    }
    if self.offsetY != 0 {
      try visitor.visitSingularUInt32Field(value: self.offsetY, fieldNumber: 2)
    }
    if self.width != 0 {
      try visitor.visitSingularUInt32Field(value: self.width, fieldNumber: 3)
    }
    if self.height != 0 {
      try visitor.visitSingularUInt32Field(value: self.height, fieldNumber: 4)
    }
    if self.fontSize != 0 {
      try visitor.visitSingularUInt32Field(value: self.fontSize, fieldNumber: 5)
    }
    if !self.fontColor.isEmpty {
      try visitor.visitSingularStringField(value: self.fontColor, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_Pt_QRCodePosterTemplateIOS.QRCodeTextBoxIOS, rhs: SAP_Internal_Pt_QRCodePosterTemplateIOS.QRCodeTextBoxIOS) -> Bool {
    if lhs.offsetX != rhs.offsetX {return false}
    if lhs.offsetY != rhs.offsetY {return false}
    if lhs.width != rhs.width {return false}
    if lhs.height != rhs.height {return false}
    if lhs.fontSize != rhs.fontSize {return false}
    if lhs.fontColor != rhs.fontColor {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
