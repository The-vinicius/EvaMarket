# Documentação do Projeto: EvaMarket

## Visão Geral

Este documento descreve a arquitetura e a estrutura do projeto EvaMarket, um aplicativo Flutter desenvolvido para visualizar gráficos de preços de ativos financeiros. O aplicativo utiliza o pacote `yahoo_finance_data_reader` para obter os dados dos ativos diretamente do Yahoo Finance.

A arquitetura segue os princípios do **MVVM (Model-View-ViewModel)**, separando as responsabilidades em camadas distintas para promover um código mais limpo, testável e de fácil manutenção.

## Arquitetura do Aplicativo

A estrutura do projeto está organizada da seguinte forma:

### 1. Camada de UI (View)
- **Localização**: `lib/app/ui/`
- **Responsabilidade**: Contém todos os widgets e a lógica de interface do usuário. É responsável por exibir os dados e capturar as interações do usuário.
  - `screens/`: Define as telas principais do aplicativo (`HomePage`, `GraphPage`, `SplashPage`).
  - `tabs/`: Contém os widgets que representam as abas da `HomePage` (`HomeTab`, `ProfileTab`, `SearchTab`).
  - `states/`: Gerencia os diferentes estados da UI (`DataState`), como `loading`, `success` e `error`, permitindo que a interface reaja de acordo.

### 2. Camada de Lógica de Negócios (ViewModel)
- **Localização**: `lib/app/interactor/`
- **Responsabilidade**: Atua como o ViewModel no padrão MVVM. Contém a lógica de negócios, o gerenciamento de estado e as ações que podem ser executadas a partir da UI.
  - `stores/`: São os ViewModels da aplicação. Cada `store` (`MonteCarloStore`, `StorePrice`, `StoreSearch`, `StoreStocks`) gerencia o estado de uma parte específica do app.
  - `actions/`: Contém as ações que podem ser despachadas para modificar o estado, como `DataActions`.

### 3. Camada de Repositório
- **Localização**: `lib/app/repositories/`
- **Responsabilidade**: Abstrai a origem dos dados. Define contratos (interfaces) que a camada de ViewModel utiliza e implementações que sabem como buscar os dados.
  - `*_repository.dart`: Arquivos que definem as interfaces (contratos) para os repositórios (`PricesRepository`, `TickerRepository`, etc.).
  - `*_iml_repository.dart` / `yahoo_data_repository.dart`: Implementações concretas dos repositórios. `YahooDataRepository` é a implementação que utiliza o pacote `yahoo_finance_data_reader` para se comunicar com a API do Yahoo Finance.

### 4. Camada de Dados (Model)
- **Localização**: `lib/app/data/` e `lib/app/models/`
- **Responsabilidade**: Define as fontes de dados e os modelos de dados da aplicação.
  - `data/ticker_datasource.dart`: Contrato para a fonte de dados dos tickers.
  - `models/`: Contém as classes de modelo (`AssetModel`, `ChartData`, `TickerModel`) que estruturam os dados utilizados em todo o aplicativo.

### 5. Core e Injeção de Dependência
- **`lib/app/injector.dart`**: Arquivo crucial para a **Injeção de Dependência**. Ele inicializa e injeta as dependências (stores, repositórios) em toda a aplicação, facilitando a substituição de implementações e os testes.
- **`lib/app/core/`**: Contém código de utilidade geral, como helpers (`PercentMessage`).
- **`lib/app/exceptions/`**: Define as exceções personalizadas do aplicativo.

## Testes

- **Localização**: `test/`
- **Responsabilidade**: O diretório de testes espelha a estrutura do diretório `lib`, garantindo que cada camada da arquitetura tenha sua devida cobertura de testes.
  - `data/`: Testes para as fontes de dados.
  - `repositories/`: Testes para as implementações dos repositórios, validando a integração com fontes de dados (reais ou mocks).
  - `interactor/`: Testes de unidade para a lógica de negócios nos stores/ViewModels.
  - `ui/screens/`: Testes de widget para as telas, garantindo que a UI se comporte como esperado.

## Fluxo de Dados Principal

1.  A **UI** (ex: `HomePage`) solicita dados ou dispara uma ação.
2.  A ação é recebida pelo **ViewModel** (`store` correspondente em `lib/app/interactor/`).
3.  O **ViewModel** solicita os dados ao **Repositório** (ex: `PricesRepository`).
4.  O **Repositório** (ex: `YahooDataRepository`) busca os dados da fonte externa (API do Yahoo Finance).
5.  Os dados são convertidos em **Models** (ex: `AssetModel`).
6.  O **ViewModel** recebe os Models e atualiza seu estado.
7.  A **UI** reage à mudança de estado e se reconstrói para exibir os novos dados.
