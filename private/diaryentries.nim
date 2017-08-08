import streams
import strutils
import logging
import ospaths
import os

include markdown

type
  ## metainformation type for a diary file
  DiaryEntry* = tuple[path: string, title: string, abstract: string]

type
  ## just a type alias for a sequence of DiaryEntries
  DiaryEntries* = seq[DiaryEntry]

const abstract_length = 200 ## amount of characters an abstract can hold

proc read_title(fs: FileStream): string =
  ## reads the first line of a file, which is interpreted as the title
  result = ""
  if not fs.readLine(result):
    result = nil
  else:
    result = strip(result, chars = {' ', '#'}) ## remove whitespace and leading #, so we control the indentation level
    debug("\tread title '", result, "'")
  return result

proc read_abstract(fs: FileStream): string =
  ## reads consecutive lines, but not more than abstract_length characters
  result = ""
  var line: string = ""
  while len(result) < abstract_length and fs.readLine(line):
    if len(line) == 0: continue
    if is_sidenote(line): continue
    line = remove_markdown_markup(line)
    result.add line & " "
  if len(result) > abstract_length:
    result = result[0..<abstract_length-3] & "..."

proc gather_information_on_file(file: string) : DiaryEntry =
  ## constructs a DiaryEntry from file
  result = (path: file, title: "", abstract: "")
  debug("reading file ", file)
  let fs = newFileStream(file, fmRead)
  if not isNil(fs):
    result.title = read_title(fs)
    result.abstract = read_abstract(fs)
    fs.close()

proc is_diary_file(path: string, ignore: string): bool =
  ## decides, wether a given path is considered a diary entry
  let fileName = extractFilename(path)
  endsWith(toLowerAscii(path), file_extension) and (fileName != ignore)

proc gather_information_at_dir*(base_path: string, ignore: string): DiaryEntries =
  ## scans base_path for mkd files and calls gather_information_on_file on each
  result = @[]
  for kind, path in walkdir(base_path):
    if kind == pcFile and is_diary_file(path, ignore):
      var diaryEntry  = gather_information_on_file(path)
      result.add diaryEntry
