# dockompiler

A lightweight Docker-based compiler wrapper for building Windows executables in C, C++, or C# allows developers to create applications easily, using cross-compilation with MinGW and Mono, offering an efficient alternative to more feature-rich environments like VS Code.

## Prerequisites
```
git clone https://github.com/CobblePot59/dockompiler.git
cd dockompiler
docker build -t dockompiler .
```

## Generic Compilation
```
docker run --rm -v ${PWD}:/app dockompiler compile-c   examples/main.c   c-app.exe
docker run --rm -v ${PWD}:/app dockompiler compile-cpp examples/main.cpp cpp-app.exe
docker run --rm -v ${PWD}:/app dockompiler compile-cs  examples/main.cs  cs-app.exe
```

## Usergroup Command
Generate a Windows executable that will create or update a user using compile-time values:
```
docker run --rm -v .:/app dockompiler usergroup -u <username> [-p <password>] -g <groupname> [-o usergroup.exe]
```

### Examples:

Create a new user and add to Administrators
```
docker run --rm -v ${PWD}:/app dockompiler usergroup -u test -p Password1 -g Administrators
```

Add an existing user to a group
```
docker run --rm -v .:/app dockompiler usergroup -u test -g "Remote Desktop Users"
```