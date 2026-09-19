# Quickstart Guide: Autenticação e Perfis (Fundações Técnicas)

**Feature**: `002-auth-profile-foundations`  
**Spec**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)  
**Date**: 2026-09-18  

---

## 1. Pré-Requisitos

- **Node.js**: 18.x ou 20.x LTS
- **Docker**: Instalado e em execução (para execução do Supabase Local)
- **Supabase CLI**: Instalado localmente ou via `npx supabase`
- **Navegador Web**: Google Chrome, Firefox ou Edge

---

## 2. Setup e Inicialização do Ambiente Local

Execute a partir da raiz do repositório:

```bash
# 1. Instalar as dependências do monorepo
npm install

# 2. Iniciar a instância local do Supabase (PostgreSQL, Auth e Studio)
npx supabase start

# 3. Aplicar as migrações e contratos de banco de dados
npx supabase db reset

# 4. Iniciar a aplicação Next.js em modo de desenvolvimento
npm run dev --workspace=apps/web
```

A aplicação estará acessível em `http://localhost:3000` e o Supabase Studio em `http://localhost:54323`.

---

## 3. Cenários de Validação Prática

### Cenário 1: Verificação da Criação Automática de Perfil no Login Google

1. Acesse `http://localhost:3000/login`.
2. Clique no botão **"Entrar com Google"**.
3. Conclua a autenticação simulada no provedor Google.
4. **Resultado Esperado**:
   - Redirecionamento automático para a rota de callback `/auth/callback` e, em seguida, para `/workspace`.
   - No Supabase Studio (`http://localhost:54323`), verifique que um registro correspondente foi inserido em `public.profiles` com papel `role = 'student'` e metadados de nome e avatar preenchidos.

---

### Cenário 2: Validação de Isolamento via Row Level Security (RLS)

Valida o cumprimento das regras da Seção 7 da Constituição ("Autorização no servidor"):

1. Utilizando o cliente Supabase autenticado como **Aluno**:
   - Tente consultar os perfis de outros alunos:
     ```typescript
     const { data } = await supabase.from('profiles').select('*');
     ```
   - **Resultado Esperado**: Retorna apenas 1 registro (o próprio perfil do aluno).
2. Tente atualizar o próprio papel para administrador:
   ```typescript
   const { error } = await supabase.from('profiles').update({ role: 'admin' }).eq('id', alunoId);
   ```
   - **Resultado Esperado**: A operação falha imediatamente com o erro do trigger: `'Acesso negado: apenas administradores podem alterar o papel do usuário.'`

---

### Cenário 3: Validação da Função Anti-Recursão (`is_admin()`)

1. Conecte-se ao banco local via `psql` ou Supabase SQL Editor.
2. Execute a consulta simulando um usuário autenticado:
   ```sql
   SET request.jwt.claim.sub = '<uuid-do-aluno>';
   SET role = 'authenticated';
   SELECT * FROM public.profiles;
   ```
3. **Resultado Esperado**: A consulta executa em menos de 10ms sem gerar erro de `infinite recursion detected in policy for relation "profiles"`.

---

### Cenário 4: Validação dos Guardas de Rota (Next.js Middleware & Server Components)

1. **Acesso Anônimo a Rota Protegida**:
   - Abra uma aba anônima e acesse `http://localhost:3000/workspace`.
   - **Resultado Esperado**: Redirecionamento imediato para `http://localhost:3000/login?redirectTo=%2Fworkspace`.
2. **Acesso de Aluno a Rota de Administração**:
   - Autenticado como Aluno, acesse `http://localhost:3000/admin/alunos`.
   - **Resultado Esperado**: Interceptação pelo middleware ou layout com redirecionamento de volta para `/workspace` e mensagem de permissão negada (HTTP 403).
3. **Acesso de Administrador**:
   - Promova um usuário a `admin` no banco: `UPDATE public.profiles SET role = 'admin' WHERE email = '...';`
   - Acesse `http://localhost:3000/admin/alunos`.
   - **Resultado Esperado**: Acesso liberado, renderizando a tabela de alunos e botões de gerenciamento.

---

## 4. Execução de Testes Automatizados e Quality Gates

```bash
# Rodar suíte de testes unitários e de integração de autenticação/RLS
npm test

# Validação estática de tipos em todo o monorepo
npm run typecheck

# Validação de padrões de código (Lint)
npm run lint
```
