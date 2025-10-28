from flask import Flask, render_template, request
import json, os

app = Flask(__name__)

BOOKS_PATH = os.path.join(app.root_path, "books.json")
CACHE_PATH = os.path.join(app.root_path, "tmp", "verse_cache.json")

os.makedirs(os.path.dirname(CACHE_PATH), exist_ok=True)

# ---------- Helpers ----------
def load_books():
    """Load 66 Bible books from JSON."""
    with open(BOOKS_PATH, "r", encoding="utf-8") as f:
        return json.load(f)

def save_selection(selection):
    """Save current verse selection to cache."""
    with open(CACHE_PATH, "w", encoding="utf-8") as f:
        json.dump(selection, f, ensure_ascii=False, indent=2)

def load_selection():
    """Load current verse selection from cache file."""
    if not os.path.exists(CACHE_PATH):
        return {}

    try:
        with open(CACHE_PATH, "r", encoding="utf-8") as f:
            content = f.read().strip()
            if not content:
                return {}
            return json.loads(content)
    except (json.JSONDecodeError, OSError):
        return {}

def clear_selection():
    """Delete the cache file if it exists."""
    if os.path.exists(CACHE_PATH):
        os.remove(CACHE_PATH)


# ---------- Routes ----------
@app.route("/", methods=["GET", "POST"])
def index():
    books = load_books()
    selection = load_selection()
    message = None

    if request.method == "POST":
        action = request.form.get("action")

        if action == "clear":
            clear_selection()
            selection = None
            message = "🧹 Cleared current selection."

        elif action == "submit":
            selected_book_en = request.form.get("book")
            selected_book_hi = next(
                (b["hindi"] for b in books if b["english"] == selected_book_en),
                None
            )
            selected_chapter = request.form.get("chapter")
            selected_verses = request.form.get("verses")

            selection = {
                "book_en": selected_book_en,
                "book_hi": selected_book_hi,
                "chapter": selected_chapter,
                "verses": selected_verses,
            }
            save_selection(selection)
            message = f"✅ Saved: {selected_book_en} | {selected_book_hi} {selected_chapter}:{selected_verses}"

    return render_template("index.html", books=books, selection=selection, message=message)


@app.route("/display")
def display():
    selection = load_selection()
    return render_template("display.html", selection=selection)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)
