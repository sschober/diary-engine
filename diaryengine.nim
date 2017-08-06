## a simple diary engine
## ---------------------
## 
## scans a directory for ``.mkd`` files and reads the first line as a title 
## and the first few lines as an abstract.
## 
## usage
## -----
## 
## ::
## 
##   diaryengie <directory>
import os
import strutils
import streams

type 
  DiaryEntry = tuple[path: string, title: string, abstract: string]

var diaryEntries: seq[DiaryEntry] = @[]

if paramCount()  > 0:
  for kind, path in walkdir(paramStr(1)):
    if kind == pcFile and endsWith(toLowerAscii(path), ".mkd"):
      var diaryEntry: DiaryEntry
      diaryEntry.path = path
      let fs = newFileStream(path, fmRead)
      if not isNil(fs):
        var line = ""
        if fs.readLine(line):
          diaryEntry.title = line
        var i = 3
        if nil == diaryEntry.abstract:
          diaryEntry.abstract = ""
        while i > 0 and len(diaryEntry.abstract) < 100 and fs.readLine(line):
          diaryEntry.abstract.add(line)
          inc(i)
        fs.close()
        diaryEntries.add(diaryEntry)
else:
  echo "usage: " & paramStr(0) & " <directory>"

for i, diaryEntry in diaryEntries:
  # TODO: why do I have to use a $ to access i here? is it the toString operator? 
  # TODO: and why are commas neccessary?
  echo "[", $i, "]: title: ", diaryEntry.title, "\n", diaryEntry.abstract