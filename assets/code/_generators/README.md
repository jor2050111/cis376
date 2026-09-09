# Data Pack Generators

Scripts in this folder rebuild every derived file in the course data
pack. Follow the pattern the existing textbooks use:

## Conventions

* **Seeded and reproducible.** Synthetic datasets use a fixed base seed
  (pick the course number) so reruns are byte-identical. Add asserts
  that verify the engineered properties each chapter depends on.
* **Document provenance.** Real datasets record their source, license,
  and retrieval date here and in the chapter folder's README.
* **One-time captures are not rebuilt.** Files captured from live APIs
  are committed as-is and documented, not regenerated.
* **Each chapter folder gets a README** describing every file, its
  schema, and which sections or labs load it.

## Rebuilding the student data pack zip

From the parent of the repo root (the zip's internal root is
`cis376`, the folder name the published chapters tell
students to work in):

```bash
cd /Users/vega/Documents/code/textbooks && \
zip -r cis376/build/cis376-data-pack.zip \
    cis376/assets/code \
    -x '*.DS_Store' -x '*__pycache__*'
```

The zip lands in `build/` (gitignored) and uploads to Canvas.
