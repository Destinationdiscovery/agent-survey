-- Run this once in Supabase: SQL Editor > New query > paste > Run

create table if not exists public.survey_responses (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  source text,
  time_consuming text,
  tool_spend text,
  ai_used text,
  ai_tools text,
  ai_last_use text,
  ai_worked text,
  ai_change text,
  wish_tool text,
  barriers text,
  concerns text,
  paid_for_ai text,
  years_licensed text,
  deals_last_year text,
  brokerage_size text,
  followup_ok boolean not null default false,
  contact_name text,
  contact_email text,
  constraint answers_not_too_long check (
    char_length(coalesce(source, '')) <= 100
    and char_length(coalesce(time_consuming, '')) <= 5000
    and char_length(coalesce(tool_spend, '')) <= 5000
    and char_length(coalesce(ai_used, '')) <= 5000
    and char_length(coalesce(ai_tools, '')) <= 5000
    and char_length(coalesce(ai_last_use, '')) <= 5000
    and char_length(coalesce(ai_worked, '')) <= 5000
    and char_length(coalesce(ai_change, '')) <= 5000
    and char_length(coalesce(wish_tool, '')) <= 5000
    and char_length(coalesce(barriers, '')) <= 5000
    and char_length(coalesce(concerns, '')) <= 5000
    and char_length(coalesce(paid_for_ai, '')) <= 5000
    and char_length(coalesce(years_licensed, '')) <= 200
    and char_length(coalesce(deals_last_year, '')) <= 200
    and char_length(coalesce(brokerage_size, '')) <= 200
    and char_length(coalesce(contact_name, '')) <= 200
    and char_length(coalesce(contact_email, '')) <= 320
  )
);

-- Row level security: the public page can ADD responses but can never read them.
alter table public.survey_responses enable row level security;

drop policy if exists "Anyone can submit a response" on public.survey_responses;
create policy "Anyone can submit a response"
  on public.survey_responses
  for insert
  to anon
  with check (true);

-- Explicit permissions, so this works whether or not "Automatically expose
-- new tables" was ticked when the project was created: the public page gets
-- INSERT only, nothing else.
revoke all on public.survey_responses from anon, authenticated;
grant insert on public.survey_responses to anon;

-- No select policy exists on purpose. You read results in the Supabase
-- Table Editor (logged in), where you can also export to CSV.
