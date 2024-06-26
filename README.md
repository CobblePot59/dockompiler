# dockompiler

Develop lightweight applications in C, C++, or C# with ease using Docker and cross-compilation with MinGW and Mono, providing an efficient and streamlined alternative to more feature-rich development environments like VS Code.

## Prerequisites
```
git clone https://github.com/CobblePot59/dockompiler.git
cd dockompiler
docker build -t dockompiler .
```

## Compile a C# app
```
docker run --rm -v ${PWD}:/app -w /app dockompiler mcs -r:System.Windows.Forms -r:System.Drawing main.cs
```

## Compile a C app
```
docker run --rm -v ${PWD}:/app -w /app dockompiler /usr/bin/x86_64-w64-mingw32-gcc main.c -o main2.exe
```

## Compile a C++ app
```
docker run --rm -v ${PWD}:/app -w /app dockompiler /usr/bin/x86_64-w64-mingw32-g++ main.cpp -o main3.exe
```
