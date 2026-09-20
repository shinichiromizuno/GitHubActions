from flask import Flask, request

app = Flask(__name__)

# トップページ: 名前を入力するフォームを表示し、送信されたら挨拶を返す
PAGE = """
<!doctype html>
<html lang="ja">
<head><meta charset="utf-8"><title>サンプルアプリ</title></head>
<body>
  <h1>サンプルウェブアプリ</h1>
  <p>{message}</p>
  <form method="get" action="/">
    <input name="name" placeholder="お名前">
    <button type="submit">送信</button>
  </form>
</body>
</html>
"""


@app.route("/")
def index():
    name = request.args.get("name", "").strip()
    message = f"こんにちは、{name}さん！" if name else "名前を入力してください。"
    return PAGE.format(message=message)


# 動作確認用のヘルスチェック
@app.route("/health")
def health():
    return {"status": "ok"}


if __name__ == "__main__":
    # macOSではポート5000がAirPlayレシーバーと競合するため5001を使用
    app.run(debug=True, port=5001)
