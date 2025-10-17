# Car Store - Gerenciamento de Estoque de Veículos

Um aplicativo Flutter simples para gerenciamento de estoque de veículos, desenvolvido para fins acadêmicos.

## Escopo do Projeto

**Disciplina:** Desenvolvimento de Dispositivos Móveis  
**Professor(a):** Tassiana  
**Data:** 17 de outubro de 2025

**Integrantes:**
- Otavio Augusto dos Santos
- João Vitor Dal-Ri

## Funcionalidades Implementadas

- ✅ **Login com Google** (estrutura pronta para Firebase Auth)
- ✅ **Listagem de Veículos** com layout em cards
- ✅ **Cadastro de Veículos** com formulário completo
- ✅ **Edição de Veículos** através de modal
- ✅ **Exclusão de Veículos** com confirmação
- 🔄 **Upload de Imagens** (estrutura pronta, sem integração)
- 🔄 **Integração Firebase** (estrutura pronta, sem configuração)

## Estrutura do Projeto

```
lib/
├── models/
│   ├── user.dart           # Modelo do usuário
│   └── vehicle.dart        # Modelo do veículo
├── screens/
│   ├── login_screen.dart   # Tela de login
│   ├── vehicle_list_screen.dart   # Listagem de veículos
│   └── add_vehicle_screen.dart    # Cadastro de veículos
├── services/
│   ├── auth_service.dart   # Serviço de autenticação
│   └── vehicle_service.dart       # Serviço de veículos
├── widgets/
│   ├── vehicle_card.dart   # Card do veículo na listagem
│   └── vehicle_edit_modal.dart    # Modal de edição
├── firebase_options.dart   # Configurações do Firebase (comentado)
└── main.dart              # Arquivo principal
```

## Como Usar

### 1. Preparação do Ambiente

```bash
# Instalar dependências
flutter pub get

# Executar o app
flutter run
```

### 2. Navegação no App

1. **Tela de Login**: Toque em "Entrar com Google" (simulado)
2. **Tela Principal**: Lista os veículos cadastrados
   - Toque no ícone "+" para adicionar veículo
   - Toque em "Editar" para modificar um veículo
   - Toque em "Excluir" para remover um veículo
3. **Tela de Cadastro**: Preencha o formulário e salve

### 3. Funcionalidades Atuais

- **Dados Simulados**: O app usa dados em memória para demonstração
- **Navegação Completa**: Todas as telas estão funcionais
- **Validação de Formulários**: Campos obrigatórios e validações
- **Interface Responsiva**: Layout adaptado para diferentes tamanhos

## Integração Firebase (Para Implementação Futura)

### Pré-requisitos

1. **Criar projeto Firebase**:
   - Acesse [Firebase Console](https://console.firebase.google.com)
   - Crie um novo projeto
   - Ative Authentication e Firestore

2. **Configurar FlutterFire CLI**:
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
```

### Passos para Integração

1. **Descomentar imports Firebase** nos arquivos:
   - `lib/main.dart`
   - `lib/services/auth_service.dart`
   - `lib/services/vehicle_service.dart`

2. **Configurar Authentication**:
   - Ativar Google Sign-In no Firebase Console
   - Configurar SHA-1 para Android
   - Baixar `google-services.json` (Android) e `GoogleService-Info.plist` (iOS)

3. **Configurar Firestore**:
   - Criar coleções: `users` e `vehicles`
   - Configurar regras de segurança

4. **Configurar Storage**:
   - Ativar Firebase Storage
   - Configurar regras para upload de imagens

## Dependências Principais

- `firebase_core`: Core do Firebase
- `firebase_auth`: Autenticação
- `cloud_firestore`: Banco de dados
- `firebase_storage`: Armazenamento de arquivos
- `google_sign_in`: Login com Google
- `image_picker`: Seleção de imagens
- `provider`: Gerenciamento de estado

## Tecnologias Utilizadas

- **Frontend:** Flutter Framework (multiplataforma Android/iOS)
- **Backend:** Firebase (BaaS - Backend as a Service)
  - **Cloud Firestore:** Banco de dados NoSQL
  - **Cloud Storage:** Armazenamento de imagens
  - **Firebase Auth:** Autenticação de usuários

## Status do Desenvolvimento

1. ✅ Estrutura básica do app
2. ✅ Interfaces de usuário (3 telas)
3. ✅ Navegação entre telas
4. ✅ Validação de formulários
5. ✅ Estrutura Firebase preparada
6. 🔄 Integração com Firebase Auth
7. 🔄 Integração com Firestore
8. 🔄 Integração com Firebase Storage
9. 🔄 Upload e exibição de imagens

## Notas para Desenvolvimento

- **Dados Simulados**: Atualmente usa dados em memória
- **TODOs**: Procure por comentários `// TODO:` no código
- **Firebase**: Toda estrutura está preparada, apenas descomente e configure
- **Plano Gratuito**: Utiliza apenas recursos do plano Spark do Firebase
