import sys
import random
from queue import Queue

from crossword import *


class CrosswordCreator():

    def __init__(self, crossword):
        """
        Create new CSP crossword generate.
        """
        self.crossword = crossword
        self.domains = {
            var: self.crossword.words.copy()
            for var in self.crossword.variables
        }

    def letter_grid(self, assignment):
        """
        Return 2D array representing a given assignment.
        """
        letters = [
            [None for _ in range(self.crossword.width)]
            for _ in range(self.crossword.height)
        ]
        for variable, word in assignment.items():
            direction = variable.direction
            for k in range(len(word)):
                i = variable.i + (k if direction == Variable.DOWN else 0)
                j = variable.j + (k if direction == Variable.ACROSS else 0)
                letters[i][j] = word[k]
        return letters

    def print(self, assignment):
        """
        Print crossword assignment to the terminal.
        """
        letters = self.letter_grid(assignment)
        for i in range(self.crossword.height):
            for j in range(self.crossword.width):
                if self.crossword.structure[i][j]:
                    print(letters[i][j] or " ", end="")
                else:
                    print("█", end="")
            print()

    def save(self, assignment, filename):
        """
        Save crossword assignment to an image file.
        """
        from PIL import Image, ImageDraw, ImageFont
        cell_size = 100
        cell_border = 2
        interior_size = cell_size - 2 * cell_border
        letters = self.letter_grid(assignment)

        # Create a blank canvas
        img = Image.new(
            "RGBA",
            (self.crossword.width * cell_size,
             self.crossword.height * cell_size),
            "black"
        )
        font = ImageFont.truetype("assets/fonts/OpenSans-Regular.ttf", 80)
        draw = ImageDraw.Draw(img)

        for i in range(self.crossword.height):
            for j in range(self.crossword.width):

                rect = [
                    (j * cell_size + cell_border,
                     i * cell_size + cell_border),
                    ((j + 1) * cell_size - cell_border,
                     (i + 1) * cell_size - cell_border)
                ]
                if self.crossword.structure[i][j]:
                    draw.rectangle(rect, fill="white")
                    if letters[i][j]:
                        _, _, w, h = draw.textbbox((0, 0), letters[i][j], font=font)
                        draw.text(
                            (rect[0][0] + ((interior_size - w) / 2),
                             rect[0][1] + ((interior_size - h) / 2) - 10),
                            letters[i][j], fill="black", font=font
                        )

        img.save(filename)

    def solve(self):
        """
        Enforce node and arc consistency, and then solve the CSP.
        """
        self.enforce_node_consistency()
        self.ac3()
        return self.backtrack(dict())

    def enforce_node_consistency(self):
        """
        Update `self.domains` such that each variable is node-consistent.
        (Remove any values that are inconsistent with a variable's unary
         constraints; in this case, the length of the word.)
        """
        for variable in self.domains:
            length = variable.length
            new_words = set()
            for word in self.domains[variable]:
                if len(word) == length:
                    new_words.add(word)
            self.domains[variable] = new_words

    def revise(self, x, y):
        """
        Make variable `x` arc consistent with variable `y`.
        To do so, remove values from `self.domains[x]` for which there is no
        possible corresponding value for `y` in `self.domains[y]`.

        Return True if a revision was made to the domain of `x`; return
        False if no revision was made.
        """
        if self.crossword.overlaps[x, y] == None:
            return False
        pos1, pos2 = self.crossword.overlaps[x, y]
        ban_words = set()
        for word1 in self.domains[x]:
            for word2 in self.domains[y]:
                if word1[pos1] == word2[pos2]:
                    break
            else:
                ban_words.add(word1)
        if len(ban_words):
            self.domains[x] -= ban_words
            return True
        else:
            return False

    def ac3(self, arcs=None):
        """
        Update `self.domains` such that each variable is arc consistent.
        If `arcs` is None, begin with initial list of all arcs in the problem.
        Otherwise, use `arcs` as the initial list of arcs to make consistent.

        Return True if arc consistency is enforced and no domains are empty;
        return False if one or more domains end up empty.
        """
        q = Queue()
        if arcs:
            for x, y in arcs:
                q.put((x, y))
        else:
            for v1 in self.domains:
                for v2 in self.domains:
                    if v1 == v2:
                        continue
                    q.put((v1, v2))

        while not q.empty():
            x, y = q.get()
            if self.revise(x, y):
                if len(self.domains[x]) == 0:
                    return False
                for z in self.crossword.neighbors(x):
                    if z == y:
                        continue
                    q.put((z, x))
        return True

    def assignment_complete(self, assignment):
        """
        Return True if `assignment` is complete (i.e., assigns a value to each
        crossword variable); return False otherwise.
        """
        return len(self.domains.keys()) == len(assignment.keys())

    def consistent(self, assignment):
        """
        Return True if `assignment` is consistent (i.e., words fit in crossword
        puzzle without conflicting characters); return False otherwise.
        """
        used_word = set()
        for variable, word in assignment.items():
            if word in used_word:
                return False
            used_word.add(word)
        return True

    def order_domain_values(self, var, assignment):
        """
        Return a list of values in the domain of `var`, in order by
        the number of values they rule out for neighboring variables.
        The first value in the list, for example, should be the one
        that rules out the fewest values among the neighbors of `var`.
        """
        words = list(self.domains[var])
        count = dict()
        for word in words:
            count[word] = 0
            for neighbor in self.crossword.neighbors(var):
                if self.crossword.overlaps[var, neighbor] == None:
                    continue
                pos1, pos2 = self.crossword.overlaps[var, neighbor]
                for neighbor_word in self.domains[neighbor]:
                    if word[pos1] != neighbor_word[pos2]:
                        count[word] += 1
        words = sorted(words, key=lambda word: count[word])
        return words

    def select_unassigned_variable(self, assignment):
        """
        Return an unassigned variable not already part of `assignment`.
        Choose the variable with the minimum number of remaining values
        in its domain. If there is a tie, choose the variable with the highest
        degree. If there is a tie, any of the tied variables are acceptable
        return values.
        """
        variables = set(self.domains.keys()) - set(assignment.keys())
        variables = list(variables)
        variables = sorted(variables, key=lambda variable: len(self.domains[variable]))
        domains_size = len(self.domains[variables[0]])
        variables = [variable for variable in variables if len(self.domains[variable]) == domains_size]
        if len(variables) == 1:
            return variables[0]
        variables = sorted(variables, key=lambda variable: -len(self.crossword.neighbors(variable)))
        neighbors_size = -len(self.crossword.neighbors(variables[0]))
        variables = [variable for variable in variables if -len(self.crossword.neighbors(variable)) == neighbors_size]
        if len(variables) == 1:
            return variables[0]
        else:
            return random.choice(variables)

    def backtrack(self, assignment):
        """
        Using Backtracking Search, take as input a partial assignment for the
        crossword and return a complete assignment if possible to do so.

        `assignment` is a mapping from variables (keys) to words (values).

        If no assignment is possible, return None.
        """
        if self.assignment_complete(assignment):
            return assignment
        variable = self.select_unassigned_variable(assignment)
        for word in self.order_domain_values(variable, assignment):
            assignment.update({variable: word})
            if self.consistent(assignment):
                domains_tmp = self.domains.copy()
                self.domains[variable] = {word}
                arcs = [(neighbor, variable) for neighbor in self.crossword.neighbors(variable)]
                self.ac3(arcs)
                if self.backtrack(assignment):
                    return assignment
                self.domains = domains_tmp
            assignment.pop(variable)
        return None


def main():

    # Check usage
    if len(sys.argv) not in [3, 4]:
        sys.exit("Usage: python generate.py structure words [output]")

    # Parse command-line arguments
    structure = sys.argv[1]
    words = sys.argv[2]
    output = sys.argv[3] if len(sys.argv) == 4 else None

    # Generate crossword
    crossword = Crossword(structure, words)
    creator = CrosswordCreator(crossword)
    assignment = creator.solve()

    # Print result
    if assignment is None:
        print("No solution.")
    else:
        creator.print(assignment)
        if output:
            creator.save(assignment, output)


if __name__ == "__main__":
    main()
