"""
Tic Tac Toe Player
"""

import math
import copy
import random

X = "X"
O = "O"
EMPTY = None

def initial_state():
    """
    Returns starting state of the board.
    """
    return [[EMPTY, EMPTY, EMPTY],
            [EMPTY, EMPTY, EMPTY],
            [EMPTY, EMPTY, EMPTY]]

def player(board):
    """
    Returns player who has the next turn on a board.
    """
    cntX, cntO = 0, 0
    for i in range(3):
        for j in range(3):
            if board[i][j] == X:
                cntX += 1
            elif board[i][j] == O:
                cntO += 1
    return X if cntX == cntO else O

def actions(board):
    """
    Returns set of all possible actions (i, j) available on the board.
    """
    actions = []
    for i in range(3):
        for j in range(3):
            if board[i][j] == EMPTY:
                actions.append((i, j))
    random.shuffle(actions) # To introduce variability in optimal moves
    return actions

def result(board, action):
    """
    Returns the board that results from making move (i, j) on the board.
    """
    if board[action[0]][action[1]] != EMPTY:
        raise Exception("Invalid Action")
    new_board = copy.deepcopy(board)
    new_board[action[0]][action[1]] = player(board)
    return new_board

def winner(board):
    """
    Returns the winner of the game, if there is one.
    """
    for i in range(3):
        if board[i][0] == board[i][1] == board[i][2] != EMPTY:
            return board[i][0]
    for j in range(3):
        if board[0][j] == board[1][j] == board[2][j] != EMPTY:
            return board[0][j]
    if board[0][0] == board[1][1] == board[2][2] != EMPTY:
        return board[0][0]
    if board[0][2] == board[1][1] == board[2][0] != EMPTY:
        return board[0][2]
    return None

def terminal(board):
    """
    Returns True if game is over, False otherwise.
    """
    if winner(board):
        return True
    for i in range(3):
        for j in range(3):
            if board[i][j] == EMPTY:
                return False
    return True

def utility(board):
    """
    Returns 1 if X has won the game, -1 if O has won, 0 otherwise.
    """
    if terminal(board) == False:
        raise Exception("Game is not over yet")
    win = winner(board)
    if win == X:
        return 1
    elif win == O:
        return -1
    else:
        return 0

def min_value(board, history_min_value):
    if terminal(board):
        return utility(board)
    score = math.inf
    for action in actions(board):
        score = min(score, max_value(result(board, action), score))
        if score <= history_min_value: # Alpha Pruning
            break
    return score

def max_value(board, history_max_value):
    if terminal(board):
        return utility(board)
    score = -math.inf
    for action in actions(board):
        score = max(score, min_value(result(board, action), score))
        if score >= history_max_value: # Beta Pruning
            break
    return score

def minimax(board):
    """
    Returns the optimal action for the current player on the board.
    """
    if terminal(board):
        return None
    if player(board) == X:
        max_score = -math.inf
        best_action = None
        for action in actions(board):
            score = min_value(result(board, action), max_score)
            if score > max_score:
                max_score = score
                best_action = action
        return best_action
    else:
        min_score = math.inf
        best_action = None
        for action in actions(board):
            score = max_value(result(board, action), min_score)
            if score < min_score:
                min_score = score
                best_action = action
        return best_action