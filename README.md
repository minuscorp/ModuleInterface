# ModuleInterface
[![Build Status](https://travis-ci.org/minuscorp/ModuleInterface.svg?branch=master)](https://travis-ci.org/minuscorp/ModuleInterface)

Swift tool to generate Module Interfaces for Swift projects.

## Usage

To generate the module interface from your project, or library, run the `moduleinterface` command directly from the root your project.

```
$ cd ~/path/to/MyAppOrFramework
$ moduleinterface generate
```

This command will analyze your MyAppOrFramework project and generate the module interface for the types that have the minimum access level defined. The module interface is written to the directory Documentation relative to the root of your project repository.

### Usage options

```
$ sourcedocs help
Available commands:

clean      Delete the output folder and quit.
generate   Generates the Module Interface
help       Display general or command-specific help
version    Display the current version of ModuleInterface
```

Typing `moduleinterfacep` help <command> we get a list of all options for that command


