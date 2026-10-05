-- Run this in Supabase: SQL Editor > New query > paste > Run

create table if not exists claim_checks (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  visitor_id text not null,          -- random anonymous id from the browser, not a person
  claim_type text not null,
  input text not null,               -- the claim text (visitors are told not to enter personal info)
  output text not null,              -- Gemini's review
  evidence_strength text not null,   -- Strong | Moderate | Weak | Insufficient | N/A
  input_tokens int,
  output_tokens int
);

create index if not exists claim_checks_visitor_idx on claim_checks (visitor_id);
create index if not exists claim_checks_created_idx on claim_checks (created_at);

-- Row Level Security ON with no policies = the public (anon) key can read/write nothing.
-- Only your Vercel function, using the service key, can touch this table.
alter table claim_checks enable row level security;

-- ---------------------------------------------------------------
-- Handy queries for your worksheet (run in the SQL Editor)
-- ---------------------------------------------------------------

-- Step 6, row 3: measured average tokens per request
-- select round(avg(input_tokens)) as avg_input, round(avg(output_tokens)) as avg_output, count(*) as rows
-- from claim_checks;

-- Step 5, row 3: the 5+ rows to screenshot
-- select id, created_at, claim_type, evidence_strength, input_tokens, output_tokens
-- from claim_checks order by id desc limit 10;
