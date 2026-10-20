-- Pinkponya Archive fan community starter schema
-- Run in Supabase SQL Editor. Keep the service-role key secret.
create extension if not exists pgcrypto;

create table if not exists public.fan_registrations (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  email text not null,
  country text not null,
  city text not null,
  phone text not null,
  whatsapp text,
  instagram text,
  event_location text not null,
  attendance_interest text not null,
  email_updates boolean not null default false,
  whatsapp_updates boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.fan_registrations enable row level security;

-- Public visitors can submit registrations, but cannot read registrations.
drop policy if exists "Anyone can submit a fan registration" on public.fan_registrations;
create policy "Anyone can submit a fan registration"
  on public.fan_registrations for insert to anon, authenticated
  with check (
    length(trim(full_name)) > 0 and length(trim(email)) > 3
    and length(trim(country)) > 0 and length(trim(city)) > 0
    and length(trim(phone)) > 0 and length(trim(event_location)) > 0
  );

drop policy if exists "Admins can read registrations" on public.fan_registrations;
create policy "Admins can read registrations"
  on public.fan_registrations for select to authenticated
  using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Admins can delete registrations" on public.fan_registrations;
create policy "Admins can delete registrations"
  on public.fan_registrations for delete to authenticated
  using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- Admin users must be created privately in Supabase Authentication.
-- Set app_metadata.role = "admin" for authorized admin users using a trusted
-- server/admin workflow. Never let a public client edit app_metadata.

create table if not exists public.photo_gallery (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  caption text not null default '',
  image_url text not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);
alter table public.photo_gallery enable row level security;
drop policy if exists "Public can view photos" on public.photo_gallery;
create policy "Public can view photos" on public.photo_gallery for select to anon, authenticated using (true);
drop policy if exists "Admins can manage photos" on public.photo_gallery;
create policy "Admins can manage photos" on public.photo_gallery for all to authenticated
  using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
  with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

create table if not exists public.video_gallery (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null default '',
  category text not null default 'Other',
  video_url text not null,
  thumbnail_url text not null default '',
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);
alter table public.video_gallery enable row level security;
drop policy if exists "Public can view videos" on public.video_gallery;
create policy "Public can view videos" on public.video_gallery for select to anon, authenticated using (true);
drop policy if exists "Admins can manage videos" on public.video_gallery;
create policy "Admins can manage videos" on public.video_gallery for all to authenticated
  using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
  with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- For a production build, wire photo_gallery and video_gallery to the React UI,
-- and configure Supabase Storage buckets/policies for image uploads.
