-- Barthélémy Djamo — Solutions Technologiques
-- À exécuter dans Supabase > SQL Editor, dans votre propre projet.
-- Important : créez d'abord un compte propriétaire dans Authentication > Users.
-- Ensuite, remplacez OWNER_EMAIL ci-dessous par votre adresse e-mail exacte et exécutez le script.
-- N'utilisez jamais une clé service_role dans le site web.

create extension if not exists pgcrypto;

create table if not exists public.site_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text unique not null,
  created_at timestamptz not null default now()
);

create table if not exists public.site_products (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text not null default '',
  price_label text not null default 'Sur devis',
  icon text not null default '💡',
  order_message text not null default '',
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.site_admins enable row level security;
alter table public.site_products enable row level security;

drop policy if exists "Admins can read their own admin record" on public.site_admins;
create policy "Admins can read their own admin record"
on public.site_admins for select to authenticated
using (user_id = auth.uid());

drop policy if exists "Public can read active products" on public.site_products;
create policy "Public can read active products"
on public.site_products for select to anon, authenticated
using (active = true or owner_id = auth.uid());

drop policy if exists "Owners can insert products" on public.site_products;
create policy "Owners can insert products"
on public.site_products for insert to authenticated
with check (
  owner_id = auth.uid()
  and exists (select 1 from public.site_admins a where a.user_id = auth.uid())
);

drop policy if exists "Owners can update products" on public.site_products;
create policy "Owners can update products"
on public.site_products for update to authenticated
using (exists (select 1 from public.site_admins a where a.user_id = auth.uid()) and owner_id = auth.uid())
with check (exists (select 1 from public.site_admins a where a.user_id = auth.uid()) and owner_id = auth.uid());

drop policy if exists "Owners can delete products" on public.site_products;
create policy "Owners can delete products"
on public.site_products for delete to authenticated
using (exists (select 1 from public.site_admins a where a.user_id = auth.uid()) and owner_id = auth.uid());

-- Après avoir créé votre utilisateur dans Supabase Auth, exécutez cette instruction
-- séparément en remplaçant l'adresse par celle de votre compte propriétaire :
-- insert into public.site_admins (user_id, email)
-- select id, email from auth.users where lower(email) = lower('VOTRE_EMAIL_PROPRIETAIRE');
