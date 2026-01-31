#!/bin/bash

show_main_help() {
    echo "DOCKOMPILER - Docker Compiler Wrapper"
    echo ""
    echo "Usage: dockompiler <command> [options]"
    echo ""
    echo "Commands:"
    echo "  usergroup      Create Windows user and add to group"
    echo "  compile-c      Compile C file"
    echo "  compile-cpp    Compile C++ file"
    echo "  compile-cs     Compile C# file"
    echo ""
    exit 0
}

show_usergroup_help() {
    echo "Usage: dockompiler usergroup [OPTIONS]"
    echo ""
    echo "Compile executable to create Windows user and add to local group"
    echo ""
    echo "Options:"
    echo "  -u, --username <n>       Username (required)"
    echo "  -p, --password <pass>    Password (optional, adds existing user if omitted)"
    echo "  -g, --group <group>      Group name (required)"
    echo "  -o, --output <file>      Output file (default: usergroup.exe)"
    echo ""
    echo "Examples:"
    echo "  dockompiler usergroup -u newuser -p Password1 -g Administrators"
    echo "  dockompiler usergroup -u user -g Administrators"
    exit 0
}

show_compile_help() {
    echo "Usage: dockompiler compile-{c|cpp|cs} <source> [output]"
    echo ""
    echo "Compile source file to Windows executable"
    echo ""
    echo "Examples:"
    echo "  dockompiler compile-c examples/main.c app.exe"
    echo "  dockompiler compile-cpp examples/main.cpp app.exe"
    echo "  dockompiler compile-cs examples/main.cs app.exe"
    exit 0
}

compile_usergroup() {
    USERNAME=""
    PASSWORD=""
    GROUPNAME=""
    OUTPUT="usergroup.exe"
    SOURCE="examples/user.cpp"

    while [[ $# -gt 0 ]]; do
        case $1 in
            -u|--username) USERNAME="$2"; shift 2 ;;
            -p|--password) PASSWORD="$2"; shift 2 ;;
            -g|--group) GROUPNAME="$2"; shift 2 ;;
            -o|--output) OUTPUT="$2"; shift 2 ;;
            -h|--help) show_usergroup_help ;;
            *) echo "Unknown option: $1"; show_usergroup_help ;;
        esac
    done

    [ -z "$USERNAME" ] && { echo "Error: Username required"; exit 1; }
	[ -z "$GROUPNAME" ] && { echo "Error: Groupname required"; exit 1; }
    [ ! -f "/app/$SOURCE" ] && { echo "Error: Source file not found"; exit 1; }

    echo "Compiling usergroup tool..."
    echo "User: $USERNAME | Group: $GROUPNAME | Output: $OUTPUT"

    cat > /tmp/config.h << HEOF
#ifndef CONFIG_H
#define CONFIG_H
#define USERNAME L"$USERNAME"
#define PASSWORD L"$PASSWORD"
#define GROUPNAME L"$GROUPNAME"
#endif
HEOF

    /usr/bin/x86_64-w64-mingw32-g++ /app/$SOURCE -include /tmp/config.h \
        -o /app/$OUTPUT -lnetapi32 -municode -mconsole -static-libgcc -static-libstdc++
    
    rm -f /tmp/config.h
    [ $? -eq 0 ] && echo "✓ Success: $OUTPUT" || { echo "✗ Compilation failed"; exit 1; }
}

compile_c() {
    [ "$1" = "-h" ] || [ "$1" = "--help" ] && show_compile_help
    [ -z "$1" ] && { echo "Error: Source file required"; exit 1; }

    SOURCE="$1"
    OUTPUT="${2:-${SOURCE%.c}.exe}"
    shift 2
    EXTRA_FLAGS=("$@")

    [ ! -f "/app/$SOURCE" ] && { echo "Error: File not found"; exit 1; }

    echo "Compiling C: $SOURCE -> $OUTPUT"
    /usr/bin/x86_64-w64-mingw32-gcc /app/"$SOURCE" -o /app/"$OUTPUT" "${EXTRA_FLAGS[@]}" -static-libgcc
    [ $? -eq 0 ] && echo "✓ Success" || { echo "✗ Failed"; exit 1; }
}

compile_cpp() {
    [ "$1" = "-h" ] || [ "$1" = "--help" ] && show_compile_help
    [ -z "$1" ] && { echo "Error: Source file required"; exit 1; }

    SOURCE="$1"
    OUTPUT="${2:-${SOURCE%.cpp}.exe}"
    shift 2
    EXTRA_FLAGS=("$@")

    [ ! -f "/app/$SOURCE" ] && { echo "Error: File not found"; exit 1; }

    echo "Compiling C++: $SOURCE -> $OUTPUT"
    /usr/bin/x86_64-w64-mingw32-g++ /app/"$SOURCE" -o /app/"$OUTPUT" "${EXTRA_FLAGS[@]}" -static-libgcc -static-libstdc++
    [ $? -eq 0 ] && echo "✓ Success" || { echo "✗ Failed"; exit 1; }
}

compile_cs() {
    [ "$1" = "-h" ] || [ "$1" = "--help" ] && show_compile_help
    [ -z "$1" ] && { echo "Error: Source file required"; exit 1; }

    SOURCE="$1"
    OUTPUT="${2:-${SOURCE%.cs}.exe}"
    shift 2
    EXTRA_FLAGS=("$@")

    [ ! -f "/app/$SOURCE" ] && { echo "Error: File not found"; exit 1; }

    echo "Compiling C#: $SOURCE -> $OUTPUT"
    mcs -r:System.Windows.Forms -r:System.Drawing /app/"$SOURCE" -out:/app/"$OUTPUT" "${EXTRA_FLAGS[@]}"
    [ $? -eq 0 ] && echo "✓ Success" || { echo "✗ Failed"; exit 1; }
}

[ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] && show_main_help

COMMAND="$1"
shift

case "$COMMAND" in
    usergroup) compile_usergroup "$@" ;;
    compile-c) compile_c "$@" ;;
    compile-cpp) compile_cpp "$@" ;;
    compile-cs) compile_cs "$@" ;;
    *)
        if [ -x "$COMMAND" ]; then
            exec "$COMMAND" "$@"
        else
            echo "Error: Unknown command '$COMMAND'"
            show_main_help
        fi
        ;;
esac