-- Get Buff Tracker — Supabase schema
-- Paste this whole file into the Supabase SQL Editor and press Run.

create table if not exists public.logs (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users(id) on delete cascade default auth.uid(),
  day        date not null,
  walk       boolean not null default false,
  core       boolean not null default false,
  dry        boolean not null default false,
  water      boolean not null default false,
  prep       boolean not null default false,
  bonus      text,
  weight_lb  numeric,
  waist_in   numeric,
  updated_at timestamptz not null default now(),
  unique (user_id, day)
);

create index if not exists logs_user_day_idx on public.logs (user_id, day);

-- Row-level security: every row is readable and writable ONLY by the user who owns it.
-- Without this, anyone holding the public anon key could read the table.
alter table public.logs enable row level security;

drop policy if exists "own rows select" on public.logs;
drop policy if exists "own rows insert" on public.logs;
drop policy if exists "own rows update" on public.logs;
drop policy if exists "own rows delete" on public.logs;

create policy "own rows select" on public.logs
  for select using (auth.uid() = user_id);

create policy "own rows insert" on public.logs
  for insert with check (auth.uid() = user_id);

create policy "own rows update" on public.logs
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own rows delete" on public.logs
  for delete using (auth.uid() = user_id);

-- Keep updated_at honest.
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists logs_touch on public.logs;
create trigger logs_touch before update on public.logs
  for each row execute function public.touch_updated_at();
