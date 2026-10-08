# specs

> **Simulação para POC** — esta pasta representa onde o [Spec Kit](https://github.com/github/spec-kit) guarda as
> especificações de cada feature. Nenhuma spec real foi gerada.

Cada feature ganha uma pasta numerada, criada pelos comandos `/specify`, `/plan` e `/tasks`:

```
specs/
└── 001-crud-pessoas/
    ├── spec.md          # /specify — requisitos e histórias de usuário (sem detalhes técnicos)
    ├── plan.md          # /plan    — decisões técnicas: Go 1.22, MongoDB, Flutter desktop
    ├── data-model.md    # entidades (ex.: Pessoa { id, nome })
    ├── contracts/       # contratos da api (ex.: openapi.yaml de /pessoas)
    └── tasks.md         # /tasks   — tarefas ordenadas para implementar
```

Exemplo de trecho de `spec.md`:

```markdown
# Feature: CRUD de pessoas

## História de usuário

Como operador do PDV, quero cadastrar, editar e excluir pessoas
para manter a base de clientes atualizada.

## Critérios de aceite

- Dado que informo um nome válido, quando salvo, então a pessoa aparece na listagem.
- Dado que excluo uma pessoa, quando atualizo a lista, então ela não aparece mais.
```
