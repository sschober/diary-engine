const file_extension = ".mkd"
const title = "# Tagebuch" ## markdown title of the generated output file 
const subtitle = "## Inhaltsverzeichnis" ## subtitle of the generator output file
const title_prefix = "##" ## prepended to the scanned titles, effectivly the degree to which the heading is increased 
const sidenotes_suffix = "{@paragraph .sidenote}" ## hoedown supports metadata annotations; we don't want those in the abstracts
const abstract_length = 100 ## amount of characters an abstract can hold
const default_output_filename = "index" & file_extension ## default name of the generated file