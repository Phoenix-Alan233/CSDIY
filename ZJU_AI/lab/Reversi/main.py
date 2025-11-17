from RandomPlayer import RandomPlayer
from HumanPlayer import HumanPlayer
from AIPlayer import AIPlayer
from game import Game

if __name__ == "__main__":
    black_player = AIPlayer("X")
    white_player = RandomPlayer("O")
    game = Game(black_player, white_player)
    game.run()