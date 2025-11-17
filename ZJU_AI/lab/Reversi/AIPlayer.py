from copy import deepcopy
from math import sqrt, log
import random

# 导入棋盘文件
from board import Board

class Node:
    def __init__(self, board, color, action, parent=None):
        self.board = board
        self.color = color
        self.action = action
        self.parent = parent
        self.reward = 0
        self.cnt = 0
        self.child = []
        self.max_child_num = len(list(board.get_legal_actions(color)))

class AIPlayer:
    def __init__(self, color, C=1.5, iterations=200):
        self.color = color
        self.C = C
        self.iterations = iterations

    def GameOver(self, board):
        X_actions = list(board.get_legal_actions('X'))
        O_actions = list(board.get_legal_actions('O'))
        return (len(X_actions) == 0) and (len(O_actions) == 0)

    def expand(self, node):
        actions = list(node.board.get_legal_actions(node.color))
        if len(actions) == 0: return node.parent

        skip_actions = [child.action for child in node.child]
        actions = [action for action in actions if action not in skip_actions]
        action = random.choice(actions)
        board = deepcopy(node.board)
        board._move(action, node.color)
        color = 'X' if node.color == 'O' else 'O'
        node.child.append(Node(board, color, action, node)) 

        return node.child[-1]

    def ucb1(self, reward, cnt, T, C):
        return reward / cnt + C * sqrt(2 * log(T) / cnt)

    def pick(self, node, C):
        max_ucb = -float('inf')
        max_child = []
        for child in node.child:
            ucb = self.ucb1(child.reward, child.cnt, node.cnt, C)
            if ucb > max_ucb:
                max_ucb = ucb
                max_child = [child]
            elif ucb == max_ucb:
                max_child.append(child)
        return random.choice(max_child)

    def select(self, node):
        while not self.GameOver(node.board):
            if node.max_child_num == 0 or len(node.child) < node.max_child_num:
                return self.expand(node)
            else:
                node = self.pick(node, self.C)
        return node

    def simulate(self, node):
        board = deepcopy(node.board)
        color = node.color
        while not self.GameOver(board):
            actions = list(board.get_legal_actions(color))
            if len(actions) != 0:
                action = random.choice(actions)
                board._move(action, color)
            color = 'X' if color == 'O' else 'O'
        winner, diff = board.get_winner()
        if winner == 2:
            return 0
        winner = 'X' if winner == 0 else 'O'
        if winner == self.color:
            return 10 + diff
        else:
            return -10 - diff

    def backpropagate(self, node, reward):
        while node:
            node.cnt += 1
            if node.color == self.color:
                node.reward -= reward
            else:
                node.reward += reward
            node = node.parent

    def UCT(self, root):
        """ Upper Confidence Bounds for Trees Algorithm """
        for _ in range(self.iterations):
            node = self.select(root)
            reward = 0
            for __ in range(10):
                reward += self.simulate(node)
            self.backpropagate(node, reward)
        return self.pick(root, 0).action

    def get_move(self, board):
        print(f"现在 AI 正在思考中")
        root = Node(deepcopy(board), self.color, None)
        return self.UCT(root)