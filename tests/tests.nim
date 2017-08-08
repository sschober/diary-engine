import unittest

include markdown

suite "test markdown utils":
  test "footnote references are removed":
    check("[^footnote]".remove_footnotes() == "")
  test "footenote declarations are stripped of markdown syntax":
    check("[^footnote]: is kept".remove_footnotes() == "is kept")