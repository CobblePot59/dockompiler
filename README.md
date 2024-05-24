# dockompiler

Develop lightweight applications in C, C++, or C# with ease using Docker and cross-compilation with MinGW and Mono, providing an efficient and streamlined alternative to more feature-rich development environments like VS Code.

```
git clone https://github.com/CobblePot59/dockompiler.git
cd dockompiler
docker build -t dockompiler .
docker run --rm -v ${PWD}:/app -w /app build-app mcs -r:System.Windows.Forms -r:System.Drawing main.cs
docker run --rm -v ${PWD}:/app -w /app dockompiler /usr/bin/x86_64-w64-mingw32-gcc main.c -o main2.exe
docker run --rm -v ${PWD}:/app -w /app build-app /usr/bin/x86_64-w64-mingw32-g++ main.cpp -o main3.exe
```
