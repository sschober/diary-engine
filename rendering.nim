import templates

## TODO this is unfortunate, as the sublime nim plugin complains, that the types are
## not declared
proc render_output_document(diaryEntries: DiaryEntries): string = tmpli md"""
  # $title

  ## $subtitle

  $for de in diaryEntries {
    ${ 
      let title = de.title
      let abstract = de.abstract
    }
  $title_prefix$title

  $abstract
  
  }
  """