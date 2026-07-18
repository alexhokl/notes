# Japanese Notes

## General Guidelines

- Keep notes in Markdown and preserve the existing headings and link style.
- Use Japanese script with the reading in parentheses where useful, followed by
  an English explanation.
- Prefer small, focused additions to the existing topic files.
- Update `README.md` when adding a new topic file or a substantial new section
  that should be discoverable.

## Vocabulary

`vocabulary.md` is organized first by JLPT level (`N5` through `N1`, plus `N0`),
then by grammatical role or topic, such as particles, adjectives, nouns, and
verbs. Add an entry to the most specific applicable section. Keep related
transitive and intransitive verbs together in the verb-pair sections; place the
intransitive entry first and nest the corresponding transitive entry beneath it.

Within each section, order entries by their Japanese reading, not by kanji,
English meaning, or the order in which they were discovered. Use the reading in
parentheses as the sorting key. Follow standard gojuon order:

`あいうえお`, `かきくけこ`, `さしすせそ`, `たちつてと`, `なにぬねの`,
`はひふへほ`, `まみむめも`, `やゆよ`, `らりるれろ`, `わをん`

Sort dakuten and handakuten readings with their base kana, placing voiced forms
after the unvoiced form where applicable, for example `か`, `が`, and `は`,
`ば`, `ぱ`. Sort kana-only entries by the kana as written. Preserve the existing
entry format:

`- Japanese (reading) - English meaning`

Use nested bullets for related forms or supplementary notes, and wrap long
explanations onto continuation lines using the existing Markdown style. Empty
category sections may remain empty when no suitable vocabulary has been
collected yet.

## Jisho.org Source

Each vocabulary entry's English meaning and category must be sourced from
Jisho.org. The word page uses this URL pattern, with the Japanese word
URL-encoded as `<the_word>`:

`https://jisho.org/word/<the_word>`

For example, the source page for `授業` is
`https://jisho.org/word/%E6%8E%88%E6%A5%AD`.

For reliable parsing, use Jisho's structured search endpoint with the same
URL-encoded word:

`https://jisho.org/api/v1/search/words?keyword=<the_word>`

Select the result whose `japanese[].word` exactly matches the vocabulary word.
Do not use a merely similar result returned by the search. Read the entry's
reading from `japanese[].reading`; if the word has multiple matching readings,
keep the reading represented by the vocabulary entry.

Build the English meaning from the relevant dictionary senses:

- `senses[].english_definitions[]` contains the English definitions. Preserve
  the source order and separate multiple definitions with semicolons.
- `senses[].parts_of_speech[]` contains the grammatical categories. Use these
  categories to determine or verify the vocabulary section, such as `Noun`,
  `Suru verb`, `Intransitive verb`, `Transitive verb`, or `Expressions (phrases,
  clauses, etc.)`.
- `jlpt[]` contains JLPT metadata when available. Use it to verify the level,
  but do not infer a level when Jisho does not provide one.

Use dictionary senses backed by JMdict. Exclude Wikipedia definitions and other
non-dictionary senses unless the note explicitly documents that additional
source information. If multiple JMdict senses apply, combine their definitions
and categories without duplicating identical values. Keep the local entry
format and do not add the Jisho URL to every bullet unless a citation is
specifically needed.

The HTML word page presents the same information visually: the reading is in
the word header, the category is in the meanings area, and the English meaning
is in the meaning definition. Prefer the API JSON fields for parsing because
the HTML contains presentation markup and may include unrelated sections such
as kanji details, collocations, or Wikipedia definitions.
