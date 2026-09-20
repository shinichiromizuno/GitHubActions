# Validated Commands (Test Improver)

## Repository: shinichiromizuno/GitHubActions
Last validated: 2026-09-20

Repo is mostly GitHub Actions workflow demos (.github/workflows/*.yml) plus
a small `sample-webapp/` Flask app and `infra/` Bicep templates. No CI test
job existed before this run.

### sample-webapp (Python/Flask)
- Setup: `cd sample-webapp && pip install -r requirements.txt -r requirements-dev.txt`
  (requirements-dev.txt added by Test Improver: pytest, pytest-cov)
- Test: `pytest` (run from sample-webapp/)
- Coverage: `pytest --cov=app --cov-report=term-missing`
- No lint/format tooling configured (no flake8/black/ruff config found).

### infra/ (Bicep)
- Not validated for testing; likely deployment-only, no test framework applicable.

### Workflows (.github/workflows/*.yml)
- Demo/example GitHub Actions workflows; no test harness applicable.
