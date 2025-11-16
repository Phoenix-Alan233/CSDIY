## Harvard CS 50 AI: Introduction to Artificial Intelligence with Python

- Course Website: https://cs50.harvard.edu/ai/
- Course Video: https://www.bilibili.com/video/BV1pk4y137dN
- Course Content:
    - Lec 0. Search: Depth-First Search, Breadth-First Search, Greedy Best-First Search, A* Search, Minimax, Alpha-Beta Pruning.
    - Lec 1. 
- Course Lab:
    - Lab 1. Degrees: 给定数据集下, 计算两点间最短路.
      ![](assets/Degrees.png) 
      - 使用 bfs 同时记录前驱.
    - Lab 2. Tic-Tac-Toe: 实现一个人机交互, 玩井字棋.
      ![](assets/Tic-Tac-Toe.png) 
      - 使用"强化学习"的一套流程, 根据当前的 state 选择最优的 action. 我使用了 alpha-beta 剪枝优化 minimax 搜索, 实测效率有明显提升.

---

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
