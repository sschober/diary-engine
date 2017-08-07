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
##   diaryengine <directory>
## 
import os
import strutils
import streams
import times
import logging
import ospaths

include defaults
include types
include rendering


addHandler(newConsoleLogger())


proc read_title(fs: FileStream): string =
  ## reads the first line of a file, which is interpreted as the title of said file
  result = ""
  if not fs.readLine(result):
    result = nil
  else:
    debug("read title '", result, "'")
  return result

proc is_sidenote(line: string): bool =
  line.endsWith(sidenotes_suffix)

proc read_abstract(fs: FileStream): string =
  ## reads three consecutive lines, but not more than abstract_length characters
  result = ""
  var i = 3
  var line: string = ""
  while i > 0 and len(result) < abstract_length and fs.readLine(line):
    if len(line) == 0: continue
    if is_sidenote(line): continue
    # TODO: strip markdown stuff
    debug("adding line ", line)
    result.add line
    dec(i)
  if len(result) > abstract_length:
    debug("line too long... stripping")
    result = result[0..<abstract_length]

proc gather_information_on_file(file: string) : DiaryEntry = 
  ## constructs a DiaryEntry from file
  result = (path: file, title: "", abstract: "")
  debug("reading file ", file)
  let fs = newFileStream(file, fmRead)
  if not isNil(fs):
    result.title = read_title(fs)
    result.abstract = read_abstract(fs)
    fs.close()

proc is_diary_file(path: string): bool =
  ## decides, wether a given path is considered a diary entry
  let fileName = extractFilename(path)
  endsWith(toLowerAscii(path), file_extension) and (fileName != default_output_filename)

proc gather_information_at_dir(base_path: string): DiaryEntries =
  ## scans base_path for mkd files and calls gather_information_on_file on each
  result = @[]
  for kind, path in walkdir(base_path):
    if kind == pcFile and is_diary_file(path):
      var diaryEntry  = gather_information_on_file(path)
      result.add diaryEntry


proc output_information(outFs: FileStream, diaryEntries: DiaryEntries) =
  ## takes a sequence of DiaryEntries and ouputs them to the given file stream
  let output_document = render_output_document(diaryEntries)
  write(outFs, output_document)

proc open_target_file(path: string): FileStream =
  ## opens the output file
  let targetFileName = path & "/" & default_output_filename
  result = newFileStream(targetFileName, fmWrite)
  if isNil(result):
    echo "cannot open target file: ", targetFileName

if paramCount()  > 0:
  let t = cpuTime()
  let outFs = open_target_file(paramStr(1))
  let diaryEntries = gather_information_at_dir(paramStr(1))
  output_information(outFs, diaryEntries)
  info("scan time: ", (cpuTime() - t) * 1000, "ms")
else:
  error("usage: " & paramStr(0) & " <directory>")

