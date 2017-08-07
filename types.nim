type
  ## metainformation type for a diary file
  DiaryEntry = tuple[path: string, title: string, abstract: string]

type
  ## just a type alias for a sequence of DiaryEntries
  DiaryEntries = seq[DiaryEntry]
