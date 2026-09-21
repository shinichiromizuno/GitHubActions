# Testing Backlog (Test Improver)

## Completed
- [x] 2026-09-20: sample-webapp Flask app unit tests (7 tests, 92-93% coverage) - PR #6 merged.
- [x] 2026-09-20: Reflected-XSS in app.py's `/` route (unescaped `name` param) and
  Flask debug=True fixed by maintainer via PR #8 (security-fix, merged). Test
  `test_index_escapes_html_in_name_to_prevent_injection` now asserts the
  escaped/fixed behaviour.
- [x] 2026-09-21: Added `.github/workflows/sample-webapp-tests.yml` CI job
  running the sample-webapp pytest suite w/ coverage on push/PR touching
  `sample-webapp/**`. PR: test-assist/sample-webapp-ci-workflow (Task 6,
  test infrastructure).

## Open / Future
- No other app/library code in the repo yet (rest is demo GitHub Actions
  workflow YAML + Bicep templates); re-scan on future runs in case new
  modules are added.
- Consider adding a lint/format step (e.g. ruff/black) to the new CI workflow
  if maintainer wants stricter code quality gates - not added yet since no
  lint config exists in the repo (avoid introducing tooling without
  discussion first).

## Run log
- 2026-09-20: PR created for sample-webapp tests; Monthly Activity issue created (2026-09-20 05:34 UTC run, run 35491958063).
- 2026-09-21: Task 6 (test infrastructure) - added CI workflow for
  sample-webapp tests (run 35637095599).
