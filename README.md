RELATÓRIO DE ESCOPO DE PROJETO – N2

**Disciplina:** Desenvolvimento de Dispositivos Móveis
---
**Professor(a):** Tassiana
---
**Data:** 17 de outubro de 2025

---

### **1. Integrantes do Grupo**

Abaixo, a lista com os integrantes responsáveis pelo desenvolvimento do projeto:

* Otavio Augusto dos Santos
* João Vitor Dal-Ri

---

### **2. Tema do Projeto**

Desenvolvimento de um aplicativo para gerenciamento de estoque de veículos para pequenas lojas e concessionárias.

---

### **3. Escopo Resumido**

O objetivo do projeto é criar um aplicativo móvel simples e funcional, utilizando o framework Flutter, para facilitar o controle de estoque de veículos. O aplicativo permitirá que o lojista realize as operações básicas de CRUD (Criar, Ler, Atualizar e Deletar) para os carros disponíveis em sua loja.

As principais funcionalidades a serem implementadas são:

1.  **Cadastro de Veículos:**
    * Um formulário para adicionar novos carros ao estoque, contendo campos como: Marca, Modelo, Ano, Cor, Preço e uma breve Descrição.
    * Funcionalidade para fazer o **upload de uma foto** do veículo no momento do cadastro.

2.  **Listagem de Veículos em Estoque:**
    * Uma tela principal que exibirá todos os carros cadastrados em formato de lista ou grade, mostrando informações essenciais como a foto, modelo e preço.

3.  **Visualização e Edição de Detalhes:**
    * Ao selecionar um veículo da lista, o usuário será direcionado para uma tela de detalhes, onde poderá ver todas as informações e a imagem do carro.
    * Nesta mesma tela, haverá a opção de **editar** os dados do veículo.

4.  **Exclusão de Veículos:**
    * O usuário terá a possibilidade de **remover** um veículo do estoque, o que o excluirá permanentemente do banco de dados.

---

### **4. Tecnologias a Serem Utilizadas**

O projeto será desenvolvido com foco em tecnologias modernas e de baixo custo, utilizando exclusivamente as ferramentas disponíveis no plano gratuito (**Spark**) da plataforma Google Firebase.

* **Frontend:** Flutter Framework, para o desenvolvimento de uma aplicação multiplataforma (Android/iOS) com uma única base de código.
* **Backend (BaaS - Backend as a Service):**
    * **Cloud Firestore:** Para o armazenamento dos dados textuais dos veículos (marca, modelo, preço, etc.) em um banco de dados NoSQL.
    * **Cloud Storage for Firebase:** Para o armazenamento e recuperação das imagens dos carros enviadas via upload.
