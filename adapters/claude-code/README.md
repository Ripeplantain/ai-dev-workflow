# Claude Code adapter

Use the instruction files and project settings supported by the installed Claude Code version. Put the project-owned entry point in the location Claude Code officially loads, and have it reference this standard plus the nearest repository instructions.

The adapter should preserve the same sequence: discover, classify, load the relevant workflow/skill, implement, verify, review, and report. Do not assume that a Claude Code setting is portable to other tools; keep product-specific details here.

