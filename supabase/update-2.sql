-- «لو | What iF» — update 2 (run once in Supabase → SQL Editor → New query → Run)
-- 1) show up to 300 comments per course instead of 30
create or replace function public.get_comments(c text)
returns table (id bigint, liked boolean, difficulty smallint, comment text, created_at timestamptz)
language sql security definer set search_path = public as $$
  select id, liked, difficulty, comment, created_at from ratings
  where course_code = c and coalesce(comment, '') <> '' and not hidden
  order by created_at desc limit 300
$$;

-- 2) every visible rating without device ids, for the automatic backup in the GitHub repo
create or replace function public.backup_ratings()
returns table (course_code text, liked boolean, difficulty smallint, comment text, created_at timestamptz)
language sql security definer set search_path = public as $$
  select course_code, liked, difficulty, comment, created_at from ratings where not hidden order by created_at
$$;

revoke all on function public.backup_ratings() from public;
grant execute on function public.backup_ratings() to anon, authenticated;

-- 3) a comment hides itself after 5 reports (was 3)
create or replace function public.report(rid bigint)
returns void language sql security definer set search_path = public as $$
  update ratings set reports = reports + 1, hidden = (reports + 1) >= 5 where id = rid
$$;
