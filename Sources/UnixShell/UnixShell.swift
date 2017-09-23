//
//  Shell.swift
//  Shell
//
//  Created by Bernardo Breder on 10/12/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import Shell
    import Regex
#endif

open class UnixShell {
    
    let fs = FileManager.default
    
    public init() {
    }
    
    open func rm(path: String) throws {
        var flag: ObjCBool = false
        guard FileManager.default.fileExists(atPath: path, isDirectory: &flag) else { throw UnixShellError.folderNotFound(path) }
        #if os(Linux)
            let folder = Bool(flag)
        #else
            let folder = flag.boolValue
        #endif
        if folder {
            _ = try Shell("rm", ["-rf", path]).start()
        } else {
            _ = try Shell("rm", ["-f", path]).start()
        }
    }
    
    open func touch(path: String) throws {
        guard !fs.fileExists(atPath: path) else { throw UnixShellError.fileAlreadyExist(path) }
        _ = try Shell("touch", [path]).start()
    }
    
    open func wordCount(path: String) throws -> Int {
        guard fs.fileExists(atPath: path) else { throw UnixShellError.fileAlreadyExist(path) }
        let result = try Shell("wc", ["-w", path]).start()
        guard result.success else { throw UnixShellError.wordCount(path) }
        guard result.output.count == 1 else { throw UnixShellError.wordCount(path) }
        guard let count = Int(String(result.output[0].characters.split(separator: " ")[0])) else { throw UnixShellError.wordCount(path) }
        return count
    }
    
    open func lineCount(path: String) throws -> Int {
        guard fs.fileExists(atPath: path) else { throw UnixShellError.fileAlreadyExist(path) }
        let result = try Shell("wc", ["-l", path]).start()
        guard result.success else { throw UnixShellError.wordCount(path) }
        guard result.output.count == 1 else { throw UnixShellError.wordCount(path) }
        guard let count = Int(String(result.output[0].characters.split(separator: " ")[0])) else { throw UnixShellError.wordCount(path) }
        return count
    }
    
    open func mkdir(path: String) throws {
        guard !fs.fileExists(atPath: path) else { throw UnixShellError.folderAlreadyExist(path) }
        _ = try Shell("mkdir", [path]).start()
    }
    
    open func lnSymbol(source: String, target: String) throws {
        _ = try Shell("ln", ["-s", source, target]).start()
    }
    
    open static var home: String? {
        guard let value = ProcessInfo.processInfo.environment["HOME"] else { return nil }
        return value
    }
    
    open static var tmpDir: String? {
        guard let value = ProcessInfo.processInfo.environment["TMPDIR"] else { return nil }
        return value
    }
    
    open static var user: String? {
        guard let value = ProcessInfo.processInfo.environment["USER"] else { return nil }
        return value
    }
    
    open static var path: [String] {
        guard let value = ProcessInfo.processInfo.environment["PATH"] else { return [] }
        let array = value.characters.split(separator: ":").map({String($0)})
        return array
    }
    
}

public enum UnixShellError: Error {
    case fileNotFound(String)
    case folderNotFound(String)
    case fileAlreadyExist(String)
    case folderAlreadyExist(String)
    case homeNotFound
    case wordCount(String)
}
