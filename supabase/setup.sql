-- «لو | What iF» course ratings
-- Paste this whole file into Supabase → SQL Editor → New query → Run.

create table if not exists public.ratings (
  id          bigint generated always as identity primary key,
  course_code text     not null check (char_length(course_code) <= 20),
  device_id   uuid     not null,
  liked       boolean  not null,
  difficulty  smallint not null check (difficulty between 1 and 3),
  comment     text     check (char_length(comment) <= 200),
  hidden      boolean  not null default false,
  reports     int      not null default 0,
  created_at  timestamptz not null default now(),
  unique (course_code, device_id)          -- one rating per course per device
);

-- Nobody can read or write the table directly; the site only uses the functions below.
alter table public.ratings enable row level security;

-- Summary per course: number of ratings, likes, average difficulty
create or replace function public.get_stats()
returns table (course_code text, n bigint, likes bigint, diff numeric)
language sql security definer set search_path = public as $$
  select course_code, count(*), count(*) filter (where liked), round(avg(difficulty)::numeric, 2)
  from ratings group by course_code
$$;

-- Latest visible comments for one course
create or replace function public.get_comments(c text)
returns table (id bigint, liked boolean, difficulty smallint, comment text, created_at timestamptz)
language sql security definer set search_path = public as $$
  select id, liked, difficulty, comment, created_at from ratings
  where course_code = c and coalesce(comment, '') <> '' and not hidden
  order by created_at desc limit 300
$$;

-- Add or update this device's rating for a course
create or replace function public.rate(c text, d uuid, l boolean, df smallint, cm text)
returns void language plpgsql security definer set search_path = public as $$
begin
  if char_length(coalesce(cm, '')) > 200 then raise exception 'comment too long'; end if;
  insert into ratings (course_code, device_id, liked, difficulty, comment)
  values (c, d, l, df, nullif(trim(cm), ''))
  on conflict (course_code, device_id)
  do update set liked = excluded.liked, difficulty = excluded.difficulty, comment = excluded.comment, created_at = now();
end $$;

-- Report a comment; it hides itself after 5 reports
create or replace function public.report(rid bigint)
returns void language sql security definer set search_path = public as $$
  update ratings set reports = reports + 1, hidden = (reports + 1) >= 5 where id = rid
$$;

-- Every visible rating without device ids, for the automatic backup in the GitHub repo
create or replace function public.backup_ratings()
returns table (course_code text, liked boolean, difficulty smallint, comment text, created_at timestamptz)
language sql security definer set search_path = public as $$
  select course_code, liked, difficulty, comment, created_at from ratings where not hidden order by created_at
$$;

revoke all on function public.backup_ratings() from public;
grant execute on function public.backup_ratings() to anon, authenticated;

revoke all on function public.get_stats(), public.get_comments(text), public.rate(text, uuid, boolean, smallint, text), public.report(bigint) from public;
grant execute on function public.get_stats(), public.get_comments(text), public.rate(text, uuid, boolean, smallint, text), public.report(bigint) to anon, authenticated;
