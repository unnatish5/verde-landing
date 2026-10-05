Verde Say-Do Check (AI feature)
Paste a company sustainability claim and Verde shows what the claim specifies, what evidence is missing, and an Evidence Strength label. It reviews the wording of the claim, not the company, and never accuses anyone of greenwashing.
How it works
The visitor picks a claim type and pastes a claim (max 300 characters) on the landing page.
The page calls POST /api/check, a Vercel serverless function (api/check.js).
The function checks the visitor's cap, then calls Gemini (gemini-2.5-flash-lite) with a guarded system prompt.
The request and response are stored in the Supabase table claim_checks.
The page shows the review plus a live number from that table: the share of claims checked that had a major evidence gap (Weak or Insufficient), and the most common claim type.
Guardrails
Never says or implies a company is greenwashing, lying, or misleading.
Uses no outside knowledge about any named company.
Refuses non-sustainability input.
Ignores instructions hidden inside the claim text.
Gives no legal, investment, or purchasing advice.
Cost and abuse controls
Max output tokens: 350
5 checks per visitor (anonymous browser ID, counted in Supabase)
300 checks per day across all visitors
Claim limited to 300 characters
Secrets
No keys are stored in this repo. They live only in Vercel environment variables: GEMINI_API_KEY, SUPABASE_URL, SUPABASE_SERVICE_KEY. See .env.example for the names.
Files
api/check.js: serverless function (Gemini call, Supabase insert, caps, stats)
index.html: landing page with the Say-Do Check section
supabase.sql: table definition and Row Level Security
