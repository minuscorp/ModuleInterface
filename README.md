# ModuleInterface
[![Build Status](https://travis-ci.org/minuscorp/ModuleInterface.svg?branch=master)](https://travis-ci.org/minuscorp/ModuleInterface)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/minuscorp/ModuleInterface)
![License](https://img.shields.io/static/v1?label=License&message=Apache&color=blue)
![Swift version](https://img.shields.io/badge/Swift-5.1-orange)
![Twitter Follow](https://img.shields.io/twitter/follow/minuscorp?style=social)

Swift tool to generate Module Interfaces for Swift projects.

## What is a Module Interface

A Module Interface is what we commonly get using the CMD+click on an `import` statement in our codebases. SourceKit generates the code on demand. It can be a great tool and source of documentation.

[![asciicast](https://asciinema.org/a/284079.svg)](https://asciinema.org/a/284079)

### Examples

* [Commandant](Examples/Commandant.swift)
* [Mini](Examples/Mini.swift)
* [SourceKittenFramework](Examples/SourceKittenFramework.swift)
* [Yams](Examples/Yams.swift)
* [SwiftLintFramework](Examples/SwiftLintFramework.swift)

## Usage

To generate the module interface from your project, or library, run the `moduleinterface` command directly from the root your project.

```
$ cd ~/path/to/MyAppOrFramework
$ moduleinterface generate
```

This command will analyze your MyAppOrFramework project and generate the module interface for the types that have the minimum access level defined. The module interface is written to the directory Documentation relative to the root of your project repository.

### Usage options

```
$ moduleinterface help
Available commands:

clean      Delete the output folder and quit.
generate   Generates the Module Interface
help       Display general or command-specific help
version    Display the current version of ModuleInterface
```

Typing `moduleinterface help <command>` we get a list of all options for that command:

```
Generates the Swift Module Interface.

[--spm-module (string)]
	Generate documentation for Swift Package Manager module.

[--module-name (string)]
	Generate documentation for a Swift module.

[--input-folder (string)]
	Path to the input directory (defaults to /Users/minuscorp/Documents/GitHub/ModuleInterface).

[--output-folder (string)]
	Output directory (defaults to Documentation).

[--min-acl (string)]
	The minimum access level to generate documentation. Defaults to public.

--clean|-c
	Delete output folder before generating documentation.

[[]]
	List of arguments to pass to xcodebuild.
```

Usually, for most Xcode projects, no parameters are needed at all. xcodebuild should be able to find the default project and scheme.

If the command fails, try specifying the scheme (-scheme SchemeName) or the workspace. Any arguments passed to `moduleinterface` after `--` will be passed to xcodebuild without modification.

`$ moduleinterface generate -- -scheme MyScheme`

For Swift Package Manager modules, you can the module name using the --spm-module parameter.

`$ moduleinterface generate --spm-module ModuleInterface`

## Installation

### Download Binary

```
$ curl -Ls https://github.com/minuscorp/ModuleInterface/releases/download/latest/moduleinterface.macos.zip -o /tmp/moduleinterface.macos.zip
$ unzip -j -d /usr/local/bin /tmp/moduleinterface.macos.zip 
```

### From Sources
Requirements:

Swift 5.1 runtime and Xcode installed in your computer.

### Using Homebrew

`brew tap minuscorp/moduleinterface`
`brew install moduleinterface`

### Building with Swift Package Manager

```
$ git clone https://github.com/minuscorp/ModuleInterface.git
$ cd ModuleInterface
$ make
```

## Contact

Follow and contact me on Twitter at [@minuscorp](https://twitter.com/minuscorp).

## Contributions

If you find an issue, just [open a ticket](https://github.com/minuscorp/ModuleInterface/issues/new) on it. Pull requests are warmly welcome as well.

## License

ModuleInterface is licensed under the Apache 2.0. See [LICENSE](https://github.com/minuscorp/ModuleInterface/blob/master/LICENSE) for more info.

## Acknowledegments

- To [@eneko](https://twitter.com/eneko) for giving me the tooling idea.
- To [SourceKitten](https://github.com/jpsim/SourceKitten) for providing such an awesome Framework for dealing with SourceKit.
- To [BQ](https://github.com/bq) for all the mentoring.
