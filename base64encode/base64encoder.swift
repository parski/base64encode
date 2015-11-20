//
//  base64encoder.swift
//  base64encode
//

import Foundation

func base64Encode (data: NSData?) -> String?
{
    if let optionalData = data {
        var bytes = [UInt8](count: optionalData.length, repeatedValue: 0)
        optionalData.getBytes(&bytes, length: optionalData.length)
        return base64StringForBytes(bytes)!
    }
    return nil
}

func base64StringForBytes(bytes: [UInt8]?) -> String?
{
    if let optionalBytes = bytes {
        var bytesDivisibleByThree = optionalBytes
        while bytesDivisibleByThree.count % 3 != 0 {
            bytesDivisibleByThree.append(UInt8(0))
        }
        var base64String = String()
        var byte = 0
        while byte < bytesDivisibleByThree.count - 3 {
            let arrayOfThreeBytesToBeEncoded = [bytesDivisibleByThree[byte], bytesDivisibleByThree[byte + 1], bytesDivisibleByThree[byte + 2]]
            let chunk = make24BitChunkFromThreeBytes(arrayOfThreeBytesToBeEncoded)
            let sixBitChunks = splitUp32BitChunkToFourSixBitChunks(chunk)
            base64String += base64CharactersForSixBitChunks(sixBitChunks)!
            byte += 3
        }
        return base64String
    }
    return nil
}

func make24BitChunkFromThreeBytes(threeBytes: [UInt8]?) -> UInt32?
{
    if let optionalThreeBytes = threeBytes {
        var twentyFourBitChunk: UInt32 = 0
        
        for byte in optionalThreeBytes {
            twentyFourBitChunk = (twentyFourBitChunk | UInt32(byte)) << 8
        }
        return twentyFourBitChunk >> 8
    }
    return nil
}

func splitUp32BitChunkToFourSixBitChunks(chunk32Bit: UInt32?) -> [UInt8]?
{
    if let optionalChunk32Bit: UInt32 = chunk32Bit {
        let firstChunk: UInt8 = UInt8((optionalChunk32Bit & 0x00FC0000) >> 18)
        let secondChunk: UInt8 = UInt8((optionalChunk32Bit & 0x0003F000) >> 12)
        let thirdChunk: UInt8 = UInt8((optionalChunk32Bit & 0x00000FC0) >> 6)
        let fourthChunk: UInt8 = UInt8(optionalChunk32Bit & 0x0000003F)
        return [firstChunk, secondChunk, thirdChunk, fourthChunk]
    }
    return nil
}

func base64CharactersForSixBitChunks(sixBitChunks: [UInt8]?) -> String?
{
    if let optionalSixBitChunks = sixBitChunks {
        var base64CharacterString = String()
        for chunk in optionalSixBitChunks {
            if let character = base64Characters[Int(chunk)] {
                base64CharacterString += character
            }
        }
        return base64CharacterString
    }
    return nil
}
