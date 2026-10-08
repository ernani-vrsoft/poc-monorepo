# .specify

> **Simulação para POC** — esta pasta representa o que o [Spec Kit](https://github.com/github/spec-kit) gera ao rodar
`specify init`. Nenhum arquivo real do Spec Kit foi instalado.

Aqui ficaria a configuração do Spec Kit, compartilhada por todas as features:

```
.specify/
├── memory/
│   └── constitution.md      # princípios do projeto (ex.: "api em Go + MongoDB", "PDV em Flutter desktop", "toda rota tem teste")
├── scripts/
│   └── bash/                # scripts usados pelos comandos (/specify, /plan, /tasks): criar branch, criar pasta da feature etc.
└── templates/
    ├── spec-template.md     # modelo de especificação (o quê e por quê)
    ├── plan-template.md     # modelo de plano técnico (como)
    └── tasks-template.md    # modelo de lista de tarefas
```

Exemplo de trecho da `constitution.md`:

```markdown
## Princípios

1. A api expõe apenas REST/JSON na porta 12001.
2. O PDV nunca acessa o MongoDB diretamente, só via api.
3. Toda mudança de contrato da api é refletida no PDV no mesmo PR.
```
