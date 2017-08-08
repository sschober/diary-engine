import re
import strutils

const file_extension* = ".mkd"
const sidenotes_suffix = "{@paragraph .sidenote}" ## hoedown supports metadata annotations; we don't want those in the abstracts

proc is_sidenote(line: string): bool =
  line.endsWith(sidenotes_suffix)

proc remove_sidenotes(line: string): string =
   line.replace(sidenotes_suffix,"")

proc replace_image_by_alt_text(line: string): string =
  line.replacef(re"!\[([^]]*)\]\([^)]*\)", "$1")

proc remove_footnotes(line: string): string =
  ## removes hoedown footnotes
  line.replace(re"\[\^[^]]*\]:?\s*", "") # NOTE to self: carret has to be escaped

proc remove_markdown_markup(line: string): string =
  result = line.remove_sidenotes()
  result = result.replace_image_by_alt_text()
  result = result.remove_footnotes()