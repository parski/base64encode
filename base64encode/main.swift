//
//  main.swift
//  base64encode
//

import Foundation

func validPath(path: String?) -> Bool
{
    if let optionalPath = path {
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(optionalPath)
    }
    return false
}

if (Process.arguments.count != 2) {
    print("Specify the path to the file that must be radixed to the 64:th base.")
} else {
    var path = Process.arguments[1]
    if validPath(path) {
        print(base64Encode(NSData(contentsOfFile: path))!)
    } else {
        print("Invalid path: \(Process.arguments[1])")
    }
}
