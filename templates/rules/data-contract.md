# Data contract

Source of truth: {{path to contract code, or "this file" if none yet}}. If the code and this file disagree, the code wins; fix this file.

## Inputs
| Source | Format | Required columns (type) | Notes |
|---|---|---|---|
| {{source}} | {{csv/xlsx/parquet/api}} | {{col (type), ...}} | {{encoding, header quirks}} |

## Identity rules (halt)
A row is only trusted if these hold. A violation stops the run, because downstream joins would be silently wrong.
- {{e.g. plot prefix ∈ known prefixes → maps to treatment}}
- required columns present; types parse

## Value rules (quarantine)
A violation moves the row to {{quarantine output path}} with a `reason` column, logs a warning with counts, and the run continues.
| Field | Allowed | Reason code |
|---|---|---|
| {{field}} | {{range/set}} | {{code}} |

## Outputs
{{paths, formats, partitioning}}. Raw inputs under {{raw dir}} are never modified.

## Changing the contract
Update code + this file together, run on a sample, and report before/after row and quarantine counts in the review.
