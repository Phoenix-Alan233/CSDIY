## 数学分析 quiz 1 补天

### 单选

> #### 级数
>
> 下列无穷级数中收敛的是（A）

- A. $\sum\limits_{n=1}^{+\infty} \frac{(-1)^n3^{1/n}}{\sqrt{n}}$

  狄利克雷判别法：$\sum \frac{(-1)^n}{\sqrt{n}}$（交错级数）收敛，$3^{1/n}$ 递减趋于 $0$，收敛。

- B. $\sum\limits_{n=2}^{+\infty} \sin \frac{1}{\ln n}$

  比值判别法：$\sin \frac{1}{\ln n}\sim \frac{1}{\ln n}>\frac{1}{n}$，发散。

- C. $\sum\limits_{n=1}^{+\infty} \frac{1}{n^{1+\frac{1}{n}}}$

  法一. 比值判别法：$\lim\limits_{n\to \infty} \frac{\frac{1}{n^{1+1/n}}}{\frac{1}{n}}=\lim\limits_{n\to \infty} \frac{1}{n^{1/n}}=1$，发散。

  法二. 比较判别法：$\frac{1}{n^{1+\frac{1}{n}}}>\frac{1}{n\ln n}$（因为 $n^{1/n}<\ln n$，$n\to \infty$），发散。

- D. $\sum\limits_{n=2}^{+\infty} \frac{(-1)^n}{\sqrt{n}+(-1)^n}$

  比值判别法：奇偶两项 $\frac{1}{\sqrt{n}+1}-\frac{1}{\sqrt{n+1}-1}\sim -\frac{2}{n}$（$n\to \infty$），发散。

Notes.

- 正项级数

比较判别法，比值判别法，根式判别法。

- 交错级数

Leibniz 判别法：单调递减趋于 $0$。

- 一般级数

Abel 判别法：单调有界，部分和收敛；

Dirichlet 判别法：单调趋于 $0$，部分和有界；



> ☆ 已知 $a_n<b_n$，若级数 $\sum a_n$ 与 $\sum b_n$ 均收敛，则“$\sum a_n$ 绝对收敛”是“$\sum b_n$ 绝对收敛”的（充分必要条件）

记 $c_n=b_n-a_n>0$，则 $\sum c_n$ 收敛。又因为是正项级数，所以绝对收敛。

$\Rightarrow$：$\sum |b_n|\le \sum |a_n|+\sum |c_n|$，故 $\sum b_n$ 绝对收敛；

$\Leftarrow$：$\sum |a_n|\le \sum |b_n|+\sum |c_n|$，故 $\sum a_n$ 绝对收敛。



> 设 $\sum a_n$ 条件收敛，且已知 $\exists r\in R$，使得 $\lim\limits_{n\to \infty} \frac{a_{n+1}}{a_n}=r$，则 $r=(-1)$。

显然。



> 已知正项级数 $\sum a_n$ 发散，则下列级数中必定发散的是（C）

- A. $\sum \frac{a_n}{1+a_n^2}$

  $a_n=n^2$，$\sim \frac{1}{n^2}$，收敛。

- B. $\sum \frac{a_n}{1+n^2a_n}$

  $a_n=\frac{1}{n}$，$\sim \frac{1}{n^2}$，收敛。

- ☆ C. $\sum \frac{a_n}{1+a_n}$

  【习题课讲过】假设收敛，记 $b_n=\frac{a_n}{1+a_n}\Rightarrow a_n=\frac{b_n}{1-b_n}$。

  因为 $\sum b_n$ 收敛，故 $b_n\to 0$，因此 $\exists N,\forall n>N,a_n<2b_n$。

  于是 $\sum a_n$ 收敛，矛盾！因此发散。

- ☆ D. $\sum \frac{a_n}{1+na_n}$

  构造 $a_n=\begin{cases}\frac{1}{\sqrt{n}} & \mathrm{n是完全平方数} \\ \frac{1}{n^2} & \mathrm{n不是完全平方数}\end{cases}$。

  当 $n$ 是完全平方数，$=\frac{1}{\sqrt{n}+n}=\frac{1}{k+k^2}$，$k\in Z$，收敛；

  当 $n$ 不是完全平方数，$=\frac{1}{n+n^2}$，收敛。

  因此整体收敛。

Notes. 待定系数 $a_n=n^{\alpha}$，搞一个 $\alpha$ 举反例。以上 $4$ 个都可能发散（$a_n=1$）。



> 下列命题中正确的有（C）

- A. 若级数 $\sum a_n$ 收敛，则级数 $\sum a_n^3$ 收敛。

  $a_{3n+1}=a_{3n+2}=\frac{1}{n^{1/3}},a_{3n+3}=-\frac{2}{n^{1/3}}$，$\sum a_n^3$ 发散。

  反命题也不成立，$a_n=\frac{1}{n}$，$\sum a_n$ 发散。

- B. 若级数 $\sum a_n$ 收敛，则级数 $\sum a^2_n$ 收敛。

  $a_{2n+1}=\frac{1}{\sqrt{n}}$，$a_{2n+2}=-\frac{1}{\sqrt{n}}$，$\sum a_n^2$ 发散。

  反命题也不成立，$a_n=\frac{1}{n}$，$\sum a_n$ 发散。

- ☆ C. 若正项级数 $\sum a_n$ 收敛，且 $\{a_n\}$ 单调，那么 $\lim\limits_{n\to \infty} na_n=0$。

  说明 $\{a_n\}$ 单调递减趋于 $0$。对 $\forall \varepsilon>0$，由柯西准则 $\exists N$，$\forall n>N$，
  $$
  \varepsilon>a_{n+1}+a_{n+2}+\cdots+a_{2n}\ge na_{2n}
  $$
  因此 $\lim\limits_{n\to \infty} na_n=0$。

- D. 若级数 $\sum a_n$ 收敛，则级数 $\sum a_{2n}$ 与 $\sum a_{2n-1}$ 也收敛。

  同 B，错误。





> 下列函数列中一致收敛的是（B）

- A. $f_n(x)=n\sin \frac{x}{n}$，$n\in N$，$x\in R$

  $f(x)=x$，上确界判别法：

  $\lim\limits_{n\to \infty} \sup\limits_{x\in R}\{|x-n\sin \frac{x}{n}|\}=+\infty$（取 $x=\frac{n\pi}{2}$），非一致收敛。

- B. $f_n(x)=\frac{x}{1+n^2x^2}$，$n\in N$，$x\in R$

  $f(x)=0$，上确界判别法：

  $|f_n(x)|=|\frac{1}{\frac{1}{x}+n^2x}|\le \frac{1}{n}$，$\lim\limits_{n\to \infty}\sup\limits_{x\in R}\{|f_n(x)|\}=0$，一致收敛。

- C. $f_n(x)=\frac{nx}{1+n^2x^2}$，$n\in N$，$x\in R$

  $f(x)=0$，上确界判别法：

  $\lim\limits_{n\to \infty}\sup\limits_{x\in R}\{|f_n(x)|\}\ge \frac{1}{2}$（取 $x=\frac{1}{n}$），非一致收敛。

- D. $f_n(x)=\frac{x}{n}$，$n\in N$，$x\in R$

  显然非一致收敛。



> 设 $f_n(x)=\frac{\sin (nx)}{\sqrt{n}}$，以下说法错误的是（A）

- A. $\sum f_n(x)$ 在 $[-\pi,\pi]$ 上一致收敛

  不对的，用柯西收敛准则，硬卡就好了。

- B. $\sum f_n(x)$ 在 $[-\pi,\pi]$ 上逐点收敛

  狄利克雷判别法显然。

- C. $\sum f_n(x)$ 不可能是任何一个在 $[-\pi,\pi]$ 上可积的函数的傅里叶级数

  如果是，由贝塞尔不等式知，$\sum (\frac{1}{\sqrt{n}})^2$ 应该就收敛了，矛盾。





> #### 幂级数
>
> 设幂级数 $\sum a_n(x-1)^n$ 的收敛半径是 $1$，则级数 $\sum\limits_{n=1}^{+\infty} 2^na_n$（发散）
>
> 发散 / 条件收敛 / 绝对收敛 / 无法确定

代入 $x=3$，发散。

Notes. $\rho=\lim\limits_{n\to \infty} \frac{a_{n+1}}{a_n}$，$R=\frac{1}{\rho}$（收敛半径）。

> 幂级数 $\sum\limits_{n=1}^{\infty} \frac{x^n}{n(3^n+(-2)^n)}$ 的收敛域为 $[-3,3)$。

显然 $\rho=\frac{1}{3}$，$R=3$。

当 $x=3$，比值判别法知发散；当 $x=-3$，Leibniz 判别法（比大小不显然，列出来化简发现当 $n$ 足够大时是对的）知收敛。

因此收敛域是 $[-3,3)$。



> #### 傅里叶级数
>
> 已知 $f(x)=\begin{cases}\sin \pi x & 0\le x<\frac 12 \\ 0 & \frac{1}{2}\le x\le 1\end{cases}$，记 $b_n=2\int_0^1 f(x)\sin n\pi xdx$，$S(x)=\sum\limits_{n=1}^{+\infty} b_n\sin n\pi x$，则：
>
> $S(0)=0$，$S(\frac{3}{2})=-\frac{1}{2}$。

奇延拓，$b_n=2\int_0^\frac{1}{2}\sin\pi x\cdot \sin n\pi xdx$，$S(0)$ 显然 $=0$。$S(\frac{3}{2})=\sum\limits_{n=1}^{+\infty} b_{2n-1}(-1)^n$。

$b_1=\frac{1}{2}$，$b_{2n-1}=0$。因此 $S(\frac{3}{2})=-\frac{1}{2}$。

> 已知 $f(x)=\begin{cases}x &0\le x<\frac{1}{2} \\ 5-3x & \frac{1}{2}<x\le 1\end{cases}$，$S(x)=\frac{a_0}{2}+\sum\limits_{n=1}^{+\infty} a_n\cos n\pi x\ (x\in R)$，其中 $a_n=2\int_0^1 f(x)\cos n\pi xdx$，则 $S(-\frac{9}{2})$ =（2）

周期为 $2$ 的偶延拓，$S(-\frac{9}{2})=S(-\frac{1}{2})=S(\frac{1}{2})$，故 $=\frac{f(\frac{1}{2}-0)+f(\frac{1}{2}+0)}{2}=2$。

> 设函数 $f(x)=\frac{x}{4}$，$x\in (0,\pi)$ 的正弦级数 $\sum\limits_{n=1}^{\infty} b_n\sin (n\pi)$，则 $b_{1012}=$（$\frac{-1}{2024}$）

周期为 $\pi$ 的奇延拓，
$$
\begin{aligned}
b_n&=\frac{2}{\pi}\int_0^{\pi} f(x)\sin nx\mathrm{d}x\\
&=\frac{1}{2\pi}\int_0^{\pi} x\sin nx\mathrm{d}x\\ 
&=\frac{(-1)^{n+1}}{2n}
\end{aligned}
$$
因此 $b_{1012}=\frac{-1}{2024}$。



### 多选



> #### 级数
>
> 下述说法正确的有（AC）

- A. 若级数 $\sum a_n$ 与 $\sum b_n$ 收敛，且 $a_n\le u_n\le b_n$，那么 $\sum u_n$ 也收敛。

  柯西收敛准则：$\forall \varepsilon>0$，$\exists N$，$\forall n>N,p\ge 1$，有
  $$
  -\varepsilon \le a_{n+1}+\cdots+a_{n+p}\le u_{n+1}+\cdots+u_{n+p}\le b_{n+1}+\cdots+b_{n+p}\le \varepsilon
  $$
  因此收敛。

- B. 若级数 $\sum a_n$ 收敛，且 $|b_n|\le |a_n|$，那么 $\sum b_n$ 也收敛。

  搞个交错级数，$a_n=\frac{(-1)^n}{n}$，$b_n=\frac{1}{n}$，$\sum b_n$ 发散。

- C. 若正项级数 $\sum a_n$ 收敛，且 $\lim\limits_{n\to \infty} \frac{b_n}{a_n}=1$，那么 $\sum b_n$ 收敛。

  正项级数的比值判别法，只要 $\lim\limits_{n\to \infty}\frac{b_n}{a_n}=C$ 为常数，都收敛。

- D. 若 $\sum a_n$ 收敛，且 $\lim\limits_{n\to \infty} \frac{b_n}{a_n}=1$，那么 $\sum b_n$ 收敛。

  ☆ 不是正项级数，就会出问题。

  构造 $a_n=\frac{(-1)^n}{\sqrt{n}}$，$b_n=\frac{1}{n}+\frac{(-1)^n}{\sqrt{n}}$，$\sum b_n$ 发散。



- ☆ E. 级数 $\sum\limits_{n=1}^{+\infty} \frac{1}{1+n^2x^2}$ 在 $(0,1)$ 内一致收敛。

  由柯西准则，$\exists \varepsilon=\frac{1}{2}$，$\forall N$，$\exist n>N,p=n,x=\frac{1}{2n}$，使得：
  $$
  \sum\limits_{k=n+1}^{n+p} \frac{1}{1+k^2x^2}\ge \frac{p}{1+(n+p)^2x^2}=\frac{n}{2}\ge \varepsilon
  $$
  因此并非一致收敛。



> #### 级数
>
> 设 $\{a_n\}$ 是一正数数列，已知 $\sum a_n$ 收敛，则下列正确的有（BCD）

- A. $a_n=o(\frac{1}{n})$，$n\to \infty$。
- B. $\sum (1+\frac{1}{n})^na_n$ 收敛。
- C. $\sum\limits_{n=1}^{+\infty} \frac{a_n}{(\sum\limits_{k=1}^{n} a_k)^2}$ 收敛。
- D. $\sum\limits_{i=1}^{+\infty} (a_n)^3$ 收敛。

BCD 显然正确，A 显然错误。





> #### 函数列级数
>
> 下列陈述错误的有（ABCD）

- A. 若 $\sum u_n(x)$ 在 $[0,1]$ 上一致收敛，则 $\sum u_n(x)$ 在 $[0,1]$ 上绝对收敛。

  搞个条件收敛的经典例子 $\ln 2=1-\frac{1}{2}+\cdots$，即 $u_n(x)=\frac{(-1)^{n-1}}{n}$，并非绝对收敛。

- B. 若 $\sum u_n(x)$ 在 $[0,1]$ 上绝对收敛，则 $\sum u_n(x)$ 在 $[0,1]$ 上一致收敛。

  构造一：$u_n(x)=\begin{cases}x^n & 0\le x<1 \\ 0 & x=1\end{cases}$，$S(x)-S_n(x)=\frac{x^{n+1}}{1-x}$，
  $$
  \lim\limits_{n\to \infty} \sup\limits_{x\in [0,1]} \{\frac{x^{n+1}}{1-x}\}=+\infty
  $$
  取 $x=1-\frac{1}{n}$。

  构造二：$u_n(x)=x^n-x^{n+1}$，$S(x)-S_n(x)=\begin{cases}x^{n+1} & 0\le x<1\\0 & x=1\end{cases}$，
  $$
  \lim\limits_{n\to \infty} \sup_{x\in [0,1)}\{x^{n+1}\}=1
  $$
  因此并非一致收敛。

- C. 若函数列 $\{f_n(x)\}$，$\{g_n(x)\}$ 在 $R$ 上一致收敛，则 $\{f_n(x)g_n(x)\}$ 在 $R$ 上也一致收敛。

  构造 $f_n(x)=g_n(x)=x+\frac{1}{n}$，则 $f(x)=g(x)=x$，显然两者都一致收敛。

  而 $f_n(x)g_n(x)=x^2+\frac{2x}{n}+\frac{1}{n^2}$，$f(x)g(x)=x^2$，并非一致收敛。

- D. 设 $a_n>0$，若级数 $\sum \sqrt{a_na_{n+1}}$ 收敛，则级数 $\sum a_n$ 收敛。

  奇偶分别 $\frac{1}{n^5},n$ 即可，$\sum a_n$ 发散。



Notes. 绝对收敛和一致收敛没有直接联系（两者不能互推）

- ☆ 构造多考虑正负交替、奇偶交替。



> 下列函数列或函数项级数一致收敛的是（AB）

- A. $\sum ne^{-nx}$，$x\in [1,2024]$。

  优级数判别法，记 $u_n(x)=ne^{-nx}$，$|u_n(x)|\le \frac{n}{e^{n}}$，$\sum \frac{n}{e^n}$ 收敛。

  因此一致收敛。

  **但注意，在 $x\in (0,+\infty)$ 非一致收敛；只要 $x\in [L,R]$，满足 $L>0$，就是一致收敛。**

- B. $\sum (-1)^n(1-x)x^n$，$x\in [0,1]$

  取 $u_n(x)=(1-x)x^n$，$v_n(x)=(-1)^n$。

  显然 $\{u_n(x)\}$ 单调递减，一致趋于 $0$（$u'_n(x)=nx^{n-1}(1-x)-x^n=0\Rightarrow x_0=\frac{n}{n+1}$）

  而 $\sum v_n(x)$ 部分和一致有界。

  由狄利克雷判别法知一致收敛。

- C. $\sum 2^n \sin\frac{1}{3^nx}$，$x\in (0,+\infty)$。

  柯西收敛准则，取 $x=\frac{1}{3^n}$ 即可。非一致收敛。

- D. $\{\frac{1-n^2x^2}{(1+n^2x^2)^2}\}$，$x\in R$。

  $x=0$  趋于 $1$，其余均趋于 $0$。

  $\lim\limits_{n\to \infty} \sup\limits_{x\in R}\{...\}\ge 1$（代入 $x=\frac{1}{n^2}$），非一致收敛。

- E. $\sum (1-x)x^n$，$x\in [0,1]$

  废话，非一致收敛。

- F. $\sum xe^{-nx^2}$，$x\in [0,1]$

  非一致收敛。

- G. $\sum \frac{x^2}{(1+x^2)^n}$，$x\in [0,1]$

  非一致收敛。



Notes. 闭区间上可以大胆猜就是一致收敛了。牵扯到有关 $0$ 的开区间，要小心点，一般非一致收敛就卡在这个犄角旮旯的地方。



> #### 幂级数
>
> 已知 $\forall x\in (-1,1)$，有 $\frac{1}{1+x+x^2}=\sum\limits_{n=0}^{+\infty} a_nx^n$，则（ABCD）
>
> A. $a_4=-1$
>
> B. $a_2=0$
>
> C. $a_{2022}=1$
>
> D. $a_6=1$

$=\frac{1-x}{1-x^3}=\sum\limits_{n=0}^{+\infty}x^{3n}-\sum\limits_{n=0}^{+\infty}x^{3n+1}$。

![image-20250327070914945](C:\Users\Alan233\AppData\Roaming\Typora\typora-user-images\image-20250327070914945.png)

