# Get Buff Tracker

A private daily/weekly tracker: 30-minute walk, 10-minute core, alcohol-free days, water,
weekly meal prep, Monday weigh-in. Weekly percentage scoring, no streaks.

Start: 18st 4lb / 49" (6 Sep 2026) → 16st 0lb by Christmas → 13st 7lb / 36" by 30 Apr 2027.

---

## It already works

Open `index.html` in any browser and start ticking. With no Supabase details filled in it
stores everything in that browser on that device — useful for trying it, but your phone and
laptop keep separate logs. Do the Supabase step to fix that.

---

## Step 1 — Put it on GitHub Pages

**Important:** GitHub Pages only serves *public* repos on a free account. That is fine here —
the repo contains code, never your data. Your logs live in Supabase behind an email login, and
the only key in the code is the Supabase **anon** key, which is designed to be public and is
useless without row-level security passing (see Step 2). If you'd rather the repo stayed
private, host it on Cloudflare Pages or Netlify instead — both serve private repos free.

1. github.com → **New repository** → name it `get-buff-tracker` → **Public** → Create.
2. Upload every file in this folder (`index.html`, `manifest.webmanifest`, `sw.js`,
   the four `.png` icons) — drag and drop works.
3. Repo → **Settings** → **Pages** → Source: *Deploy from a branch* → Branch: `main`, folder `/ (root)` → Save.
4. Wait a minute. Your app is at **https://pwfapp.github.io/get-buff-tracker/**

## Step 2 — Supabase, so phone and desktop agree

1. supabase.com → sign in with GitHub → **New project**. Name it `get-buff`, pick a strong
   database password (save it in your password manager), region **London (eu-west-2)**, free plan.
2. When it's ready: left sidebar → **SQL Editor** → **New query** → paste all of `schema.sql` → **Run**.
   You should see "Success. No rows returned."
3. Left sidebar → **Project Settings** → **API**. Copy:
   - **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - **anon / public** key (a long string starting `eyJ...`)
4. Open `index.html`, find the `CONFIG` block near the top of the `<script>`, and paste them in:

   ```js
   supabaseUrl:     'https://abcdefgh.supabase.co',
   supabaseAnonKey: 'eyJhbGciOi...',
   ```

5. **Authentication** → **URL Configuration** → set **Site URL** to
   `https://pwfapp.github.io/get-buff-tracker/` and add the same URL under **Redirect URLs**.
6. Commit the edited `index.html` to GitHub. Reload the app, enter your email, click the link
   Supabase sends you. That's the only sign-in step — no password.

## Step 3 — Put it on your phone

Open the Pages URL in Chrome on your Pixel → ⋮ menu → **Add to Home screen**. It opens
full-screen with its own icon and works offline for ticking (it syncs when you're back online).

---

## Changing anything

Everything adjustable lives in the `CONFIG` block at the top of the script in `index.html`:

| Setting | What it does |
|---|---|
| `start` / `milestone` / `goal` | The three points of the pace line — date, weight in **pounds**, waist in inches |
| `dryTarget` | Alcohol-free days per week that count toward the score (currently 4) |
| `backfillDays` | How many days back you can still tick (currently 3) |
| `threshold` | Weekly percentage needed for a green week (currently 0.80) |
| `DAILY` | The daily checklist itself — add, remove or rename items |

If you edit `index.html`, bump `CACHE = 'gbt-v1'` in `sw.js` to `gbt-v2` etc., otherwise your
phone may keep serving the old cached version.

## How the weekly score works

A full week is worth 27 ticks: 7 walks + 7 core + 7 water + 4 dry days + 1 meal prep + 1 weigh-in.

- Dry days count up to 4. Doing 6 is great, but it can't push you over 100%.
- Meal prep only starts counting from Friday, so doing it on Sunday doesn't drag Monday down.
- Part-way through a week the target scales to the days that have actually happened, so a good
  Monday reads as 100%, not 15%.
- 80% or better = green week. One bad day never wipes out a week.

## Your data

- Row-level security means each row is readable only by the account that wrote it. Even with the
  public anon key, nobody else can read your logs.
- **History → Export all data (CSV)** gives you everything, any time.
- Free Supabase projects pause after a week of no activity — opening the app wakes it up. If you
  stop using it for months, log in to Supabase and un-pause the project.
