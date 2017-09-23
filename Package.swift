//
//  Package.swift
//  UnixShell
//
//

import PackageDescription

let package = Package(
	name: "UnixShell",
	targets: [
		Target(name: "UnixShell", dependencies: ["Regex", "Shell"]),
		Target(name: "Regex", dependencies: []),
		Target(name: "Shell", dependencies: []),
	]
)

