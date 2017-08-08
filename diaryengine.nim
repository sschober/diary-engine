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
import re

import private/diaryentries
import private/rendering

const default_output_filename = "index" & file_extension ## default name of the generated file

addHandler(newConsoleLogger()) ## supplies debug, info, ... procs

proc open_target_file(path: string): FileStream =
  ## opens the output file
  let targetFileName = path & "/" & default_output_filename
  result = newFileStream(targetFileName, fmWrite)
  if isNil(result):
    error "cannot open target file: ", targetFileName

when isMainModule:
  if paramCount()  > 0:
    let t = cpuTime()
    let scan_dir = paramStr(1)
    let outFs = open_target_file(scan_dir)
    let diaryEntries = gather_information_at_dir(scan_dir, default_output_filename)
    info "found ", len(diaryEntries),  " entries"
    output_information(outFs, diaryEntries)
    info("scan time: ", (cpuTime() - t) * 1000, "ms")
  else:
    error("usage: " & paramStr(0) & " <directory>")