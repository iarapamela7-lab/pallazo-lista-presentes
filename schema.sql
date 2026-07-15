-- ============================================================
-- PALLAZO STUDIO — Lista de Presentes
-- Schema do banco de dados (rodar inteiro no SQL Editor do Supabase)
-- ============================================================

create extension if not exists pgcrypto;

-- ---------- TABELAS ----------

create table if not exists eventos (
  id uuid primary key default gen_random_uuid(),
  nome_evento text not null,
  mensagem text,
  slug_convidados text unique not null,
  slug_anfitriao text unique not null,
  cor_primaria text default '#5B6E4F',
  cor_secundaria text default '#E8E2D4',
  fonte text default 'Fraunces',
  imagem_capa_url text,
  criado_em timestamptz default now()
);

create table if not exists presentes (
  id uuid primary key default gen_random_uuid(),
  evento_id uuid references eventos(id) on delete cascade,
  nome text not null,
  descricao text,
  valor text,
  foto_url text,
  tipo text not null check (tipo in ('reserva','pix')),
  pix_chave text,
  pix_qrcode_url text,
  status text not null default 'disponivel' check (status in ('disponivel','reservado','pago')),
  ordem int default 0,
  criado_em timestamptz default now()
);

create table if not exists reservas (
  id uuid primary key default gen_random_uuid(),
  presente_id uuid references presentes(id) on delete cascade,
  nome_convidado text not null,
  whatsapp text not null,
  criado_em timestamptz default now()
);

-- ---------- SEGURANÇA (RLS) ----------
-- Ninguém acessa as tabelas diretamente, exceto você (autenticado).
-- Convidados e anfitrião só enxergam dados através das funções seguras abaixo.

alter table eventos enable row level security;
alter table presentes enable row level security;
alter table reservas enable row level security;

create policy "admin acesso total eventos" on eventos
  for all to authenticated using (true) with check (true);

create policy "admin acesso total presentes" on presentes
  for all to authenticated using (true) with check (true);

create policy "admin acesso total reservas" on reservas
  for all to authenticated using (true) with check (true);

-- ---------- FUNÇÕES PÚBLICAS SEGURAS ----------

-- 1) Página do convidado: retorna o evento + presentes pelo slug público
create or replace function get_lista_convidados(p_slug text)
returns table (
  evento_id uuid, nome_evento text, mensagem text,
  cor_primaria text, cor_secundaria text, fonte text, imagem_capa_url text,
  presente_id uuid, presente_nome text, descricao text, valor text,
  foto_url text, tipo text, status text, pix_chave text, pix_qrcode_url text
)
language sql security definer set search_path = public as $$
  select e.id, e.nome_evento, e.mensagem, e.cor_primaria, e.cor_secundaria, e.fonte, e.imagem_capa_url,
         p.id, p.nome, p.descricao, p.valor, p.foto_url, p.tipo, p.status, p.pix_chave, p.pix_qrcode_url
  from eventos e
  join presentes p on p.evento_id = e.id
  where e.slug_convidados = p_slug
  order by p.ordem, p.criado_em;
$$;

grant execute on function get_lista_convidados(text) to anon;

-- 2) Página do anfitrião: retorna o evento + presentes + quem reservou
create or replace function get_lista_anfitriao(p_slug text)
returns table (
  evento_id uuid, nome_evento text,
  presente_id uuid, presente_nome text, foto_url text, tipo text, status text, valor text,
  nome_convidado text, whatsapp text
)
language sql security definer set search_path = public as $$
  select e.id, e.nome_evento,
         p.id, p.nome, p.foto_url, p.tipo, p.status, p.valor,
         r.nome_convidado, r.whatsapp
  from eventos e
  join presentes p on p.evento_id = e.id
  left join lateral (
    select nome_convidado, whatsapp from reservas
    where presente_id = p.id order by criado_em desc limit 1
  ) r on true
  where e.slug_anfitriao = p_slug
  order by p.ordem, p.criado_em;
$$;

grant execute on function get_lista_anfitriao(text) to anon;

-- 3) Reservar presente (à prova de dois convidados escolherem o mesmo ao mesmo tempo)
create or replace function reservar_presente(p_presente_id uuid, p_nome text, p_whatsapp text)
returns boolean
language plpgsql security definer set search_path = public as $$
declare
  linhas int;
begin
  update presentes set status = 'reservado'
  where id = p_presente_id and status = 'disponivel';

  get diagnostics linhas = row_count;

  if linhas = 0 then
    return false; -- alguém já escolheu esse presente antes
  end if;

  insert into reservas (presente_id, nome_convidado, whatsapp)
  values (p_presente_id, p_nome, p_whatsapp);

  return true;
end;
$$;

grant execute on function reservar_presente(uuid, text, text) to anon;

-- ============================================================
-- Depois de rodar este arquivo, crie também o bucket de imagens:
-- Storage → New bucket → nome: uploads → marque "Public bucket"
-- ============================================================
