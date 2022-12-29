# Comunicação entre componentes

Problematização e forma de resolução das comunicações entre componentes.

## Problema:

- Aplicação componentizada com uma grande árvore de componentes. Como fazer para compartilhar informações com outro componente que está completamente distante do componente atual?

## Resolução:

- **Comunicação direta:** Componente pai manda informações para o componente filho, definindo elementos no construtor;

- **Comunicação indireta:** Passa via construtor uma função que quando determinado evento ocorre, ela é acionada de volta (callback) passando algum dado para o componente pai.

- **Inherited Widget:** Utiliza o widget dentro da árvore de componentes e será possível comunicar diretamente com qualquer componente dentro da árvore (a partir da .of(context)). Isso ocorre porque cada componente recebe um "Build context" na hora de sua construção e esses contextos conseguem se comunicar entre si, de tal forma que além da árvore de componentes, possui uma árvore de contextos (o que não está visível). **Exemplo: MeuWidget.of(context).data** => Ao buscar um contexto de um widget, ele navega na árvore de contextos até chegar no widget herdado, pega a informação solicitada, constrói a instância desse tipo e devolve uma instância do "meu widget". Internamente ele resolve uma instância desse tipo de elemento, para ter acesso aos atributos que são necessários para acessar a aplicação. Princípio no qual o provider se baseia (Inherited Widget).

# Estado

- No caso do Flutter, um framework muito ligado com a questão de definição de widgets e renderização de componentes na tela, um dos aspectos mais importantes é lidar com os dados;
- São os estados que afetam nossa interface. Ou seja, com as interações do usuário (entra em uma tela, marca um produto como favorito), todos os eventos que o usuário dispara, geram um impacto nos dados da aplicação, uma vez que eles são alterados, sua aplicação também será alterada;
- Uma aplicação "componentizada" é uma grande árvore de componentes que eventualmente são feitas alterações em componentes X que geram impactos em um componente Y que está totalmente distante dentro da árvore.

## Tipos de Estado

- **Compartilhado:** Um estado que pertence ao âmbito da nossa aplicação. Afeta uma parte significante da APP. (Ex: Usuário logado, produtos no carrinho e etc)
- **Local:** Pode possuir um estado local, um determinado Widget, sem necessariamente envolver o estado total da aplicação. (Ex: Exibir um spinner que aguarda uma requisição HTTP.)

## Como funciona o Provider?

- Inicialmente é necessário injetar o provider(provedor de dados) em algum ponto da árvore, não necessariamente dentro da raiz;
- Ele será um container, e envolverá toda a minha aplicação dentro do "container";
- Todos os componentes filhos podem acessar os dados, sem que necessite passar as informações manualmente;
- O acesso será feito através do **of(context)**;
- Quando um estado(dado) muda, o método build() é executado e a UI é atualizada, mas em componentes do tipo Stateless, será necessário passar essa informação via construtor para que a interface gráfica seja atualizada.
- Um provider pode ser definido em um dos ramos da sua aplicação, porém, não será possível acessar em outros locais que não pertençam a esse ramo.

## Consumer

- Utilizado especificamente no ponto da árvore de componentes que haverá mudança (Envolto em um botão, por exemplo).
