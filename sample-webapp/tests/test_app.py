"""Tests for the sample Flask app (sample-webapp/app.py).

Run with:
    cd sample-webapp
    pip install -r requirements.txt -r requirements-dev.txt
    pytest
"""
import os
import sys

# Allow running pytest from the repo root or from sample-webapp/.
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
from app import app


@pytest.fixture
def client():
    app.config.update(TESTING=True)
    with app.test_client() as test_client:
        yield test_client


def test_index_without_name_prompts_for_input(client):
    """No name query param -> prompt message, not a greeting."""
    response = client.get("/")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    assert "名前を入力してください。" in body
    assert "こんにちは" not in body


def test_index_with_name_returns_greeting(client):
    response = client.get("/?name=Alice")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    assert "こんにちは、Aliceさん！" in body


def test_index_with_whitespace_only_name_is_treated_as_empty(client):
    """Name consisting only of whitespace should be stripped to empty,
    matching the same behaviour as no name at all."""
    response = client.get("/?name=%20%20%20")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    assert "名前を入力してください。" in body


def test_index_strips_surrounding_whitespace_from_name(client):
    response = client.get("/?name=%20Bob%20")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    assert "こんにちは、Bobさん！" in body


def test_index_escapes_html_in_name_to_prevent_injection(client):
    """The greeting is built with str.format() into a raw HTML template.
    If the name contains HTML/script it must not be rendered unescaped,
    since Flask's Response used here is plain text, not auto-escaped by Jinja."""
    response = client.get("/?name=<script>alert(1)</script>")
    assert response.status_code == 200
    body = response.get_data(as_text=True)
    # Document current behavior: the app does not escape user input.
    # This is a potential XSS risk since the name is echoed back verbatim.
    assert "<script>alert(1)</script>" in body


def test_health_endpoint_returns_ok_json(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_health_endpoint_content_type_is_json(client):
    response = client.get("/health")
    assert response.content_type == "application/json"
