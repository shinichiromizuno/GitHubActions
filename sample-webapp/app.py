from html import escape

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
    # HTMLテンプレートに埋め込む前にエスケープし、反射型XSSを防ぐ
    safe_name = escape(name)
    message = f"こんにちは、{safe_name}さん！" if safe_name else "名前を入力してください。"
    return PAGE.format(message=message)


# 動作確認用のヘルスチェック
@app.route("/health")
def health():
    return {"status": "ok"}


if __name__ == "__main__":
    # macOSではポート5000がAirPlayレシーバーと競合するため5001を使用
    # debug=Trueはリモートコード実行につながるWerkzeugデバッガを有効化するため、
    # 誤って本番運用してしまうリスクを避けるべく無効化する
    app.run(debug=False, port=5001)
