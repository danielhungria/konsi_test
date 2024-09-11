# Aplicativo de CEP

Um aplicativo Flutter desenvolvido para ajudar a pesquisar e registrar endereços de CEP. O app permite buscar CEPs, visualizar e editar endereços salvos e possui uma interface intuitiva e responsiva.

## Índice
- [Sobre](#sobre)
- [Funcionalidades](#funcionalidades)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Uso](#uso)

## Sobre

Este aplicativo Flutter facilita a busca e o gerenciamento de endereços baseados em CEP. Com uma interface moderna, ele oferece uma maneira eficiente de pesquisar CEPs e manter um histórico de endereços salvos.

## Funcionalidades

- Pesquisa de CEPs em tempo real usando a API ViaCEP.
- Registro e visualização de endereços salvos com opção de edição.
- Tela de histórico de endereços salvos com funcionalidade de pesquisa.
- Interface responsiva e intuitiva com gerenciamento de estado usando Bloc.
- Configuração de dados locais usando Hive.

## Tecnologias Utilizadas

- **Get It**: Utilizado para injeção de dependências, facilitando a gestão e a reutilização de serviços e controladores.
- **Bloc**: Utilizado para gerenciamento de estado, permitindo uma arquitetura reativa e escalável.
- **Equatable**: Utilizado para facilitar a comparação de objetos, especialmente útil em estados e eventos do Bloc.
- **Go Router**: Utilizado para navegação, proporcionando uma maneira simples e declarativa de definir rotas.
- **Hive**: Utilizado para armazenamento local, permitindo salvar e recuperar dados de forma eficiente.
- **Unit Tests**: Utilizados para garantir a qualidade do código, com testes automatizados para as funcionalidades principais.
- **Google Maps**: Utilizado para exibir mapas e permitir a interação com localizações geográficas.
- **API ViaCEP**: Utilizada para buscar informações de endereços a partir de CEPs, fornecendo dados em tempo real.

## Pré-requisitos

- [Flutter](https://flutter.dev/docs/get-started/install) 3.22.3 ou superior.
- [Dart](https://dart.dev/get-dart) 3.4.4 ou superior.
- Dependências do projeto listadas no `pubspec.yaml`.

## Instalação

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/danielhungria/konsi_test.git
   ```

2. **Navegue até o diretório do projeto:**
   ```bash
   cd Konsi\ Test
   ```

3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

## Uso

Ao iniciar o aplicativo, você verá a tela inicial com duas abas: "Mapa" e "Caderneta". Use a barra de pesquisa na tela de Mapa para buscar CEPs. Na tela de Caderneta, você pode visualizar e gerenciar endereços salvos. A interface é responsiva e fácil de usar, projetada para fornecer uma experiência intuitiva.
