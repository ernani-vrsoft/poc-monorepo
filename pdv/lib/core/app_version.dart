/// Versão da aplicação, injetada pelo workflow de release com o nome da tag
/// (`--dart-define=APP_VERSION=v1.2.3`). Em builds locais fica `dev`.
const appVersion = String.fromEnvironment('APP_VERSION', defaultValue: 'dev');
