import os
import strutils
import streams

if paramCount()  > 0:
  for kind, path in walkdir(paramStr(1)):
    if endsWith(toLowerAscii(path), ".mkd"):
      echo(path)
      let fs = newFileStream(path, fmRead)
      if not isNil(fs):
        var line = ""
        if fs.readLine(line):
          echo line
        fs.close()
else:
  echo "usage: " & paramStr(0) & " <directory>"