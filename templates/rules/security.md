<!-- INSTALLER: Source for .agent/rules/security.md. Generate only when the project handles auth, secrets, user data, payments, network input, or infrastructure. Document WHERE sensitive things live, never their values. Delete every INSTALLER note. -->

# Rule: Security

## Sensitive areas in this project

Changes here are at least L3 and need independent review.

| Area | Location |
|---|---|
| {{AREA_FOR_EXAMPLE_AUTHENTICATION}} | `{{PATH}}` |

<!-- INSTALLER: Only areas that exist: authentication, authorization, session handling, payments, personal data, file upload, crypto, infrastructure permissions. -->

## Secrets and configuration

- Configuration is loaded via {{CONFIG_MECHANISM}}. Variable names are listed in `{{ENV_EXAMPLE_OR_CONFIG_SCHEMA_PATH}}`.
- Never write secret values into code, tests, logs, commits, or these workflow files.
- Never print the contents of {{SECRET_FILE_PATTERNS}}.

## Use the existing mechanisms

- Authentication and authorization: {{HOW_AND_WHERE_ENFORCED}}. New endpoints or handlers must go through it.
- Input validation: {{VALIDATION_MECHANISM_AND_EXAMPLE}}.
- Data access: {{HOW_QUERIES_ARE_BUILT_SAFELY}}.
- Output and rendering: {{ESCAPING_OR_SANITIZATION_MECHANISM}}.

<!-- INSTALLER: Keep only the bullets this project has a mechanism for. -->

## Do not

- Disable or bypass a security control, check, or CI gate to make something work.
- Write a parallel auth, validation, or crypto implementation.
- Add a dependency without a reason, a maintainer, and a compatible license.
- {{PROJECT_SPECIFIC_SECURITY_PROHIBITION}}

## When unsure

Stop and raise it. A security question is never resolved by guessing.
