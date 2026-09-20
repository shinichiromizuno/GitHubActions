# Testing Backlog (Test Improver)

## Completed
- [x] 2026-09-20: sample-webapp Flask app unit tests (7 tests, 92% coverage) - PR pending

## Open / Future
- Consider adding a CI workflow (e.g. `.github/workflows/sample-webapp-tests.yml`)
  to run `pytest` on sample-webapp changes automatically. Flagged as Task 6
  (test infrastructure) candidate for a future run - not done yet to keep this
  PR small/focused.
- Consider flagging the unescaped `name` HTML injection in app.py's index route
  to maintainers as a potential security issue (see notes.md). Not filed as an
  issue yet - low severity demo app, but worth a heads-up.
- No other app/library code in the repo yet; re-scan on future runs in case
  new modules are added.

## Run log
- 2026-09-20: PR created for sample-webapp tests; Monthly Activity issue created (2026-09-20 05:34 UTC run, run 35491958063).
