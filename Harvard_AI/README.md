## Harvard CS 50 AI: Introduction to Artificial Intelligence with Python

- Course Website: https://cs50.harvard.edu/ai/
- Course Video: https://www.bilibili.com/video/BV1pk4y137dN
- Course Content:
  - Lec 0. Search: Depth-First Search, Breadth-First Search, Greedy Best-First Search, A* Search, Minimax, Alpha-Beta Pruning.
  - Lec 1. Knowledge: Propositional Logic. Entailment. Inference. Model Checking. Resolution. First Order Logic.
  - Lec 2. Uncertainty: Probability. Conditional Probability. Random Variables. Independence. Bayes’ Rule. Joint Probability. Bayesian Networks. Sampling. Markov Models. Hidden Markov Models.
- 有 quiz 和 project (我称之为 lab)

- Course Lab:
  - Lab 1. Degrees: 给定数据集下, 计算两点间最短路.

    ![](assets/Degrees.png) 

    - 使用 bfs 同时记录前驱.
  - Lab 2. Tic-Tac-Toe: 实现一个人机交互, 玩井字棋.

    ![](assets/Tic-Tac-Toe.png) 
    
    - 根据当前的 state 选择最优的 action. 我使用了 alpha-beta 剪枝优化 minimax 搜索, 实测效率有明显提升.

  - Lab 3. knights: 构建知识库, 使用自动逻辑求解器, 判断每个人是 Knight 还是 Knave.
    
    ![](assets/knights.png)

    - 主要考验逻辑的缜密性, 想清楚每条语句的形式化表达, 应该还算容易.
  
  - Lab 4. minesweeper: 构建 knowledge-based Minesweeper Agents, 实现 AI 扫雷.

    ![](assets/minesweeper.png)

    - 核心在于 `add_knowledge` 的处理, 每次新加一条信息, 可能会导致某些信息得出 "cells 全是雷 / 安全" 的结论, 也可能导致两个信息间存在子集关系, 可以作差得到更小规模的信息, 并且可能连锁反应, 需要一直迭代, 直到得不到有效信息.
