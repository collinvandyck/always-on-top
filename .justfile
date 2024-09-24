run: build
    .build/debug/AlwaysOnTop

build:
    swift build -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __entitlements -Xlinker AlwaysOnTop.entitlements

release: clean
    swift build -c release -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __entitlements -Xlinker AlwaysOnTop.entitlements

clean:
    swift package clean
