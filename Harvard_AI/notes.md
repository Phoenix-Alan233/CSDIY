本身就会的东西就不记录了, 这里写一点新学到的.

## Lec 0. Search

### A* Search

search algorithm that expands node with lowest value of $g(n)+h(n)$.

- $g(n)$ = cost to reach node
- $h(n)$ = estimated cost to goal 

optimal if:
- $h(n)$ is admissible (never overestimates the true cost)
- $h(n)$ is consistent (for every node $n$ and successor $n'$ with step cost $c$, $h(n) \le h(n')+c$)

### Adversarial Search: Minimax & Alpha-beta pruning

Given a state $s$:
- $\text{MAX}$ picks action $a$ in $\text{ACTIONS}(s)$ that produces highest value of $\text{MIN-VALUE}(\text{RESULT}(s,a))$.
- $\text{MIN}$ picks action $a$ in $\text{ACTIONS}(s)$ that produces smallest value of $\text{MAX-VALUE}(\text{RESULT}(s,a))$.

```
function MAX-VALUE(state):
    if TERMINAL(state):
        return UTILITY(state)
    v = -infinity
    for action in ACTIONS(state):
        v = MAX(v, MIN-VALUE(RESULT(state, action)))
    return v

function MIN-VALUE(state):
    if TERMINAL(state):
        return UTILITY(state)
    v = infinity
    for action in ACTIONS(state):
        v = MIN(v, MAX-VALUE(RESULT(state, action)))
    return v
```

---

## Lec 1. Knowledge (都是些概念性的东西)

- sentence: an **assertion** about the world in a knowledge representation language.
- model: assignment of a truth value to every propositional symbol.
  - eg. $P$: It is raining; $Q$: It is a Tuesday. Model: {$P$ = `true`, $Q$ = `false`}.
- Entailment：$\alpha ⊨ \beta$. In every model in which sentence $\alpha$ is `true`, sentence $\beta$ is also `true`.
- Inference: the process of deriving new sentences from old ones.

- Search Problems:
    - initial state: starting knowledge base
    - actions: inference rules
    - transition model: new knowledge base after inference
    - goal test: check statement we're trying to prove
    - path cost function: number of steps in proof
- To determine if $\text{KB} ⊨ \alpha$:
    - Check if $(\text{KB} ∧ \neg \alpha)$ is a contradiction. If so, then entailment.

- First-Order Logic (一阶谓词):
    - Universal Quantification: $\forall$
    - Existential Quantification: $\exists$

---

## Lec 2. Uncertainty

这一讲比较简单. 但是贝叶斯网络、马尔可夫网络的可视化做得真的好!

- independence: the knowledge that one event occurs does not affect the probability of the other event.
    - $P(AB)=P(A)P(B)$, aka. $P(A)=P(A | B)$.
- Bayes' Rule:

    $$
    P(B|A)=\frac{P(A|B)P(B)}{P(A)}
    $$
- Conditioning:

    $$
    P(A)=P(A|B)P(B)+P(A|\neg B)P(\neg B)
    $$

- Bayesian Networks
    - directed graph
    - each node represents a random variable
    - arrow from $X$ to $Y$ means $X$ is a parent of $Y$
    - each node $X$ has probability distribution $P(X| \text{Parent}(X))$

    ![](assets/1.png)

    - Inference by Enumeration

        $$
        P(X|e) = \alpha P(X,e)=\alpha \sum_y P(X,e,y)
        $$

        where $X$ is the query variable, $e$ is the evidence. $y$ ranges over values of hidden variables, and $\alpha$ normalizes the result.

    - Approximate Inference

        - 根据概率 sampling 即可.
        - 如果本身有观测值 (evidence), 执行 rejection sampling (很好理解吧, 把观测值对不上的样本过滤了).
     - Likelihood Weighting (似然加权采样, 重要性采样)
        - start by fixing the values for evidence variables.
        - sample the non-evidence variables using conditional probabilities in the Bayesian Network.
        - Weight each sample by its **likelihood**: the probability of all of the evidence. 相当于每个样本带上了一个权重.

- Hidden Markov Model: a Markov model for a system with hidden states that generate some observed event.

