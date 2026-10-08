# Agent Tools Survey: setup (about 15 minutes, all free tiers)

Three files matter: `index.html` (the survey), `schema.sql` (the database table), `vercel.json` (tiny config).

## 1. Create the table in Supabase
1. Open your Supabase project (or create a new free one named something like `agent-survey`).
   When creating it: skip "Connect GitHub", generate and save a strong database password in a password manager (this survey never uses it), keep "Enable Data API" ticked, untick "Automatically expose new tables", and tick "Enable automatic RLS".
2. Go to **SQL Editor > New query**.
3. Paste the contents of `schema.sql` and click **Run**.
4. Check **Table Editor**: you should see `survey_responses`.

The table is locked so the public page can only ADD rows. Nobody with the survey link can read anyone's answers. You read them while logged in to Supabase.

## 2. Connect the page to Supabase
(Already done in this copy: `index.html` contains the URL and anon key for the `agent-survey` project. Skip to step 3. If you ever move to a different project, follow the steps below.)

1. In Supabase go to **Project Settings > API**.
2. Copy the **Project URL** and the **anon / publishable** key.
   Do NOT use the `service_role` or secret key. Those must never go in a web page.
3. Open `index.html` and replace the two placeholders near the bottom:
   ```
   var SUPABASE_URL = "PASTE_YOUR_SUPABASE_PROJECT_URL_HERE";
   var SUPABASE_KEY = "PASTE_YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY_HERE";
   ```
   The anon key is designed to be public. The table lock in step 1 is what protects the data.

## 3. Put it on GitHub and Vercel
1. Create a new GitHub repository (for example `agent-survey`) and upload the three files to the top level of the repo.
2. In Vercel: **Add New > Project**, import that repo. Leave all build settings empty (it is a plain static page) and click **Deploy**.
3. Vercel gives you a link like `agent-survey.vercel.app`.

## 4. Test it yourself first
1. Open the link, fill in a couple of answers, submit.
2. In Supabase **Table Editor > survey_responses** the row should appear.
3. If it says "not saved": re-check the URL and key in `index.html`, and that `schema.sql` ran without errors.
4. Delete your test row(s) in the Table Editor before sending it out.

## 5. Track where responses come from
Add `?src=` to the link to label each channel. The label is stored in the `source` column.
- `agent-survey.vercel.app/?src=jake`
- `agent-survey.vercel.app/?src=brokerage`
- `agent-survey.vercel.app/?src=fb-ontario-agents`

This lets you see later whether different groups answer differently.

## 6. Get your results out
- **Table Editor:** browse the rows. Use **Export > CSV** to download everything.
- Bring the CSV back to Claude and ask it to group the open-text answers into categories and compare them against the national survey numbers.

## Notes
- The page sets `noindex` so search engines will not list it. Anyone with the link can still submit.
- There is no rate limit, only a hidden spam trap field. If you ever get junk submissions, tell me and I will add a check.
- Name and email are optional. Before wide sharing, consider telling people how long you will keep their answers and who sees them.
- Later, to reuse this for other professions (travel agents and so on), copy the repo, change the wording, and use a new table.
