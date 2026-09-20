# サンプルウェブアプリ

Flask を使った非常にシンプルなウェブアプリです。

## 実行方法

```bash
cd sample-webapp
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

ブラウザで http://localhost:5001 を開くと、名前入力フォームが表示されます。

※ macOS ではポート 5000 が AirPlay レシーバーと競合するため、5001 を使用しています。

## エンドポイント

| パス | 内容 |
|------|------|
| `/` | 名前を入力すると挨拶を表示 |
| `/health` | ヘルスチェック (JSON) |

## テスト

```bash
cd sample-webapp
pip install -r requirements.txt -r requirements-dev.txt
pytest
```

カバレッジを確認する場合:

```bash
pytest --cov=app --cov-report=term-missing
```
