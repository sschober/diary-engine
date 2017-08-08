# diary-engine

a simplistic diary engine written in nim.

'diary engine' in the sense of this tool is just a fancy name for a table of
contents generator. diary entries are markdown files with the first line scanned
as the entry title and the first few lines as an abstract.

## build

    nimble build

## test

	nimble test

## run

	./diaryengine <path to mkd files>