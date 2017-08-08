import diaryentries
import templates
import streams

const title = "Tagebuch" ## markdown title of the generated output file
const subtitle = "Inhaltsverzeichnis" ## subtitle of the generator output file
const title_prefix = "###" ## prepended to the scanned titles, effectivly the degree to which the heading is increased

proc render_document(diaryEntries: DiaryEntries): string

proc output_information*(outFs: FileStream, diaryEntries: DiaryEntries) =
  ## takes a sequence of DiaryEntries and ouputs them to the given file stream
  let output_document = render_document(diaryEntries)
  write(outFs, output_document)

## TODO sublime syntax highlighting is confused by the """ string
## TODO howto parse from file at runtime?
## TODO the block is neccessary, as the templates module does not play well with tuples
proc render_document(diaryEntries: DiaryEntries): string = tmpli md"""
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