import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient, type EmailOtpType } from "jsr:@supabase/supabase-js@2";

Deno.serve(async (req: Request) => {
  const url = new URL(req.url);
  const tokenHash = url.searchParams.get("token_hash");
  const type = url.searchParams.get("type") as EmailOtpType | null;

  if (tokenHash && type) {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      { auth: { persistSession: false } },
    );

    const { error } = await supabase.auth.verifyOtp({
      token_hash: tokenHash,
      type,
    });

    if (error) {
      return Response.redirect(
        `mindfeed://login-callback?error=access_denied&error_description=${encodeURIComponent(error.message)}`,
        302,
      );
    }

    return Response.redirect("mindfeed://login-callback?verified=true", 302);
  }

  const deepLink = `mindfeed://login-callback${url.search}`;
  return Response.redirect(deepLink, 302);
});
