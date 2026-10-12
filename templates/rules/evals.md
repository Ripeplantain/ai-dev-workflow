# Evals

Owner: evaluator. Location: {{evals dir}}. Runner: {{command using the project's test runner}}.

## Cases
`cases.jsonl`, one case per line:
`{"id": "...", "input": {...}, "expect": {"properties": [...]}, "tags": ["..."]}`
Expect properties, not exact strings: "cites a statute", "returns valid JSON matching Schema X", "refuses when asked for Y".

## Graders, cheapest first
1. Deterministic: schema parses, required fields, length bounds, refusal checks.
2. Pattern: regex/contains.
3. LLM judge: only for what 1–2 cannot check. Judge prompt is versioned too.

## Results
Each run records prompt version ({{where PROMPT_VERSION lives}}), model ID, provider, pass rate, per-case results, and estimated cost.

## Prompt versioning
Prompts live in {{prompt file(s)}} with a version constant. Any prompt change bumps it and runs evals old vs new before review.

## Cost
Paid eval runs above {{N}} calls are a checkpoint.
