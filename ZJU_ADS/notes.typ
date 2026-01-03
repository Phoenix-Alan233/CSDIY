#import "template.typ":*

#show :template-title-row.with(
  title: "Advanced Data Structures and Algorithm Analysis",
  authors: (),
  date: "2026.01.01",
  lang: "en"
)

#(c.warning)[
  - If not mentioned, we assume arrays are 1-indexed.
  - Some solutions are out-of-date, I am disappointed at this courseware.
  - I omit some contents about data structures (because it's trivial for me) and algorithms (dp, greedy, etc). 
]

#(c.summary)[
  - NP-Completeness
  - Approximation Algorithms
  - Local Search
  - Randomized Algorithms
  - Parallel Algorithms
  - External Sorting
]

= Parallel Algorithms

#(c.abstract)[
  - “大功率跑车” 
  #align(right)[——王灿老师]
  - Balance the $W,T$ and $P$.
]

#(c.info)[
  - Work load $W(n)$: total number of operations.
  - Time complexity $T(n)$: worst-case running time.
  - Processors $P(n)$: total number of processors.
]

== Summation

#(c.question)[
Given an array $A$ of size $n$, compute the summation of all elements in $A$.
]

#align(center, image("assets/Parallel_Summation.png", width: 100%))

$
  B(h,i)=B(h-1,2i-1)+B(h-1,2i)  
$

#align(center, image("assets/Parallel_Summation_code.png", width: 100%))

$T(n)=O(log n)$, $W(n)=O(n)$ and $P(n)=O(n)$.

== Prefix Sums

#(c.question)[
Given an array $A$ of size $n$, compute the prefix sums array $S$ where $S_i=sum_(j=1)^(i) A_j$ for $1 <= i <= n$.
]

Based on $bold("Summation")$ problem, we design a two-phase algorithm:

#align(center, image("assets/Parallel_Prefix_Sums.png", width: 100%))

$
  C(h,i)=cases(
    B(h,i) &"if" i=1,
    C(h+1,(i-1)/2)+B(h,i) &"if" i>1 and "i is odd",
    C(h+1,i/2) &"if" "i is even"
    )
$

$T(n)=O(log n)$, $W(n)=O(n)$ and $P(n)=O(n)$.

== Merging

#(c.question)[
Given two sorted arrays $A$ and $B$ of size $n$, merge them into a sorted array $C$ of size $2n$.
]

First, we transform the problem into the $bold("Ranking")$ problem.

#align(center, image("assets/Parallel_Merging.png", width: 100%))

#(c.important)[
#align(center, image("assets/Parallel_Merging_2.png", width: 100%))

- Binary Search: $T(n)=O(log n)$, $W(n)=O(n log n)$ and $P(n)=O(n)$.
- Serial Ranking: $T(n)=O(n)$, $W(n)=O(n)$ and $P(n)=O(1)$.
]

== Parallel Ranking

#(c.question)[
Given two sorted arrays $A$ and $B$ of size $n$, the ranking problem is to find for each element $A_i$, the number of elements in $B$ that are less than $A_i$.
]

#align(center, image("assets/Parallel_Ranking.png", width: 100%))  

$T(n)=O(log n)$, $W(n)=O(n)$ and $P(n)=O(n/(log n))$.

== Maximum Finding

#(c.question)[
Given an array $A$ of size $n$, find the maximum element in $A$.
]

- Solution 1: Replace `+` by `max` in the $bold("Summation")$ problem.
  - $T(n)=O(log n)$, $W(n)=O(n)$.
- Solution 2: Compare all pairs.
  - $T(n)=O(1)$, $W(n)=O(n^2)$ and $P(n)=O(n^2)$.
  - Solve access conflicts (Processors try to write to the same location):
    - `Test and Set`, `Fetch and Add`, `Compare and Swap`, etc.
- Solution 3: Divide into $sqrt(n)$ sub-problems, and use $bold("Solution 2")$.
  - $T(n)=T(sqrt(n))+O(1) arrow.double T(n)=O(log log n)$.
  - $W(n)=sqrt(n) W(sqrt(n))+O(n) arrow.double W(n)=O(n log log n)$.
  - $P(n)=O(n)$.
- Solution 4: We first partition $A$ by $h=log log n$, using brute force to get the maximum elements in every $h$ elements, then apply the $bold("Solution 3")$.
  - $T(n)=O(h+log log (n/h))=O(log log n)$.
  - $W(n)=O(n+(n/h) log log (n/h))=O(n)$.
  - $P(n)=O(n/(log log n))$. 
- Solution 5: Random Sampling.

  #(c.tip)[
    - Randomly select $n^(7/8)$ elements from $A$, run the algo in the picture.
    - Denote the maximum of the selected elements as $M$, delete all elements smaller than $M$ in $A$.
    - Repeat the procedure, until the size of $A$ becomes $1$. 
  ]
  
  #align(center, image("assets/Parallel_Maximum_Finding_Random_Sampling.png", width: 100%))

  It's obviously that the expected size of $A$ after an iteration is reduced to $n^(1/8)$, thus the expected number of iterations is $O(1)$ (Usually equals to $2$).

  $T(n)=O(1)$, $W(n)=O(n)$ and $P(n)=O(n)$.

= External Sorting

#(c.info)[
  - 硬盘 (hard disk), 磁道 (track), 扇区 (sector).
  #align(center, image("assets/Cylinder_Head_Sector.svg", width: 80%))

  - To get $a_i$ on hard disk, we need to find the track, then find the sector, find $a_i$ and transmit.

  - We use #highlight("tapes") (sequential access devices) and #highlight("merge") to implement external sort.
]

#align(center, image("assets/External_Sorting_1.png", width: 100%))

- Suppose the internal memory can handle $M$ records at a time.

- We define a #highlight($bold("run")$) (#highlight("顺串")) as a sorted sequence .
  - eg. In the first pass (Internal Sorting Stage), `(11, 81, 94)` is a run.

- #highlight($bold("pass")$) (#highlight("读写次数 / 趟数")) means the number of loops of merging.
  - In this example, we need $1+3$ passes to sort the data.
  - In general, if we have $N$ records to sort, we need $1+ceil(log_2(N/M))$ passes.

#(c.analysis)[
- Q: How to reduce the number of passes?

  Use a $k$-way merge (instead of $2$-way merge).
    - Pros: need $1+ceil(log_k (N/M))$ passes. 
    - Cons: need $2k$ tapes.
- Q: Can we use $k+1$ tapes for a $k$-way merge?

  Yes. eg. $2$-way merge, we can use $3$ tapes ($bold("Fibonacci numbers")$).

  #align(center, image("assets/External_Sorting_2.png", width: 100%))

- Q: How to minimize the merge time?

  #align(center, image("assets/External_Sorting_3.png", width: 100%))
]

- Replacement Selection

#(c.analysis)[
#align(center, image("assets/External_Sorting_4.png", width: 100%))
- generate runs of average length $2M$.
]

- Parallel

#(c.analysis)[
- In general, for a $k$-way merge we need $2k$ input buffers and $2$ output buffers for $bold("parallel operations")$.

- For each stream, two buffers (A and B) are used. Buffer A is filled with data read from disk, while buffer B is sorted at the same time. When buffer B finishes sorting, it swaps with the now-full buffer A. The empty buffer can then be reused for reading, enabling overlap of I/O and computation.
]

= Problem Set (Strange? Trash? No Human?)

== Data Structures

#(c.question)[
  By definition, for #highlight("a light node") $p$ in a skew heap, the number of descendants of $p$'s right subtree is no more than $1/2$ of the number of descendants of $p$.
]

`F`. If equals, by definition it is #highlight("a heavy node") (Consider the case the left subtree is empty and the right subtree has only one node).

#(c.question)[
  We have a binary counter of $k$ bits. Each time we conduct an increment on the counter: $x equiv x+1 (mod 2^k)$ and the cost of the increment is the number of bits we need to flip. For example, when $k=3$, currently we have $x=010$, after increment we have $x=011$. Then this increment costs 1 because only 1 bit flips after increment. If we conduct the increment again, $x=100$. Then this increment costs 3 because we flip 3 bits. Now we conduct $n$ consecutive increments and estimate the total cost. Which of the following statements are TRUE?

  1. If the initial value of the counter is 0, the total cost is $O(n)$.
  
  2. If the initial value of the counter is 0, the total cost is $O(n log k)$.

  3. If n = $Omega(k)$, the total cost is $O(n)$.

  4. If n = $Omega(k)$, the total cost is $O(n log k)$.

  A. 2 and 4
  
  B. 2 and 3
  
  C. 1 and 3
  
  D. 1 and 4
]

`C`. 1 is obvious. Consider 3, for the bit $i$, there are at most $floor(n/2^i)$ flips. Thus the total cost is $O(k)+O(sum_i floor(n/2^i))$. Since $n=Omega(k) arrow.double k=O(n)$, it is $O(n)$. 

#(c.question)[
  If a leftist heap can be implemented recursively, so can its counterpart skew heap.
]

`F`. idk. Why not true?

#(c.question)[
  A binary tree that is not full cannot correspond to an optimal prefix code. (T/F)
]

`T`. There are $3$ concepts.

- *Full Binary Tree*: every node has either $0$ or $2$ children.
- *Complete Binary Tree*: all levels are fully filled except possibly the last, which is filled from left to right.
- *Perfect Binary Tree*: all internal nodes have two children and all leaves are at the same level.

Thus an optimal prefix code must be a full binary tree, otherwise we can #highlight("delete the node with only one child") to reduce the cost.

== Inverted File Index

#(c.question)[
  In a search engine, #highlight("thresholding for query") retrieves the top $k$ documents according to their weights. (T/F)
]

`F`. It confuses two different optimizations.

- *Document Thresholding*: Filters and retrieves the top $k$ documents based on their weights.
- *Query Thresholding*: Optimizes performance by selecting only #highlight("high-frequency or important query terms") to process, rather than the entire query.

Thus the proposition should be #highlight("thresholding for documents").

#(c.question)[
  When evaluating the performance of #highlight("data retrieval"), it is important to measure the relevancy of the answer set. (T/F)
]

`F`. It confuses two different concepts.

- *Data retrieval* (eg. SQL Query): #highlight("matches a query exactly").
  - It is *binary (Y/N)*. We measure *efficiency* (how fast the system responds). 
- *Information retrieval* (eg. Google Search): #highlight("'about' a certain topic").
  - It is subjective and based on *relevancy*. We measure *effectiveness* (how relevant the answer set is to the user's needs).

== Backtracking

#(c.question)[
  What makes the time complexity analysis of a backtracking algorithm very difficult is that #highlight("the sizes of solution spaces may vary"). (T/F)
]

`F`. Strange problem.

#(c.question)[
  What makes the time complexity analysis of a backtracking algorithm very difficult is that #highlight("the number of solutions that do satisfy the restriction is hard to estimate"). (T/F)
]

`T`.

== Divide and Conquer

#(c.question)[
  Is this asymptotic upper bound for the following recursive $T(n)$ is correct?
  - $T(n)=T(n^(1/3))+T(n^(2/3))+log n$. Then $T(n)=O(log n log log n)$.
]

`T`. By recursion tree method, the height of the tree is $O(log log n)$, and the cost at each level is $O(log n)$. Thus the total cost is $O(log n log log n)$.

== NP-Completeness

#(c.question)[
  The following problem is in co-NP. (T/F)
  - Given a positie integer $K$, is $K$ a prime number?
]

`T`. This is P problem, and P $subset.eq$ co-NP.

== Approximation Algorithms

#(c.question)[
  In the bin packing problem, we are asked to pack a list of items $L$ to the minimum number of bins of capacity $1$. For the instance $L$, let $"FF"(L)$ denote the number of bins used by the algorithm First Fit. The instance $L'$ is derived from $L$ by deleting one item from $L$. Then $"FF"(L')$ is at most of $"FF"(L)$. (T/F)
]

`F`. Consider the instance $L={0.55,0.7,0.55,0.1,0.45,0.15,0.3,0.2}$, and $L'=L-{0.1}$. $"FF"(L')=4$, while $"FF"(L)=3$.

#(c.question)[
  Consider the bin packing problem which uses a minimum number of bins to accommodate a given list of items. Recall that Next Fit (NF) and First Fit (FF) are two simple approaches, whose (asymptotic) approximation ratios are 2 and 1.7, respectively. Now we focus on a special class $"I2"$ of instances in which only two distinct item sizes appear. Check which of the following statements is true by applying NF and FF on $"I2"$.

A. NF and FF both have improved approximation ratios.

B. NF has an improved approximation ratio, while FF does not.

C. FF has an improved approximation ratio, while NF does not.

D. Neither of NF or FF has an improved approximation ratio.
]

`C`. For #highlight("NF") algorithm, we construct $1/"eps"$ pairs:

```
0.9 - eps, 2 * eps
...
0.9 - eps, 2 * eps
```

Obviously $"OPT"=1/"eps"+1$, while $"NF"=2/"eps"$. Thus the approximation ratio is $2/(1+"eps") ~ 2$.

For #highlight("FF") algorithm, idk. But we can feel it is improved.

== Local Search

#(c.question)[
  For an optimization problem, given a neighborhood, if its local optimum is also a global optimum, one can reach an optimal solution with #highlight("just one step") of local improvements. (T/F)
]

`F`. The proposition means that *any local optimum is a global optimum*, thus we can always find the global optimum by #highlight("Local Search"). However, it doesn't mean we can reach the optimum in just one step.

== External Sorting

#(c.question)[
  If only one tape drive is available to perform the external sorting, then the tape access time for any algorithm will be $Omega (n^2)$. (T/F)
]

`T`. idk.

= References

#(c.info)(title: "homework")[
- https://roderickshao.github.io/RoderickShao_notebook/%E8%AE%A1%E7%AE%97%E6%9C%BA%E5%9F%BA%E7%A1%80%E8%AF%BE/%E9%AB%98%E7%BA%A7%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84%E4%B8%8E%E7%AE%97%E6%B3%95%E5%88%86%E6%9E%90/Homework

- https://mem.ac/course/ads/correction/

]

#(c.note)(title: "notes")[
- https://wintermelonc.github.io/WintermelonC_Docs/zju/compulsory_courses/ADS/

- https://zhoutimemachine.github.io/note/courses/ads-final-review/

- https://birchtree2.github.io/%E5%A4%A7%E4%BA%8C%E4%B8%8B/ADS
]