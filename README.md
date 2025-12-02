📚 Sobre o Projeto

Este repositório contém o Trabalho de Conclusão de Curso (TCC) de Amanda Sales, desenvolvido como parte da graduação em Sistemas de Informação – Universidade Estadual de Campinas (Unicamp).
O projeto consiste na criação de uma aplicação web voltada para o gerenciamento, visualização e organização de equipamentos, contemplando dois tipos de usuários:
Administradores: podem cadastrar, editar e remover equipamentos.
Usuários comuns: podem visualizar os materiais disponíveis e acessar detalhes dos equipamentos.
A arquitetura segue boas práticas modernas, utilizando Flutter Web, Firebase e padrões de organização robustos como Bloc, separação em camadas e estrutura de pastas coerente.


🧩 Objetivos do Sistema

- Facilitar o controle de equipamentos em laboratórios.
- Proporcionar interface moderna, responsiva e intuitiva.
- Separar claramente permissões entre usuários.
- Manter segurança e integridade dos dados utilizando Firebase.
- Aplicar arquitetura limpa e escalável.

🏗️ Arquitetura Utilizada

O projeto adota uma estrutura em três camadas, visando modularidade, testabilidade e clareza:
UI Layer
Responsável pelas telas, widgets e elementos visuais.
Bloc Layer
Gerencia a lógica de negócio, eventos e estados utilizando Bloc
Data Layer
Contém repositórios, providers e integrações com o Firebase.
