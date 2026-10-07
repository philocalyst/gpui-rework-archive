"""Exercise forge publishers through real urllib transport against localhost only."""

import base64
from contextlib import contextmanager
import hashlib
import json
import os
from pathlib import Path
import tempfile
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, unquote, urlsplit
import unittest
from unittest.mock import patch

import post_github_report as github
import post_gitlab_comment as gitlab
from test_post_github_report import PNG, add_native_replay, add_platform_checks, fixture_manifest, write_report


class ForgeState:
    def __init__(self):
        self.blobs = {}
        self.trees = {"root-tree": {}}
        self.commits = {"root-commit": {"tree": "root-tree", "parents": []}}
        self.refs = {"heads/visual-results": "root-commit"}
        self.comments = [{"id": 3, "user": {"type": "Bot"}, "body": "<!-- gpui-visual-test-report --> old"}]
        self.notes = [{"id": 8, "author": {"username": "gpui-bot"}, "body": "<!-- gpui-visual-test-report --> old"}]
        self.mr_shas = ["a" * 40]
        self.mr_reads = 0
        self.pr_shas = ["a" * 40]
        self.pr_reads = 0
        self.requests = []

    def gitlab_sha(self):
        index = min(self.mr_reads, len(self.mr_shas) - 1)
        self.mr_reads += 1
        return self.mr_shas[index]


@contextmanager
def local_forge():
    state = ForgeState()

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *_args):
            pass

        def send_json(self, value, status=200):
            body = json.dumps(value).encode()
            self.send_response(status)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        def read_json(self):
            return json.loads(self.rfile.read(int(self.headers.get("Content-Length", "0")) or 0))

        def do_GET(self):
            parsed = urlsplit(self.path)
            if parsed.path.startswith("/pages/"):
                path = unquote(parsed.path[len("/pages/"):])
                commit = state.refs["heads/visual-results"]
                tree = state.commits[commit]["tree"]
                blob_sha = state.trees[tree].get(path)
                if blob_sha is None:
                    return self.send_error(404)
                data = state.blobs[blob_sha]
                self.send_response(200)
                self.send_header("Content-Type", "text/html" if path.endswith(".html") else "image/png" if path.endswith(".png") else "image/svg+xml" if path.endswith(".svg") else "application/json")
                self.send_header("Content-Length", str(len(data)))
                self.end_headers()
                self.wfile.write(data)
                return

            state.requests.append(("GET", self.path, self.headers.get("Authorization"), self.headers.get("PRIVATE-TOKEN")))
            if parsed.path.startswith("/api/v3/") and self.headers.get("Authorization") != "Bearer local-token":
                return self.send_json({"message": "bad credentials"}, 401)
            if parsed.path.startswith("/gitlab/") and self.headers.get("PRIVATE-TOKEN") != "gitlab-local-token":
                return self.send_json({"message": "bad credentials"}, 401)
            route = parsed.path.removeprefix("/api/v3/")
            if route.startswith("repos/owner/repo/pulls/17"):
                index = min(state.pr_reads, len(state.pr_shas) - 1)
                state.pr_reads += 1
                self.send_json({"head": {"sha": state.pr_shas[index]}})
            elif route == "repos/owner/repo/git/ref/heads/visual-results":
                self.send_json({"object": {"sha": state.refs["heads/visual-results"]}})
            elif route.startswith("repos/owner/repo/git/commits/"):
                sha = route.rsplit("/", 1)[1]
                commit = state.commits[sha]
                self.send_json({"sha": sha, "tree": {"sha": commit["tree"]}, "parents": commit["parents"]})
            elif route.startswith("repos/owner/repo/git/trees/"):
                sha = route.rsplit("/", 1)[1]
                entries = [{"path": path, "type": "blob", "sha": blob} for path, blob in state.trees[sha].items() if "/" not in path]
                self.send_json({"tree": entries})
            elif route.startswith("repos/owner/repo/git/blobs/"):
                sha = route.rsplit("/", 1)[1]
                content = base64.b64encode(state.blobs[sha]).decode()
                # GitHub's API may wrap base64 content in the JSON response.
                content = "\n".join(content[index:index + 64] for index in range(0, len(content), 64))
                self.send_json({"encoding": "base64", "content": content})
            elif route.startswith("repos/owner/repo/issues/17/comments"):
                self.send_json(state.comments)
            elif parsed.path.startswith("/gitlab/api/v4/projects/group%2Fproject/merge_requests/9/notes"):
                self.send_json(state.notes)
            elif parsed.path.startswith("/gitlab/api/v4/projects/group%2Fproject/merge_requests/9"):
                self.send_json({"sha": state.gitlab_sha()})
            else:
                self.send_error(404)

        def do_POST(self):
            state.requests.append(("POST", self.path, self.headers.get("Authorization"), self.headers.get("PRIVATE-TOKEN")))
            parsed_path = urlsplit(self.path).path
            if parsed_path.startswith("/api/v3/") and self.headers.get("Authorization") != "Bearer local-token":
                return self.send_json({"message": "bad credentials"}, 401)
            if parsed_path.startswith("/gitlab/") and self.headers.get("PRIVATE-TOKEN") != "gitlab-local-token":
                return self.send_json({"message": "bad credentials"}, 401)
            payload = self.read_json()
            route = urlsplit(self.path).path.removeprefix("/api/v3/")
            if route == "repos/owner/repo/git/blobs":
                data = base64.b64decode(payload["content"], validate=True)
                sha = hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()
                state.blobs[sha] = data
                return self.send_json({"sha": sha}, 201)
            if route == "repos/owner/repo/git/trees":
                tree = dict(state.trees[payload["base_tree"]])
                for entry in payload["tree"]:
                    tree[entry["path"]] = entry["sha"]
                sha = hashlib.sha1(json.dumps(sorted(tree.items())).encode()).hexdigest()
                state.trees[sha] = tree
                return self.send_json({"sha": sha}, 201)
            if route == "repos/owner/repo/git/commits":
                sha = hashlib.sha1(json.dumps(payload, sort_keys=True).encode()).hexdigest()
                state.commits[sha] = {"tree": payload["tree"], "parents": payload["parents"]}
                return self.send_json({"sha": sha}, 201)
            if route == "repos/owner/repo/issues/17/comments":
                comment = {"id": 4, "user": {"type": "Bot"}, "body": payload["body"]}
                state.comments.append(comment)
                return self.send_json(comment, 201)
            if urlsplit(self.path).path.endswith("/merge_requests/9/notes"):
                note = {"id": 9, "author": {"username": "gpui-bot"}, "body": payload["body"]}
                state.notes.append(note)
                return self.send_json(note, 201)
            self.send_error(404)

        def do_PATCH(self):
            state.requests.append(("PATCH", self.path, self.headers.get("Authorization"), self.headers.get("PRIVATE-TOKEN")))
            if self.headers.get("Authorization") != "Bearer local-token":
                return self.send_json({"message": "bad credentials"}, 401)
            payload = self.read_json()
            route = urlsplit(self.path).path.removeprefix("/api/v3/")
            if route == "repos/owner/repo/git/refs/heads/visual-results":
                self.assert_token()
                assert payload["force"] is False
                state.refs["heads/visual-results"] = payload["sha"]
                return self.send_json({"ref": "refs/heads/visual-results"})
            if route == "repos/owner/repo/issues/comments/3":
                state.comments[0]["body"] = payload["body"]
                return self.send_json(state.comments[0])
            self.send_error(404)

        def do_PUT(self):
            state.requests.append(("PUT", self.path, self.headers.get("Authorization"), self.headers.get("PRIVATE-TOKEN")))
            if self.headers.get("PRIVATE-TOKEN") != "gitlab-local-token":
                return self.send_json({"message": "bad credentials"}, 401)
            payload = self.read_json()
            if urlsplit(self.path).path.endswith("/merge_requests/9/notes/8"):
                state.notes[0]["body"] = payload["body"]
                return self.send_json(state.notes[0])
            self.send_error(404)

        def assert_token(self):
            assert self.headers.get("Authorization") == "Bearer local-token"

    server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    try:
        host, port = server.server_address
        yield state, f"http://{host}:{port}"
    finally:
        server.shutdown()
        server.server_close()
        thread.join()


class ForgeHttpEndToEndTests(unittest.TestCase):
    def test_authentication_headers_are_enforced_by_local_forge(self):
        with local_forge() as (_state, base):
            with patch.dict(os.environ, {"GITHUB_API_URL": base + "/api/v3"}):
                with self.assertRaisesRegex(RuntimeError, "401:.*bad credentials"):
                    github.api("GET", "repos/owner/repo/pulls/17", "wrong-token")
            with self.assertRaisesRegex(RuntimeError, "401:.*bad credentials"):
                gitlab.api("GET", base + "/gitlab/api/v4/projects/group%2Fproject/merge_requests/9", "wrong-token")

    def test_github_head_that_moves_after_publication_skips_comment_update(self):
        with local_forge() as (state, base), tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            write_report(root / "report", fixture_manifest(status="baseline_unavailable"))
            state.pr_shas = ["a" * 40, "a" * 40, "b" * 40]
            env = {
                "GH_TOKEN": "local-token", "REPOSITORY": "owner/repo", "PR_NUMBER": "17",
                "HEAD_SHA": "a" * 40, "RUN_ID": "42", "GITHUB_API_URL": base + "/api/v3",
                "GITHUB_SERVER_URL": base, "PAGES_BRANCH": "visual-results", "PAGES_URL": base + "/pages",
            }
            with patch.dict(os.environ, env, clear=True), patch.object(github.sys, "argv", ["publisher", str(root / "report")]):
                self.assertEqual(github.main(), 0)
            self.assertEqual(state.comments[0]["body"], "<!-- gpui-visual-test-report --> old")
            self.assertNotEqual(state.refs["heads/visual-results"], "root-commit")
            self.assertFalse(any("/issues/17/comments" in path or "/issues/comments/" in path for _method, path, *_ in state.requests))

    def test_github_pages_and_comment_publish_over_real_http(self):
        with local_forge() as (state, base), tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = add_platform_checks(add_native_replay(fixture_manifest(metrics={"scene_build_p50_ns": 1_500_000, "bitmap_storage_bytes": 4096}, status="baseline_unavailable")))
            write_report(root / "report", manifest)
            (root / "report/metrics.svg").write_text('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2 2"><path d="M0 0"/></svg>')
            env = {
                "GH_TOKEN": "local-token", "REPOSITORY": "owner/repo", "PR_NUMBER": "17",
                "HEAD_SHA": "a" * 40, "RUN_ID": "42", "GITHUB_API_URL": base + "/api/v3",
                "GITHUB_SERVER_URL": base, "PAGES_BRANCH": "visual-results", "PAGES_URL": base + "/pages",
            }
            with patch.dict(os.environ, env, clear=True), patch.object(github.sys, "argv", ["publisher", str(root / "report")]):
                self.assertEqual(github.main(), 0)
                # A second publication must update the bot-owned note instead of adding a second one.
                self.assertEqual(github.main(), 0)

            self.assertEqual(len(state.comments), 1)
            comment = state.comments[0]["body"]
            self.assertIn("Timing graph", comment)
            self.assertIn("Bitmap bytes", comment)
            self.assertIn("4096", comment)
            self.assertIn("Device allocated bytes", comment)
            self.assertNotIn("GPU memory", comment)
            self.assertIn("n/a", comment)
            self.assertIn("![Timing graph]", comment)
            self.assertIn("Native GPU replay (diagnostic)", comment)
            self.assertIn("Native minus CPU (diagnostic difference)", comment)
            self.assertIn("Platform integration checks", comment)
            self.assertEqual(state.refs["heads/visual-results"] != "root-commit", True)
            self.assertTrue(any(method == "PATCH" and path.endswith("/git/refs/heads/visual-results") for method, path, *_ in state.requests))
            self.assertTrue(all(auth == "Bearer local-token" for method, path, auth, _private in state.requests if path.startswith("/api/v3/")))

            # Browsing the static root, immutable run page, and referenced chart/image exercises hosting paths and bytes.
            import urllib.request
            root_html = urllib.request.urlopen(base + "/pages/index.html", timeout=5).read().decode()
            run_html = urllib.request.urlopen(base + "/pages/runs/" + "a" * 40 + "/index.html", timeout=5).read().decode()
            self.assertIn("/pulls/17/index.html", root_html)
            self.assertIn('src="metrics.svg"', run_html)
            self.assertIn("4096", run_html)
            self.assertIn('id="platform-checks"', run_html)
            pull_html = urllib.request.urlopen(base + "/pages/pulls/17/index.html", timeout=5).read().decode()
            registry = json.loads(urllib.request.urlopen(base + "/pages/runs.json", timeout=5).read())
            self.assertIn("/runs/" + "a" * 40 + "/index.html", pull_html)
            self.assertEqual(registry, [{"sha": "a" * 40, "pr": "17"}])
            current_tree = state.trees[state.commits[state.refs["heads/visual-results"]]["tree"]]
            self.assertIn("runs.json", current_tree)
            image = urllib.request.urlopen(base + "/pages/runs/" + "a" * 40 + "/gallery/initial.png", timeout=5).read()
            self.assertTrue(image.startswith(b"\x89PNG"))
            native_image = urllib.request.urlopen(base + "/pages/runs/" + "a" * 40 + "/gallery/initial.native.png", timeout=5).read()
            self.assertTrue(native_image.startswith(b"\x89PNG"))
            native_diff = urllib.request.urlopen(base + "/pages/runs/" + "a" * 40 + "/gallery/initial.native.diff.png", timeout=5).read()
            self.assertTrue(native_diff.startswith(b"\x89PNG"))
            chart = urllib.request.urlopen(base + "/pages/runs/" + "a" * 40 + "/metrics.svg", timeout=5).read()
            self.assertIn(b"<svg", chart)

    def test_gitlab_note_update_and_stale_head_race_use_real_http(self):
        sha = "a" * 40
        with local_forge() as (state, base), tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            write_report(root / "visual-report", fixture_manifest(status="baseline_unavailable"))
            env = {
                "GITLAB_API_TOKEN": "gitlab-local-token", "CI_API_V4_URL": base + "/gitlab/api/v4",
                "CI_PROJECT_ID": "group/project", "CI_MERGE_REQUEST_IID": "9", "CI_COMMIT_SHA": sha,
                "GPUI_GITLAB_BOT_USERNAME": "gpui-bot", "GPUI_VISUAL_REPORT_URL": base + "/job/artifacts",
            }
            old_cwd = Path.cwd()
            try:
                os.chdir(root)
                # Stable MR SHA: the existing bot note is updated through the actual HTTP client.
                with patch.dict(os.environ, env, clear=True):
                    self.assertEqual(gitlab.main(), 0)
                self.assertIn("No baseline capture", state.notes[0]["body"])
                self.assertTrue(any(method == "PUT" and path.endswith("/notes/8") for method, path, *_ in state.requests))
                self.assertTrue(all(private == "gitlab-local-token" for method, path, _auth, private in state.requests if path.startswith("/gitlab/")))

                # Head moves between the two MR reads: no note list or write may follow.
                state.requests.clear()
                state.mr_reads = 0
                state.mr_shas = [sha, "b" * 40]
                with patch.dict(os.environ, env, clear=True):
                    self.assertEqual(gitlab.main(), 0)
                self.assertEqual(sum("/merge_requests/9" in path and "/notes" not in path for _method, path, *_ in state.requests), 2)
                self.assertFalse(any("/notes" in path for _method, path, *_ in state.requests))
            finally:
                os.chdir(old_cwd)


if __name__ == "__main__":
    unittest.main()
