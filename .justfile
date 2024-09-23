run: build
    .build/debug/AlwaysOnTop

build:
    swift build

release: clean
    swift build -c release

clean:
    swift package clean
