# LeaningAppKit

Repositório de estudos focado em **AppKit** e arquitetura de apps para macOS, usando SwiftUI + SwiftData sobre uma camada de persistência genérica, além de automação de janelas via `NSWorkspace` e eventos de teclado sintéticos.

## O que este projeto explora

- **Repository genérico com SwiftData** — um `RepositoryProtocol<Model: PersistentModel>` com implementação única (`GenericRepository`) que serve qualquer entidade marcada com `@Model`, sem repetir CRUD por tipo.
- **MVVM com injeção de dependência** — `HomeViewModel` conhece apenas os protocolos de repository (não os tipos concretos), permitindo trocar a implementação sem tocar na ViewModel.
- **Automação de janelas via AppKit** — seleção de apps em `/Applications` via `NSOpenPanel`, listagem de apps rodando com `NSWorkspace.shared.runningApplications`, e fechamento controlado simulando `Cmd+Q` com `CGEvent` postado diretamente no processo alvo.
- **Ícones e nomes de apps do sistema** — leitura de ícone (`NSWorkspace.icon(forFile:)`) e nome de exibição (`FileManager.displayName(atPath:)`) a partir do caminho do `.app`.

## Estrutura

```
LearningAppKit/
├── Helpers/            # AcessibilityHelper (esboço, ainda comentado)
├── Model/
│   ├── Entities/        # Item, SecondItem, Teste (@Model)
│   ├── Protocols/       # RepositoryProtocol
│   └── Repository/      # GenericRepository
├── View/                # ContentView
└── ViewModel/           # HomeViewModel
```

> O helper de Accessibility (`AcessibilityHelper.swift`) está deixado comentado de propósito — é um esboço para checar/pedir permissão de Accessibility via `AXIsProcessTrusted`, ainda não integrado ao fluxo do app.

## Tecnologias

- Swift, SwiftUI, AppKit
- SwiftData (persistência)
- Carbon `HIToolbox` (constantes de tecla para os eventos sintéticos)

## Requisitos

- macOS (App target, não iOS)
- Xcode mais recente com suporte a SwiftData e `@Observable`

## Como rodar

1. Clone o repositório
2. Abra `LearningAppKit/LearningAppKit.xcodeproj` no Xcode
3. Rode no target de macOS (`Cmd + R`)
