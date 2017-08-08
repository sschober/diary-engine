import templates

## TODO this is unfortunate, as the sublime nim plugin complains, that the types are
## not declared
## TODO sublime syntax highlighting is confused by the """ string
## TODO howto parse from file at runtime?
## TODO this block is neccessary, as the templates module does not play well with tuples
proc render_output_document(diaryEntries: DiaryEntries): string = tmpli md"""
  # $title

  ## $subtitle

  $for de in diaryEntries {
    ${ 
      let title = de.title
      let abstract = de.abstract
      let path = de.path
    }
  $title_prefix [$title]($path)

  $abstract
  
  }
  """