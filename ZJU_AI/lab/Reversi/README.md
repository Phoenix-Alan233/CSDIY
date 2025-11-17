使用 **蒙特卡洛树搜索算法** 实现一个 **黑白棋 (Reversi)** 的简易 AI.

原 lab 已经实现好了 `board.py` 以及 `game.py`, 提供了如下主要接口:

- `Board` 类:
    - `_move`: 落子, 并获取反转棋子的坐标 list;

    - `_can_fliped`: 检测落子是否合法, 如果不合法返回 False, 否则返回反转棋子的坐标 list;

    - `get_winner`: 判断黑棋和白棋的输赢, 并计算赢的棋子个数.
- `Game` 类:
    - 初始化传入黑方（如 `AIPlayer`）和白方（如 `RandomPlayer`）；
    - `run`: 开始自动化游戏.

现在已经有平凡的 `RandomPlayer`（纯随机落子）以及 `HumanPlayer`（手动落子）, 主要是去实现 `AIPlayer`, 并跟 Mo 平台上的 **初中高级 AI** 进行对抗. 

我的这份实现对抗效果优异, 初中级稳赢, 高级 AI 极大概率获胜.