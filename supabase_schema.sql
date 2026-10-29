-- Schéma de départ Supabase pour un compteur collectif de déclarations.
-- À exécuter dans Supabase > SQL Editor.
-- Compte des déclarations volontaires, PAS des blocages vérifiés par les réseaux sociaux.

create table if not exists public.block_declarations (
  id bigint generated always as identity primary key,
  profile_slug text not null,
  visitor_token_hash text not null,
  created_at timestamptz not null default now(),
  unique(profile_slug, visitor_token_hash)
);

alter table public.block_declarations enable row level security;

-- Le public peut lire le nombre total par profil.
create policy "Public can read declarations"
on public.block_declarations for select
to anon
using (true);

-- IMPORTANT:
-- Ne pas autoriser l'insertion publique directement sans protections.
-- Pour la mise en production, faire les insertions via une Edge Function
-- ou une API serveur qui applique un rate limit, vérifie un CAPTCHA et
-- protège le secret serveur. Ne jamais mettre une clé service_role dans le HTML.
