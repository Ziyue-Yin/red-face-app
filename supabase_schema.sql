-- ============ 红脸蛋研究所 · Supabase 建库脚本 ============
-- 在 Supabase Dashboard → SQL Editor 里整段粘贴运行即可

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  name text,
  skin_type text,
  allergy text,
  history text,
  meds text,
  note text,
  avatar text,
  updated_at timestamptz default now()
);

create table if not exists public.records (
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  data jsonb not null,
  saved_at bigint,
  updated_at timestamptz default now(),
  primary key (user_id, date)
);

create table if not exists public.custom_tags (
  user_id uuid not null references auth.users(id) on delete cascade,
  category text not null,
  value text not null,
  created_at timestamptz default now(),
  primary key (user_id, category, value)
);

create table if not exists public.hidden_tags (
  user_id uuid not null references auth.users(id) on delete cascade,
  category text not null,
  value text not null,
  created_at timestamptz default now(),
  primary key (user_id, category, value)
);

create table if not exists public.weekly_archives (
  user_id uuid not null references auth.users(id) on delete cascade,
  id text not null,
  start_date date,
  end_date date,
  count int,
  text text,
  saved_at bigint,
  auto boolean default false,
  primary key (user_id, id)
);

alter table public.profiles        enable row level security;
alter table public.records         enable row level security;
alter table public.custom_tags     enable row level security;
alter table public.hidden_tags     enable row level security;
alter table public.weekly_archives enable row level security;

drop policy if exists "own profile"  on public.profiles;
drop policy if exists "own records"  on public.records;
drop policy if exists "own custom"   on public.custom_tags;
drop policy if exists "own hidden"   on public.hidden_tags;
drop policy if exists "own archives" on public.weekly_archives;

create policy "own profile"  on public.profiles        for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own records"  on public.records         for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own custom"   on public.custom_tags     for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own hidden"   on public.hidden_tags     for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own archives" on public.weekly_archives for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
