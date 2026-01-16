#import "template.typ":*
#show table: three-line-table

#show :template-title-row.with(
  title: "Numerical Analysis",
  authors: (),
  date: "2026.01.15",
  lang: "en"
)

#(c.summary)[
- Basic Knowledge
  - Ch 1. Mathematical Preliminaries
    - Roundoff Errors, Convergence
- Solution of Equation (Convergence, Stability)
  - Ch 2. Solutions of Equations in One Variable
    - Find a root of $f(x)=0$.
  - Ch 6. Direct Methods for Solving Linear Systems
    - Solve $A x=b$.
  - Ch 7. Iterative Techniques in Matrix Algebra
]

= Mathematical Preliminaries

== Roundoff Errors and Computer Arithmetic

- *Truncation Error*: the error involved in using a truncated, or finite, summation to approximate the sum of an infinite series.

- *Roundoff Error*: the error produced when performing real number calculations.  It occurs because the arithmetic performed in a machine involves numbers with only a finite number of digits.

- Normalized decimal floating-point form of a real number:

#image("assets/P1.png")


#(c.example)[
Approximate $integral_0^1 e^(-x^2) dif x$.

$
  integral_0^1 e^(-x^2) dif x&=integral_0^1 (1-x^2+x^4/2!-x^6/3!+x^8/4!-dots) dif x \
  &=underbrace(1 - 1/3 + 1/2! times 1/5 - 1/3! times 1/7, S_4)+underbrace(1/4! times 1/9-dots,R_4)
$

Take $integral_0^1 e^(-x^2) dif x approx S_4 approx 1-0.333+0.1-0.024=0.743$. 

Here *0.024* is roundoff error, and the *remainder $R_4$* is truncation error. The roundoff error $<0.0005 times 2=0.001$ and
$
  |R_4|=|1/4! times 1/9-1/5! times 1/11+dots|<1/4! times 1/9<0.005
$

The total error does not exceed $0.006$.
]


- If $p^*$ is an approximation to $p$, the *absolute error* is $|p-p^*|$, and the *relative error* is $(|p-p^*|)/(|p|)$, provided that $p eq.not 0$.

- The number $p^*$ is said to approximate $p$ to *$t$ significant digits* if $t$ is the largest nonnegative integer for which

$
  (|p-p^*|)/(|p|)<5 times 10^(-t)
$

#(c.example)[
Evaluate $f(x)=x^3-6.1x^2+3.2x+1.5$ at $x=4.71$ using $3$-digit arithmetic.
#image("assets/P2.png")
]

== Algorithms and Convergence

- An algorithm that satisfies that small changes in the initial data produce correspondingly small changes in the final results is called *stable*; otherwise it is *unstable*. An algorithm is called *conditionally stable* if it is stable only for certain choices of initial data.

- Suppose that $E_0>0$ denotes an initial error and $E_n$ represents the magnitude of an error after n subsequent operations. If $E_n approx C n dot E_0$, where $C$ is a constant independent of $n$, then the growth of error is said to be *linear*. If $E_n approx C^n dot E_0$, for some $C > 1$, then the growth of error is called *exponential*.

#(c.example)[
Evaluate $I_n=1/e integral_0^1 x^n e^x dif x$, $n=0,1,2,dots$

#image("assets/P3.png")
#image("assets/P4.png")
]

= Solutions of Equations in One Variable

== The Bisection Method

- Suppose that $f in C[a, b]$ and $f(a) dot f(b) < 0$. The Bisection method generates a sequence ${ p_n } (n = 0, 1, 2, dots)$ approximating a root $p$ of $f$ with

$
  |p_n-p|<= (b-a)/2^n
$

#(c.danger)[
#image("assets/P5.png")

- Why not $p=(a+b)/2$?
- Why not $"FA" dot "FP">0$?
]

== Fixed-Point Iteration

- $f(x)=0$: Root of $f(x)$; $x=g(x)$: Fixed-point of $g(x)$. They are equivalent.

#(c.example)[
Which ones are convergent and why?
#image("assets/P6.png")
]

#(c.note)(title: "Fixed-Point Theorem")[
- Let $g in C[a,b]$ be such that $g(x) in [a,b]$, for all $x$ in $[a,b]$. Suppose, in addition, that $g'(x)$ exists on $(a,b)$ and that a constant $0<k<1$ exists with *$|g'(x)<=k|$* for all $x in (a,b)$. Then, for any number $p_0$ in $[a,b]$, the sequence defined by $p_n=g(p_(n-1))$, $n>=1$, *converges to the unique fixed point $p$ in $[a,b]$*.

#image("assets/P7.png")
#image("assets/P8.png")

- Collary: If $g(x)$ satisfies the hypotheses of the Fixed-Point Theorem, then bounds for the error involved in using $p_n$ to approximate $p$ are given by (for all $n>=1$):

$
  |p_n-p|<=1/(1-k) |p_(n+1)-p_n| \

  |p_n-p|<=(k^n)/(1-k) |p_1-p_0| 
$

- The *smaller* the $k$, the faster the convergence.
]


#image("assets/P9.png")

== Newton's Method (Newton-Raphson Method)

$
  p_n=p_(n-1)-(f(p_(n-1)))/(f'(p_(n-1)))
$

#(c.note)(title: "Theorem")[
  Let $f in C^2[a,b]$. If $p in [a,b]$ is such that $f(p)=0$ and $f'(p)eq.not 0$, then there exists a $delta >0$ such that Newton's method generates a sequence ${p_n}$ converging to $p$ for any initial approximation $p_0 in [p-delta, p+delta]$.

#image("assets/P10.png")
#image("assets/P11.png")
]

== Error Analysis for Iterative Methods

- Suppose ${p_n}$ is a sequence that converges to $p$, with $p_n eq.not p$ for all $n$. If positive constants $alpha$ and $lambda$ exist with

$
  lim_(n arrow infinity) (|p_(n+1)-p|)/(|p_n-p|^(alpha))=lambda
$

then ${p_n}$ converges to $p$ of *order $alpha$, with asymptotic error constant $lambda$*.

- If $alpha=1$, the sequenec is *linearly* convergent.
- If $alpha=2$, the sequence is *quadratically* convergent.
- The *larger* the $alpha$, the faster the convergence.

#(c.note)[
- How can we practically determine $alpha$ and $lambda$?

Let $p$ be a fixed point of $g(x)$. If there exists some constant $alpha>=2$ such that $g in C^(alpha) [p-delta,p+delta]$, *$g'(p)=dots=g^((alpha-1))(p)=0$, and $g^((alpha))(p)eq.not 0$*. Then the iterations with $p_n=g(p_(n-1))$ is of order $alpha$.
]

#(c.example)[
#image("assets/P12.png")

#image("assets/P13.png")

#image("assets/P14.png")
]

== Acclerating Convergence

- *Aitken's $Delta^2$ Method*:

#image("assets/P15.png")
#image("assets/P16.png")

- Steffensen's Method: *Local quadratic convergence if $g'(p)eq.not 1$*.

#image("assets/P17.png")
#image("assets/P18.png")

= Direct Methods for Solving Linear Systems

== Linear Systems of Equations

#image("assets/P19.png")

== Pivoting Strategies

#(c.danger)[
  Problem: Small pivot element may cause trouble.
]

=== Partial Pivoting (or maximal column pivoting)

- Determine the smallest $p>=k$ such that $|a_(p,k)^((k))|=max_(k<=i<=n) |a_(i,k)^((k))|$ and interchange the $p$-th and the $k$-th rows. 

#image("assets/P20.png")

=== Scaled Partial Pivoting (or scaled-column pivoting)

#image("assets/P21.png")

=== Complete Pivoting (or maximal pivoting)

Search all the entries $a_(i,j)$ for $i,j=k,dots,n$ to find the entry with the largest magnitude. Both row and column interchanges are performed to bring this entry to the pivot position.

#image("assets/P22.png")

== Matrix Factorization

#image("assets/P23.png")
#image("assets/P24.png")

- Factorize $A$ first, then for every $b$ you only have to solve two simple triangular systems $L y=b$ and $U x=y$.

#image("assets/P25.png")

== Special Types of Matrices

=== Strictly Diagonally Dominant Matrix

$
  |a_(i,i)| > sum_(j=1,j eq.not i)^n |a_(i,j)|
$

#image("assets/P26.png")

=== Choleski's Method for Positive Definite Matrix

#image("assets/P27.png")

#image("assets/P28.png")

#image("assets/P29.png")

=== Crout Reduction for Tridiagonal Linear Systems

#image("assets/P30.png")

- The process cannot continue if $alpha_i=0$. Hence not all the tridiagonal linear sytem can be solved by this method.

#image("assets/P31.png")

= Iterative Techniques in Matrix Algebra

#(c.summary)[
#image("assets/P32.png")
]

== Norms of Vectors and Matrices

- Vector Norms

#image("assets/P33.png")

- Matrix Norms
  - ||A+B||<=||A||+||B||.

#image("assets/P34.png")

== Eigenvalues and Eigenvectors

- Spectral Radius

#image("assets/P35.png")

== Iterative Techniques for Solving Linear Systems

- Jacobi Iterative Method

#image("assets/P36.png")

#image("assets/P37.png")

- Since $A$ will not be changed during the iterations, we can reorder the equations so that $a_(i,i)eq.not 0$. Otherwise $A$ is *singular*.

- Gauss-Seidel Iterative Method

#image("assets/P38.png")

== Convergence of Iterative Methods

#image("assets/P39.png")

#image("assets/P40.png")

#image("assets/P41.png")

== Relaxation Methods

#image("assets/P42.png")
#image("assets/P43.png")
#image("assets/P44.png")

== Error Bounds and Iterative Refinement

- Target: How will the errors of $A$ and $b$ affect the solution $x$ of $A x=b$?


#image("assets/P47.png")
#image("assets/P45.png")
#image("assets/P46.png")

== Iterative Refinement

#image("assets/P48.png")