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
]

#(c.summary)[
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

#align(center, image("assets/Parallel_Merging_2.png", width: 100%))

$T(n)=O(log n)$, $W(n)=O(n log n)$ and $P(n)=O(n)$.

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

- Suppose the internal memory can handle $M$ records at a time, we define a #highlight($bold("run")$) as a sorted sequence of $M$ records.
  - In this example, `(11, 81, 94)`, `(12, 35, 96)` ... are runs.

- #highlight($bold("pass")$) means the number of loops of merging.
  - In this example, we need $1+3$ passes to sort the data.
  - In general, if we have $N$ records to sort, we need $1+ceil(log_2(N/M))$ passes.

#(c.analysis)[
- Q: How to reduce the number of passes?

  Use a $k$-way merge (instead of $2$-way merge).
    - Pros: need $1+ceil(log_k (N/M))$ passes. 
    - Cons: need $2k$ tapes.
- Q: Can we use $3$ tapes for a $2$-way merge?

  Yes (Fibonacci numbers).

  #align(center, image("assets/External_Sorting_2.png", width: 100%))


]