# Testing Notes (Test Improver)

- Repo is primarily a collection of demo GitHub Actions workflows for learning;
  very little "application" code exists. Main testable surface is
  `sample-webapp/app.py` (Flask, 2 routes: `/` and `/health`).
- 2026-09-20: Added `sample-webapp/tests/test_app.py` (7 tests) using
  Flask test client. Coverage 92% (only `if __name__ == "__main__"` guard
  uncovered - correctly excluded per "what not to test" trivial code guidance).
- Noted (not filed as bug, documented in test comment): app.py's `/` route
  builds HTML via `PAGE.format(message=...)` without escaping user input from
  `request.args.get("name")`. This is a potential reflected-XSS risk since
  Flask's raw string response is not Jinja-autoescaped. Test
  `test_index_escapes_html_in_name_to_prevent_injection` documents current
  (unsafe) behavior rather than asserting it's fixed - flagging this to
  maintainers is worth doing if they want it addressed as a real fix (would
  require jinja2 templating or manual escaping, which is a behavior change
  outside test-only scope).
- No other application/library code exists yet to test as of this run.
