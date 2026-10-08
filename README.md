# poc-monorepo

POC com duas aplicações:

- **api** — Go 1.22 + MongoDB 8.2.12 (CRUD de pessoas), porta `12001`
- **pdv** — Flutter 3.44 desktop (Linux e Windows) que consome a api

## Subindo

```bash
# Mongo (host: 27018) + api (host: 12001)
docker compose up -d --build

# PDV
cd pdv
flutter run -d linux     # ou: flutter run -d windows
```

Para rodar a api fora do Docker (com o Mongo do compose de pé):

```bash
cd api
go run ./cmd/api         # usa mongodb://localhost:27018 por padrão
```

Para apontar o PDV para outra URL:

```bash
flutter run -d linux --dart-define=API_URL=http://192.168.0.10:12001
```

## Endpoints

| Método | Rota            | Corpo             |
|--------|-----------------|-------------------|
| GET    | `/pessoas`      |                   |
| GET    | `/pessoas/{id}` |                   |
| POST   | `/pessoas`      | `{"nome": "..."}` |
| PUT    | `/pessoas/{id}` | `{"nome": "..."}` |
| DELETE | `/pessoas/{id}` |                   |
| GET    | `/health`       |                   |
## Versão

A versão do monorepo fica em `pdv/pubspec.yaml` (`version: X.Y.Z+N`) e aparece
no rodapé do PDV como `vX.Y.Z` (ou `vX.Y.Z-N` para builds fora da `main`).

Não altere esse valor manualmente: o workflow **Release** (Actions → Release →
Run workflow) calcula a próxima versão, atualiza o `pubspec.yaml`, faz commit na
branch, gera os zips de Linux e Windows e cria a tag/release nesse commit.
