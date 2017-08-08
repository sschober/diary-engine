version = "0.0.1"
author = "Sven Schober"
description = "a simple diary engine"
license = "MIT"
bin = @["diaryengine"]
skipFiles = @["types.nim", "defaults.nim", "rendering.nim", "markdown.nim"]
skipDirs = @["tests"]
requires "nim >= 0.17.0", "templates >= 0.2"

task test, "Run tests":
  exec "nim c -r tests/tests.nim"