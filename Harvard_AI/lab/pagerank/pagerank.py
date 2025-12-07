import os
import random
import re
import sys

DAMPING = 0.85
SAMPLES = 10000


def main():
    if len(sys.argv) != 2:
        sys.exit("Usage: python pagerank.py corpus")
    corpus = crawl(sys.argv[1])
    ranks = sample_pagerank(corpus, DAMPING, SAMPLES)
    print(f"PageRank Results from Sampling (n = {SAMPLES})")
    for page in sorted(ranks):
        print(f"  {page}: {ranks[page]:.4f}")
    ranks = iterate_pagerank(corpus, DAMPING)
    print(f"PageRank Results from Iteration")
    for page in sorted(ranks):
        print(f"  {page}: {ranks[page]:.4f}")


def crawl(directory):
    """
    Parse a directory of HTML pages and check for links to other pages.
    Return a dictionary where each key is a page, and values are
    a list of all other pages in the corpus that are linked to by the page.
    """
    pages = dict()

    # Extract all links from HTML files
    for filename in os.listdir(directory):
        if not filename.endswith(".html"):
            continue
        with open(os.path.join(directory, filename)) as f:
            contents = f.read()
            links = re.findall(r"<a\s+(?:[^>]*?)href=\"([^\"]*)\"", contents)
            pages[filename] = set(links) - {filename}

    # Only include links to other pages in the corpus
    for filename in pages:
        pages[filename] = set(
            link for link in pages[filename]
            if link in pages
        )

    return pages


def transition_model(corpus, page, damping_factor):
    """
    Return a probability distribution over which page to visit next,
    given a current page.

    With probability `damping_factor`, choose a link at random
    linked to by `page`. With probability `1 - damping_factor`, choose
    a link at random chosen from all pages in the corpus.
    """
    trans_prob = dict()
    if len(corpus[page]):
        for next_page in corpus:
            trans_prob[next_page] = (1 - damping_factor) / len(corpus)
        for next_page in corpus[page]:
            trans_prob[next_page] += damping_factor / len(corpus[page])
    else:
        for next_page in corpus:
            trans_prob[next_page] = 1 / len(corpus)
    return trans_prob


def sample_pagerank(corpus, damping_factor, n):
    """
    Return PageRank values for each page by sampling `n` pages
    according to transition model, starting with a page at random.

    Return a dictionary where keys are page names, and values are
    their estimated PageRank value (a value between 0 and 1). All
    PageRank values should sum to 1.
    """
    pagerank = {page: 0 for page in corpus}
    current_page = random.choice(list(corpus.keys()))
    for sample in range(n - 1):
        pagerank[current_page] += 1
        trans_prob = transition_model(corpus, current_page, damping_factor)
        prob = random.random()
        for page in trans_prob:
            if trans_prob[page] < prob:
                prob -= trans_prob[page]
            else:
                current_page = page
                break
    pagerank[current_page] += 1
    for page in pagerank:
        pagerank[page] /= n
    return pagerank


def iterate_pagerank(corpus, damping_factor, eps=0.001):
    """
    Return PageRank values for each page by iteratively updating
    PageRank values until convergence.

    Return a dictionary where keys are page names, and values are
    their estimated PageRank value (a value between 0 and 1). All
    PageRank values should sum to 1.
    """
    pagerank = {page: 1 / len(corpus) for page in corpus}
    while True:
        new_pagerank = {page: 0 for page in corpus}
        for page in pagerank:
            trans_prob = transition_model(corpus, page, damping_factor)
            for new_page in trans_prob:
                new_pagerank[new_page] += pagerank[page] * trans_prob[new_page]
        for page in pagerank:
            if abs(pagerank[page] - new_pagerank[page]) > eps:
                break
        else:
            break
        pagerank = new_pagerank
    return pagerank


if __name__ == "__main__":
    main()
