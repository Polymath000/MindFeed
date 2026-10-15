import "jsr:@supabase/functions-js/edge-runtime.d.ts";

function escapeHtml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

Deno.serve(async (req: Request) => {
  const url = new URL(req.url);
  const code = url.searchParams.get("code");
  const tokenHash = url.searchParams.get("token_hash");
  const accessToken = url.searchParams.get("access_token");
  const error = url.searchParams.get("error");
  const errorCode = url.searchParams.get("error_code");
  const errorDescription = url.searchParams.get("error_description");

  const serverHasError = Boolean(error || errorCode || errorDescription);
  const serverHasSuccess = !serverHasError && Boolean(code || tokenHash || accessToken);

  let initialContent = "";

  if (serverHasError) {
    const message = errorDescription || error || errorCode || "The confirmation link is invalid or has expired. Please open the MindFeed app and request a new verification code.";
    initialContent = `
      <div class="badge error">&times;</div>
      <h1>Confirmation Failed</h1>
      <p id="error-desc">${escapeHtml(message)}</p>
      <a href="mindfeed://login-callback" class="btn">Return to MindFeed</a>
    `;
  } else if (serverHasSuccess) {
    const deepLink = `mindfeed://login-callback${url.search}`;
    initialContent = `
      <div class="badge">&#10003;</div>
      <h1>Email Confirmed</h1>
      <p>Your email has been verified. Welcome to MindFeed. You can now return to the application to explore your personalized editorial feed.</p>
      <a id="open-app-btn" href="${escapeHtml(deepLink)}" class="btn">Open MindFeed App</a>
      <div class="fallback">
        If you are on a desktop or the app does not open automatically, simply return to the MindFeed application on your device to sign in.
      </div>
    `;
  } else {
    initialContent = `
      <div class="badge standby">&#9679;</div>
      <h1>MindFeed Verification</h1>
      <p>No active verification parameters were detected. If you are confirming your account, please click the link sent to your email or enter your 6-digit verification code in the MindFeed application.</p>
      <a href="mindfeed://login-callback" class="btn">Open MindFeed App</a>
    `;
  }

  const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MindFeed &mdash; Account Confirmation</title>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    body {
      background-color: #F8F6F0;
      color: #171614;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
    }
    .card {
      background-color: #FFFDF8;
      border: 1px solid #E5DECE;
      border-radius: 8px;
      max-width: 480px;
      width: 100%;
      padding: 40px 32px;
      box-shadow: 0 4px 20px rgba(23, 22, 20, 0.05);
      text-align: center;
    }
    .masthead {
      border-top: 1px solid #171614;
      border-bottom: 1px solid #171614;
      padding: 8px 0;
      margin-bottom: 28px;
      letter-spacing: 3px;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
    }
    .badge {
      display: inline-block;
      width: 56px;
      height: 56px;
      line-height: 56px;
      border-radius: 50%;
      background-color: #171614;
      color: #FFF8E6;
      font-size: 24px;
      margin-bottom: 20px;
    }
    .badge.error {
      background-color: #EF4444;
      color: #FFFFFF;
    }
    .badge.standby {
      background-color: #64748B;
      color: #FFFFFF;
    }
    h1 {
      font-family: Georgia, "Times New Roman", serif;
      font-size: 28px;
      font-weight: 700;
      margin-bottom: 12px;
      color: #171614;
    }
    p {
      font-size: 15px;
      line-height: 1.6;
      color: #514D46;
      margin-bottom: 28px;
    }
    .btn {
      display: inline-block;
      width: 100%;
      background-color: #171614;
      color: #FFF8E6;
      text-decoration: none;
      padding: 14px 20px;
      border-radius: 6px;
      font-size: 15px;
      font-weight: 600;
      transition: background-color 0.2s;
    }
    .btn:hover {
      background-color: #383530;
    }
    .fallback {
      margin-top: 24px;
      font-size: 13px;
      color: #8E8E93;
      line-height: 1.5;
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="masthead">MindFeed &bull; The Editorial Journal</div>
    <div id="content">
      ${initialContent}
    </div>
  </div>

  <script>
    (function() {
      function escape(str) {
        return (str || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
      }

      var currentUrl = new URL(window.location.href);
      var query = currentUrl.searchParams;
      var hash = window.location.hash ? window.location.hash.substring(1) : "";
      var hashParams = new URLSearchParams(hash);

      var error = query.get("error") || hashParams.get("error");
      var errorCode = query.get("error_code") || hashParams.get("error_code");
      var errorDesc = query.get("error_description") || hashParams.get("error_description");

      var contentEl = document.getElementById("content");

      if (error || errorCode || errorDesc) {
        var msg = errorDesc || error || errorCode || "The confirmation link is invalid or has expired.";
        contentEl.innerHTML = '<div class="badge error">&times;</div>' +
          '<h1>Confirmation Failed</h1>' +
          '<p>' + escape(decodeURIComponent(msg.replace(/\\+/g, " "))) + '</p>' +
          '<a href="mindfeed://login-callback" class="btn">Return to MindFeed</a>';
        return;
      }

      var code = query.get("code") || hashParams.get("code");
      var tokenHash = query.get("token_hash") || hashParams.get("token_hash");
      var accessToken = query.get("access_token") || hashParams.get("access_token");

      if (code || tokenHash || accessToken) {
        var deepLink = "mindfeed://login-callback";
        var search = currentUrl.search;
        if (search && search.length > 1) {
          deepLink += search;
        } else if (hash && hash.length > 0) {
          deepLink += "#" + hash;
        }

        contentEl.innerHTML = '<div class="badge">&#10003;</div>' +
          '<h1>Email Confirmed</h1>' +
          '<p>Your email has been verified. Welcome to MindFeed. You can now return to the application to explore your personalized editorial feed.</p>' +
          '<a id="open-app-btn" href="' + escape(deepLink) + '" class="btn">Open MindFeed App</a>' +
          '<div class="fallback">If you are on a desktop or the app does not open automatically, simply return to the MindFeed application on your device to sign in.</div>';

        setTimeout(function() {
          window.location.href = deepLink;
        }, 400);
      }
    })();
  </script>
</body>
</html>`;

  return new Response(html, {
    headers: {
      "Content-Type": "text/html; charset=utf-8",
      "Cache-Control": "no-store, max-age=0",
    },
  });
});
