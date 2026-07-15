# PALLAZO STUDIO — Lista de Presentes
### Passo a passo para deixar tudo no ar (sem precisar programar)

Você vai usar 3 sites gratuitos: **Supabase** (o banco de dados), **GitHub**
(onde o código fica guardado) e **Netlify** (que publica o site na internet).
Leva uns 20-25 minutos na primeira vez. Depois disso, tudo é automático.

---

## PARTE 1 — Criar o banco de dados (Supabase)

1. Acesse **[supabase.com](https://supabase.com)** e crie uma conta (dá pra
   usar login do GitHub ou Google).
2. Clique em **"New project"**.
   - Dê um nome, ex: `pallazo-lista-presentes`
   - Crie uma senha forte para o banco (guarde ela em algum lugar seguro,
     mas você não vai precisar dela no dia a dia).
   - Escolha a região mais perto do Brasil (`South America`).
   - Clique em **Create project** e espere uns 2 minutos ele terminar de criar.
3. No menu da esquerda, clique em **SQL Editor**.
4. Clique em **"New query"**.
5. Abra o arquivo **`schema.sql`** (está nesta mesma pasta), copie **todo** o
   conteúdo dele, cole na tela do Supabase e clique em **RUN** (ou `Ctrl+Enter`).
   - Isso cria todas as tabelas e as regras de segurança automaticamente.
6. Ainda no menu da esquerda, clique em **Storage** → **"New bucket"**.
   - Nome do bucket: `uploads`
   - Marque a opção **"Public bucket"**
   - Clique em criar.
   - *(Esse é o espaço onde as fotos de capa, presentes e QR Code do Pix vão
   ficar guardadas.)*
7. Agora crie o seu login de administrador (o único que acessa o painel):
   - Menu da esquerda → **Authentication** → **Users** → **"Add user"**
   - Coloque seu e-mail e uma senha → **marque a opção que confirma o e-mail
     automaticamente** (geralmente chamada "Auto Confirm User") → criar.
8. Por fim, pegue suas chaves de acesso:
   - Menu da esquerda → **Project Settings** (ícone de engrenagem) → **API**
   - Copie o valor de **Project URL**
   - Copie o valor de **anon public** (uma chave bem longa)
   - Guarde os dois — você vai usar no próximo passo.

---

## PARTE 2 — Colar suas chaves no código

1. Nesta pasta do projeto, abra o arquivo **`supabase-config.js`** com o
   Bloco de Notas (ou qualquer editor de texto simples).
2. Troque:
   - `COLE_AQUI_SUA_SUPABASE_URL` pela **Project URL** que você copiou
   - `COLE_AQUI_SUA_CHAVE_ANON_PUBLIC` pela chave **anon public**
3. Salve o arquivo.

---

## PARTE 3 — Colocar o código no GitHub

1. Acesse **[github.com](https://github.com)** e crie uma conta, se ainda
   não tiver.
2. Clique no **+** no canto superior direito → **"New repository"**.
   - Nome: `pallazo-lista-presentes`
   - Deixe como **Public** ou **Private** (tanto faz)
   - Clique em **Create repository**
3. Na tela que aparece, clique no link **"uploading an existing file"**.
4. Arraste **todos os arquivos desta pasta** para dentro da área de upload.
5. Role para baixo e clique em **"Commit changes"**.

---

## PARTE 4 — Publicar no Netlify (com atualização automática)

1. Acesse **[app.netlify.com](https://app.netlify.com)** e crie uma conta
   (o mais fácil é entrar com o **GitHub**, assim já fica tudo conectado).
2. Clique em **"Add new site" → "Import an existing project"**.
3. Escolha **GitHub** e autorize o acesso.
4. Selecione o repositório `pallazo-lista-presentes` que você acabou de criar.
5. Não precisa mudar nenhuma configuração de build — deixe os campos como
   estão e clique em **"Deploy site"**.
6. Em menos de um minuto, o Netlify te dá um link tipo
   `nome-aleatorio.netlify.app` — esse já é o seu site no ar!
7. (Opcional) Para deixar o link com a cara do seu estúdio:
   **Site settings → Change site name** → escolha algo como
   `pallazo-studio-presentes.netlify.app`

**A partir de agora:** qualquer vez que você (ou eu) alterar algum arquivo e
subir a mudança pro GitHub, o Netlify atualiza o site sozinho, sem precisar
arrastar nada de novo.

---

## Como usar no dia a dia

- **Painel** (só seu, com senha): `seusite.netlify.app/admin.html`
- Dentro do painel você cria o evento, personaliza cores/capa/fonte e
  cadastra os presentes.
- Cada evento gera automaticamente **dois links** — copie e envie:
  - Um para o **anfitrião** acompanhar (`anfitriao.html?e=...`)
  - Um para os **convidados** escolherem presentes (`convidados.html?e=...`)

---

## Dúvidas comuns

- **"Deu erro ao carregar" na página do convidado/anfitrião** → confira se
  colou certinho a URL e a chave no `supabase-config.js`, e se rodou o
  `schema.sql` até o fim sem erro.
- **Login não funciona no painel** → confira se criou o usuário em
  *Authentication → Users* e marcou "Auto Confirm".
- **Fotos não aparecem** → confira se o bucket `uploads` foi criado como
  **Public**.
