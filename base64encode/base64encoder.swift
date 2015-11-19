//
//  base64encoder.swift
//  base64encode
//

import Foundation

let bytesPer24Bits = 3
let byteMaxValue = 255
let bitsPerByte = 8

func base64Encode (data: NSData?) -> String?
{
    if let optionalData = data {
        let byteCount = optionalData.length
        var byteArray = [UInt8](count: byteCount, repeatedValue: 0)
        optionalData.getBytes(&byteArray, length: byteCount)
        if let arrayOfByteStrings = bytesToArrayOfByteStrings(byteArray) {
            if let arrayOfByteStringsDivisibleByThree = fillByteArrayWithZeroedBytesUntilDivisibleByThree(arrayOfByteStrings) {
                return base64EncodeArrayOfByteStrings(arrayOfByteStringsDivisibleByThree)
            }
        }
    }
    return nil
}

func bytesToArrayOfByteStrings(byteArray: [UInt8]?) -> [String]?
{
    if let optionalByteArray = byteArray {
        var byteStringArray = [String]()
        for byte in optionalByteArray {
            if let byteString = integerToByteString(Int(byte)) {
                byteStringArray.append(byteString)
            }
        }
        return byteStringArray
    }
    return nil
}

func fillByteArrayWithZeroedBytesUntilDivisibleByThree(byteArray:[String]?) -> [String]?
{
    if let optionalByteArray = byteArray {
        var arrayOfByteStrings = optionalByteArray
        while (arrayOfByteStrings.count % bytesPer24Bits > 0) {
            arrayOfByteStrings.append(integerToByteString(0)!)
        }
        return arrayOfByteStrings
    }
    return nil
}

func integerToByteString(integer: Int?) -> String?
{
    if let optionalInteger = integer {
        if optionalInteger > byteMaxValue {
            return nil
        }
        
        var prefixedByte: String = String(optionalInteger, radix: 2)
        while (prefixedByte.characters.count < bitsPerByte) {
            prefixedByte = "0" + prefixedByte
        }
        return prefixedByte
    }
    return nil
}

func processThreeByteBinaryArrayIntoBase64String(binaryStringArray: [String]?) -> String?
{
    if let optionalBinaryStringArray = binaryStringArray {
        let concatenatedBytesString = concatenateThreeBytesStringArray(optionalBinaryStringArray)
        if let optionalConcatenatedBytesString: String = concatenatedBytesString {
            return base64EncodeThreeByteString(optionalConcatenatedBytesString)
        }
    }
    return nil
}

func concatenateThreeBytesStringArray(threeByteStringArray: [String]?) -> String?
{
    if let optionalThreeByteStringArray = threeByteStringArray {
        if optionalThreeByteStringArray.count != bytesPer24Bits {
            return nil
        }
        
        var threeByteBinaryString: String = String()
        for byte in optionalThreeByteStringArray {
            threeByteBinaryString += byte
        }
        
        if (threeByteBinaryString.characters.count != bitsPerByte * bytesPer24Bits) {
            return nil
        }
        
        return threeByteBinaryString
    }
    return nil
}

func base64EncodeArrayOfByteStrings(byteStringArray: [String]?) -> String?
{
    if let optionalByteStringArray = byteStringArray {
        var base64String = String()
        var segmentPointer = 0
        while segmentPointer < optionalByteStringArray.count - bytesPer24Bits {
            let arrayOfThreeBytesToBeEncoded = [optionalByteStringArray[segmentPointer], optionalByteStringArray[segmentPointer + 1], optionalByteStringArray[segmentPointer + 2]]
            base64String += processThreeByteBinaryArrayIntoBase64String(arrayOfThreeBytesToBeEncoded)!
            segmentPointer += bytesPer24Bits
        }
        return base64String
    }
    return nil
}

func base64EncodeThreeByteString(threeByteString: String?) -> String?
{
    if let optionalThreeByteString = threeByteString {
        var base64RepresentationOfThreeBytes = String()
        for index in 0..<4 {
            let startIndex = optionalThreeByteString.startIndex.advancedBy(6 * index)
            let endIndex = optionalThreeByteString.startIndex.advancedBy((6 * index) + 6)
            let sixBitSegment = optionalThreeByteString.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex))
            let sixBitSegmentDecimalValue = Int(strtoul(sixBitSegment, nil, 2))
            base64RepresentationOfThreeBytes += base64Characters[sixBitSegmentDecimalValue]!
        }
        return base64RepresentationOfThreeBytes
    }
    return nil
}
