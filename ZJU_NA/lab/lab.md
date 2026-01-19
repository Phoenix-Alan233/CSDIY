数值分析 Numerical Analysis

## P1. Numerical Summation of a Series 

### 题意

令 $\phi(x)=\sum_{k=1}^{\infty} \frac{1}{k(k+x)}$，分别计算当 $x=0.0,0.1,0.2,\cdots,300.0$ 时的值，要求绝对误差在 $1e-10$ 内。

### 分析

已知 $\phi(x)=\sum_{k=1}^{\infty} \frac{1}{k(k+x)}$，显然 $\phi(1)=1$，那么：
$$
\phi(x)-\phi(1)=(1-x)\sum_{k=1}^{\infty} \frac{1}{k(k+1)(k+x)}
$$
这样做的意义在于：分母由原来的两项乘积，转变为了三项乘积，收敛变得更快。

迭代一层，记 $\psi(x)=\sum\limits_{k=1}^{\infty} \frac{1}{k(k+1)(k+x)}$，显然 $\psi(2)=\frac{1}{4}$，得到：
$$
\psi(x)-\psi(2)=(2-x)\sum_{k=1}^{\infty} \frac{1}{k(k+1)(k+2)(k+x)}
$$
这样显然收敛会更快。假设 $k$ 截断于 $B$，那么截断项的误差为：
$$
\text{err}=\sum_{k=B+1}^{\infty} \frac{(1-x)(2-x)}{k(k+1)(k+2)(k+x)}<\int_B^{\infty} \frac{(1-x)(2-x)}{x^4} dx=\frac{(1-x)(2-x)}{3B^3}
$$

### 尝试 1

上面收敛还是太慢，对于 $x=0.0,0.1,0.2,\cdots,300.0$ 均计算会超时。于是我尝试多迭代几层，尝试过 $2,3,4$ 层，由于越往后除的数太大（分母是很多大数的连乘），反而会受到「浮点数末尾截断」带来的精度误差，反而副作用。我还尝试过将 $x=200\sim 300$ 的部分本地打表，其余正常跑，但是时间限制和代码长度限制始终不能同时卡进，寄。

### 尝试 2

后来我注意到：
$$
\phi(x)=\frac{1}{x} \sum_{k=1}^{\infty} \left(\frac{1}{k}-\frac{1}{k+x}\right) \\

\phi(x+1)=\frac{1}{x+1} \sum_{k=1}^{\infty} \left(\frac{1}{k}-\frac{1}{k+x+1}\right)
$$
显然两者存在递推式 $x\phi(x)=(x+1)\phi(x+1)-\frac{1}{x+1}$，如果我们计算出了 $\phi(x)$，记它的绝对误差为 $\text{err}(x)$，那么 $\text{err}(x+1)=\frac{x}{x+1}\text{err}(x)$，误差反而越来越小。

因此我们只需要计算 $x=0.0,0.1,0.2,\cdots,0.9$ 即可，剩余直接递推，绝对误差始终控制在 $1e-10$ 内。

```c
void Series_Sum(double sum[]) {
    const double eps = 1e-11;
    for (int _ = 0; _ <= 3000; _++) {
        double x = _ / 10.;
        if (_ < 10) {
            double res = 0;
            for (int k = 1; ; k++) {
                res += 1. / k / (k + 1) / (k + 2) / (k + x);
                double err = (1 - x) * (2 - x) / 3 / k / k / k;
                if (err < eps) break;
            }
            res *= 2 - x;
            res += 1. / 4;
            res *= 1 - x;
            res += 1;
            sum[_] = res;
        } else {
            sum[_] = (x - 1) * sum[_ - 10] / x + 1. / x / x;
        }
    }
}
```

### 道听途说

据说直接 $k$ 截断于 $B$，之后就当 $x=0$ 去计算（近似相等），也可以通过本题。



## P2. Root of a Polynomial

### 题意

给定一个 $n$ 次多项式 $P(x)=c_nx^n+c_{n-1}x^{n-1}+\cdots+c_1x+c_0$，已知它在区间 $(a,b)$ 中有唯一零点，你需要找到它，误差在 EPS 内。

### 尝试 1（38 / 50）

将区间 $(a,b)$ 切成 $\text{cut}$ 份，对每一个小段应用零点存在定理，可以通过 0, 1, 2, 4, 5 五个测试点。

```c
double f(int n, double c[], double x) {
    double res = 0;
    for (int i = n; i >= 0; i--) {
        res = res * x + c[i];
    }
    return res;
}

double Polynomial_Root(int n, double c[], double a, double b, double EPS) {
    const double eps = 1e-15;
    double candidate[155555];
    int len;
    len = 0;
    long long cut = 10000000;

    if (a < 0 && 0 < b) {
        candidate[len++] = 0;
    }

    for (int i = 0; i < cut; i++) {
        double l = a + (b - a) / cut * i;
        double r = a + (b - a) / cut * (i + 1);
        if (fabs(f(n, c, l)) < 1e-12) {
            candidate[len++] = l;
        }
        if (fabs(f(n, c, r)) < 1e-12) {
            candidate[len++] = r;
        }
        if (f(n, c, l) * f(n, c, r) < 0) {
            while (fabs(r - l) > 1e-15) {
                double mid = l + (r - l) / 2;
                if (f(n, c, l) * f(n, c, mid) < 0) r = mid;
                else l = mid;
            }
            return (l + r) / 2;
        }
    }
    double minerr = 1e10, x0 = -1;
    for (int i = 0; i < len; i++) {
        double x = candidate[i];
        double ff = f(n, c, x);
        if (abs(ff) < minerr)
            minerr = abs(ff), x0 = x;
    }
    return x0;
}
```

### 尝试 2（29 / 50）

使用牛顿迭代法，找若干个初始值，然后应用 $x\leftarrow x-\frac{f(x)}{f'(x)}$，直到 $x$ 收敛。

```c
double f(int n, double c[], double x) {
    double res = 0;
    for (int i = n; i >= 0; i--) {
        res = res * x + c[i];
    }
    return res;
}
double f1(int n, double c[], double x) {
    double res = 0;
    for (int i = n; i >= 1; i--) {
        res = res * x + i * c[i];
    }
    return res;
}

double Polynomial_Root(int n, double c[], double a, double b, double EPS) {
    if (a > b) {
        double tmp = a;
        a = b;
        b = tmp;
    }

    const int cut = 5;
    for (int _ = 0; _ < cut; _++) {
        double x0 = a + (b - a) / cut * _;
        for (int iter = 0; iter <= 10000; iter++) {
            double x = x0 - f(n, c, x0) / f1(n, c, x0);
            if (x < a || x > b) break;
            if (fabs(x - x0) < EPS) return x;
            x0 = x;
        }
    }
    return 0;
}
```

### 尝试 3（50 / 50）

参考网上题解。构造 $g(x)=\frac{f(x)}{f'(x)}$，它跟 $f(x)$ 保持同根（且可以处理重根问题），因此对它进行牛顿迭代即可。

```c
double f(int n, double c[], double x) {
    double res = 0;
    for (int i = n; i >= 0; i--) {
        res = res * x + c[i];
    }
    return res;
}
double f1(int n, double c[], double x) {
    double res = 0;
    for (int i = n; i >= 1; i--) {
        res = res * x + c[i] * i;
    }
    return res;
}
double f2(int n, double c[], double x) {
    double res = 0;
    for (int i = n; i >= 2; i--) {
        res = res * x + c[i] * i * (i - 1);
    }
    return res;
}

double Polynomial_Root(int n, double c[], double a, double b, double EPS) {
    if (a > b) {
        double tmp = a;
        a = b;
        b = tmp;
    }

    const int cut = 200;
    for (int _ = 0; _ < cut; _++) {
        double x0 = a + (b - a) / cut * _;
        for (int iter = 0; iter <= 1000; iter++) {
            double x = x0 - f(n, c, x0) * f1(n, c, x0) / (f1(n, c, x0) * f1(n, c, x0) - f(n, c, x0) * f2(n, c, x0));
            if (fabs(x - x0) < EPS && a < x && x < b) return x;
            x0 = x;
        }
        if (_ == cut - 1) {
            return x0;
        }
    }
}
```



## P3. There is No Free Lunch

### 题意

有一个长为 $n$ 的序列 $d_0,d_1,\cdots,d_{n-1}$，记 $p_i=2d_i+\frac{1}{2}(d_{i-1}+d_{i+1})$。现已知序列 $p$，还原 $d$。

$2<n\le 10000$。

### 尝试 1（30 / 40）

典型的 ACMer 思维。很明显可以手动消元，设 $p_0,p_1$ 为 $x,y$，其余数均可以表示为 $p_i=a_ix+b_iy+c_i$ 的形式，最后联立方程组解出 $x,y$，但这样的一个问题是 $a_i,b_i,c_i$ 是指数级增长，精度不可控。

```c
void Price(int n, double P[]) {
    double a[Max_size], b[Max_size], c[Max_size];
    // P[0]: x, P[1]: y
    a[0] = 1, b[0] = 0, c[0] = 0;
    a[1] = 0, b[1] = 1, c[1] = 0;
    for (int i = 1; i + 1 < n; i++) {
        a[i + 1] = -a[i - 1] - 4 * a[i];
        b[i + 1] = -b[i - 1] - 4 * b[i];
        c[i + 1] = 2 * P[i] - c[i - 1] - 4 * c[i];
    }
    // (n-2, n-1, 0)
    double A = 0.5 * a[n - 2] + 2 * a[n - 1] + 0.5 * a[0];
    double B = 0.5 * b[n - 2] + 2 * b[n - 1] + 0.5 * b[0];
    double C = 0.5 * c[n - 2] + 2 * c[n - 1] + 0.5 * c[0] - P[n - 1];
    // (n-1, 0, 1)
    double D = 0.5 * a[n - 1] + 2 * a[0] + 0.5 * a[1];
    double E = 0.5 * b[n - 1] + 2 * b[0] + 0.5 * b[1];
    double F = 0.5 * c[n - 1] + 2 * c[0] + 0.5 * c[1] - P[0];
    C = -C, F = -F;
    double x = (C * E - B * F) / (A * E - B * D);
    double y = (C * D - A * F) / (B * D - A * E);
    P[0] = x, P[1] = y;
    for (int i = 2; i < n; i++) {
        P[i] = a[i] * x + b[i] * y + c[i];
    }
}
```

### 尝试 2（40 / 40）

参考网上题解。如果我们将它表示为线性代数的形式，就是：
$$
\begin{bmatrix} 2 & 0.5 & 0 & \cdots &0 & 0 & 0.5 \\ 0.5 & 2 & 0.5 & \cdots & 0 & 0 &0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ \cdots & \cdots & 0.5 & 2 & 0.5 & \cdots & \cdots  \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 &0 & 0 & \cdots & 0.5 & 2 & 0.5 \\ 0.5  & 0 &0 & \cdots & 0 & 0.5 & 2 \end{bmatrix} \cdot \begin{bmatrix}x_1 \\ x_2 \\ x_3 \\ \cdots \\ \cdots \\ \cdots \\ x_n\end{bmatrix}=\begin{bmatrix}p_1 \\ p_2 \\ p_3 \\ \cdots \\ \cdots \\ \cdots \\ p_n\end{bmatrix}
$$
它的系数密集分布在主对角线和它上下两条对角线，我们稍加处理，将它彻底变成这种形式，就能 $O(n)$ 处理。

设原矩阵为 $\bold A$，左上方 $n-1$ 阶矩阵为 $\bold B$，右边一条为 $\bold c=\begin{bmatrix}0.5 & 0 & \cdots & 0 & 0.5\end{bmatrix}^T$，则：
$$
\begin{bmatrix} \bold B & \bold c \\ \bold c^T & 2\end{bmatrix} \cdot \begin{bmatrix} \bold X \\ x_n\end{bmatrix}=\begin{bmatrix}\bold P \\ p_n\end{bmatrix}
$$
这样做的目的是：沿用“线性表示”的思想，设 $x_i=u_i x_n+v_i$，那么 $\bold X=\bold U x_n+\bold V$，于是有：
$$
\bold B (\bold Ux_n+\bold V)+\bold c x_n=\bold P
$$
不妨取 $\bold B\bold U+\bold c=\bold 0$，$\bold B\bold V=\bold P$（注意，这里确实可以任取，原因是 $u_i,v_i$ 能随意调控组合），这里的 $\bold B$ 就是标准的三对角矩阵，用 Crout 分解即可。它的大概思想是：

- 将形如“$\bold A\bold x=b$”的线性方程组，拆解 $\bold A=\bold L\bold U$，先计算 $\bold L\bold y=\bold b$，再计算 $\bold U\bold x=\bold y$。
- 特别地，对于 Crout 分解，$U_{i,i}=1$。
- 若 $\bold A$ 是三对角矩阵，它的拆解很特殊，$\bold L$ 只在 $l_{i,i-1},l_{i,i}$ 有值，$\bold U$ 只在 $u_{i,i},u_{i,i+1}$ 有值。 

而这样的分解操作，计算过程的值域可控，非常牛。

```c
// Bx = c, B is fixed
void Crout(int n, double c[], double x[]) {
    double L[Max_size][2]; // L[i][i], L[i][i - 1]
    double U[Max_size];    // U[i][i + 1]
    double y[Max_size];    // y[i]
    // B = LU, Ly = c
    L[0][0] = 2, U[0] = 0.5 / 2, y[0] = c[0] / 2;
    for (int i = 1; i < n; i++) {
        L[i][1] = 0.5;
        L[i][0] = 2 - 0.5 * U[i - 1];
        if (i + 1 < n) U[i] = 0.5 / L[i][0];
        y[i] = (c[i] - L[i][1] * y[i - 1]) / L[i][0];
    }
    // Ux = y
    x[n - 1] = y[n - 1];
    for (int i = n - 2; i >= 0; i--) {
        x[i] = y[i] - U[i] * x[i + 1];
    }
}

void Price(int n, double P[]) {
    double c1[Max_size], c2[Max_size], U[Max_size], V[Max_size];
    for (int i = 0; i < n - 1; i++) {
        if (i == 0 || i == n - 2) c1[i] = -0.5;
        else c1[i] = 0;
        c2[i] = P[i];
    }
    Crout(n - 1, c1, U), Crout(n - 1, c2, V);
    
    double x[Max_size];
    x[n - 1] = (2 * P[n - 1] - V[n - 2] - V[0]) / (4 + U[n - 2] + U[0]);
    for (int i = 0; i < n - 1; i++) {
        x[i] = U[i] * x[n - 1] + V[i];
    }

    for (int i = 0; i < n; i++) P[i] = x[i];
}
```



## P4. Compare Methods of Jacobi with Gauss-Seidel

### 题意



### 分析

我觉得比较奇怪的一点是，`trans` 过程中，为啥底下找不到 $|a_{j,i}|>0$ 的，反而还需要往上找？往上找的意义何在？这样不是明摆着应该有无数多解 / 无解吗？

```c
void swap(double *a, double *b) {
    double tmp = *a;
    *a = *b, *b = tmp;
}
double max(double a, double b) {
    return a > b ? a : b;
}

int trans(int n, double a[][MAX_SIZE], double b[]) {
    const double eps = 1e-9;
    static int ret = -1;
    if (~ret) return ret;
    ret = 1;
    for (int i = 0; i < n; i++) {
        double maxx = -1;
        int who = -1;
        for (int j = i; j < n; j++) {
            if (fabs(a[j][i]) > maxx)
                maxx = fabs(a[j][i]), who = j;
        }
        if (maxx < eps) {
            maxx = -1;
            for (int j = i - 1; j >= 0; j--) {
                if (fabs(a[j][i]) > maxx)
                    maxx = fabs(a[j][i]), who = j;
            }
            if (maxx < eps) {
                ret = 0;
                break;
            } else {
                for (int j = 0; j < n; j++)
                    a[i][j] += a[who][j];
                b[i] += b[who];
            }
        } else {
            if (who == i) continue;
            for (int j = 0; j < n; j++)
                swap(&a[i][j], &a[who][j]);
            swap(&b[i], &b[who]);
        }
    }
    return ret;
}

int Jacobi(int n, double a[][MAX_SIZE], double b[], double x[], double TOL, int MAXN) {
    int k = 1;
    if (trans(n, a, b) == 0) return -1;
    while (k <= MAXN) {
        double newx[MAX_SIZE];
        for (int i = 0; i < n; i++) {
            double sum = 0;
            for (int j = 0; j < n; j++)
                if (j != i)
                    sum += a[i][j] * x[j];
            newx[i] = (b[i] - sum) / a[i][i]; 
        }

        double err = 0;
        for (int i = 0; i < n; i++) {
            err = max(err, fabs(x[i] - newx[i]));
            if (fabs(newx[i]) >= bound) return -2;
            x[i] = newx[i];
        }
        if (err < TOL) return k;
        k++;
    }
    return 0;
}

int Gauss_Seidel(int n, double a[][MAX_SIZE], double b[], double x[], double TOL, int MAXN) {
    int k = 1;
    if (trans(n, a, b) == 0) return -1;
    while (k <= MAXN) {
        double newx[MAX_SIZE];
        for (int i = 0; i < n; i++) {
            double sum = 0;
            for (int j = 0; j < n; j++) {
                if (j < i) sum += a[i][j] * newx[j];
                if (j > i) sum += a[i][j] * x[j];
            }
            newx[i] = (b[i] - sum) / a[i][i]; 
        }

        double err = 0;
        for (int i = 0; i < n; i++) {
            err = max(err, fabs(x[i] - newx[i]));
            if (fabs(newx[i]) >= bound) return -2;
            x[i] = newx[i];
        }
        if (err < TOL) return k;
        k++;
    }
    return 0;
}
```



## P5. Approximating Eigenvalues

### 题意

给定一个 $n\times n$ 的矩阵 $\bold A$，以及一个近似的特征根 $\lambda$ 及其特征向量 $\bold x$，设定精度误差 TOL 以及最大迭代次数 MAXN，计算 $\lambda$ 和 $\bold x$ 更加精确的值（误差在 TOL 内）。

### 分析

按照算法模拟即可。比较奇怪的一点是，网上的做法说计算 $(\bold A-\lambda \bold I)\bold y=\bold x$ 不能高斯消元，一定要用 LU 分解，但事实上我写了高斯消元过了啊（？

```c
#include <math.h>

void swap(double *a, double *b) {
    double tmp = *a;
    *a = *b, *b = tmp;
}

double max(double a, double b) {
    return a > b ? a : b;
}

double *max_element(double *start, double *end) {
    double maxx = -1;
    double *who;
    for (double *it = start; it != end; it++) {
        if (fabs(*it) > maxx)
            maxx = fabs(*it), who = it;
    }
    return who;
}

// success: 0; failed: -1
int Gauss(int n, double a[][MAX_SIZE + 1], double b[]) {
    const double eps = 1e-6;
    for (int i = 0; i < n; i++) {
        double maxx = -1;
        int who = -1;
        for (int j = i; j < n; j++) {
            if (fabs(a[j][i]) > maxx)
                maxx = fabs(a[j][i]), who = j;
        }
        if (maxx < eps) return -1;
        if (who != i) {
            for (int j = 0; j <= n; j++)
                swap(&a[i][j], &a[who][j]);
        }
        for (int j = 0; j < n; j++) {
            if (j == i || fabs(a[j][i]) < eps) continue;
            double div = a[j][i] / a[i][i];
            for (int k = i; k <= n; k++)
                a[j][k] -= a[i][k] * div;
        }
    }
    for (int i = 0; i < n; i++)
        b[i] = a[i][n] / a[i][i];
    return 0;
}

int EigenV(int n, double a[][MAX_SIZE], double *lambda, double x[], double TOL, int MAXN) {
    // step 2
    int k = 1;
    // step 3
    int p = max_element(x, x + n) - x;
    // step 4
    double xp = x[p];
    for (int i = 0; i < n; i++) x[i] /= xp;
    // step 5
    while (k <= MAXN) {
        // step 6
        double A[MAX_SIZE][MAX_SIZE + 1];
        double y[MAX_SIZE];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (i == j) A[i][j] = a[i][j] - *lambda;
                else A[i][j] = a[i][j];
            }
            A[i][n] = x[i];
        }
        // step 7
        if (Gauss(n, A, y) == -1)
            return -1;
        // step 8
        double mu = y[p];
        // step 9
        p = max_element(y, y + n) - y;
        double yp = y[p];
        // step 10
        double err = 0;
        for (int i = 0; i < n; i++) {
            err = max(err, fabs(x[i] - y[i] / yp));
            x[i] = y[i] / yp;
        }
        // step 11
        if (err < TOL) {
            *lambda = 1 / mu + *lambda;
            return 1;
        }
        // step 12
        k++;
    }
    // step 13
    return 0;
}
```



## P6. Cubic Spline

### 题意



### 分析

```c
void Cubic_Spline(int n, double x[], double f[], int Type, double s0, double sn, 
                  double a[], double b[], double c[], double d[]) {
    if (Type == 1) { // Clamped Cubic Spline
        for (int i = 0; i <= n; i++) a[i] = f[i]; 
        double h[MAX_N], alpha[MAX_N];
        for (int i = 0; i < n; i++) h[i] = x[i + 1] - x[i];
        alpha[0] = 3 * (a[1] - a[0]) / h[0] - 3 * s0;
        alpha[n] = 3 * sn - 3 * (a[n] - a[n - 1]) / h[n - 1];
        for (int i = 1; i < n; i++) {
            alpha[i] = 3 / h[i] * (a[i + 1] - a[i]) -
                       3 / h[i - 1] * (a[i] - a[i - 1]);
        }
        
        double l[MAX_N], mu[MAX_N], z[MAX_N];
        l[0] = 2 * h[0];
        mu[0] = 0.5;
        z[0] = alpha[0] / l[0];
        for (int i = 1; i < n; i++) {
            l[i] = 2 * (x[i + 1] - x[i - 1]) - h[i - 1] * mu[i - 1];
            mu[i] = h[i] / l[i];
            z[i] = (alpha[i] - h[i - 1] * z[i - 1]) / l[i];
        }
        l[n] = h[n - 1] * (2 - mu[n - 1]);
        z[n] = (alpha[n] - h[n - 1] * z[n - 1]) / l[n];
        c[n] = z[n];
        for (int j = n - 1; j >= 0; j--) {
            c[j] = z[j] - mu[j] * c[j + 1];
            b[j] = (a[j + 1] - a[j]) / h[j] -
                    h[j] * (c[j + 1] + 2 * c[j]) / 3;
            d[j] = (c[j + 1] - c[j]) / 3 / h[j];
        }
    } else { // Natural Cubic Spline
        for (int i = 0; i <= n; i++) a[i] = f[i];
        double h[MAX_N], alpha[MAX_N];
        for (int i = 0; i < n; i++) h[i] = x[i + 1] - x[i];
        for (int i = 1; i < n; i++) {
            alpha[i] = 3 / h[i] * (a[i + 1] - a[i]) -
                       3 / h[i - 1] * (a[i] - a[i - 1]);
        }
        double l[MAX_N], mu[MAX_N], z[MAX_N];
        l[0] = 1;
        mu[0] = 0;
        z[0] = s0 / 2;
        for (int i = 1; i < n; i++) {
            l[i] = 2 * (x[i + 1] - x[i - 1]) - h[i - 1] * mu[i - 1];
            mu[i] = h[i] / l[i];
            z[i] = (alpha[i] - h[i - 1] * z[i - 1]) / l[i];
        }
        l[n] = 1;
        z[n] = sn / 2;
        c[n] = sn / 2;
        for (int j = n - 1; j >= 0; j--) {
            c[j] = z[j] - mu[j] * c[j + 1];
            b[j] = (a[j + 1] - a[j]) / h[j] -
                   h[j] * (c[j + 1] + 2 * c[j]) / 3;
            d[j] = (c[j + 1] - c[j]) / 3 / h[j];
        }
    }

    for (int i = n; i >= 1; i--) {
        a[i] = a[i - 1];
        b[i] = b[i - 1];
        c[i] = c[i - 1];
        d[i] = d[i - 1];
    }
}

double S(double t, double Fmax, int n, double x[], 
         double a[], double b[], double c[], double d[]) {
    if (t < x[0] || t > x[n]) return Fmax;
    int pos = 0;
    while (pos + 1 < n && x[pos + 1] < t) ++pos;
    double dx = t - x[pos];
    ++pos;
    return ((d[pos] * dx + c[pos]) * dx + b[pos]) * dx + a[pos];
}
```



## P7. Orthogonal Polynomials Approximation

### 题意



### 分析

对应 NA 教材的 P498 Orthogonal Polynomials and Least Squares Approximation。

```c
// 多项式
typedef struct poly {
    double c[MAX_n + 1];
} poly;

void clear(poly *f) {
    for (int i = 0; i <= MAX_n; i++) f->c[i] = 0;
}
void mov(poly *f, poly g) {
    for (int i = 0; i <= MAX_n; i++) f->c[i] = g.c[i];
}
poly shl(poly f) {
    poly g;
    g.c[0] = 0;
    for (int i = MAX_n; i >= 1; i--) g.c[i] = f.c[i - 1];
    return g;
}

// 多项式的点值
typedef struct vector {
    double c[MAX_m];
} vector;

// 计算多项式 f 在 x 处的点值
vector eval(poly f, int m, double x[]) {
    vector a;
    for (int i = 0; i < m; i++) {
        double res = 0;
        for (int j = MAX_n; j >= 0; j--)
            res = res * x[i] + f.c[j];
        a.c[i] = res;
    }
    return a;
}

// 计算加权内积
double dot(int m, double w[], vector v1, vector v2) {
    double res = 0;
    for (int i = 0; i < m; i++)
        res += w[i] * v1.c[i] * v2.c[i];
    return res;
}

int OPA(double (*f)(double t), int m, double x[], double w[], double c[], double *eps) {
    vector y;
    for (int i = 0; i < m; i++) y.c[i] = f(x[i]);

    // step 1
    poly phi0, phi1; clear(&phi0), clear(&phi1);
    phi0.c[0] = 1;
    double a0 = dot(m, w, eval(phi0, m, x), y) / dot(m, w, eval(phi0, m, x), eval(phi0, m, x));
    poly P;
    for (int i = 0; i <= MAX_n; i++) P.c[i] = a0 * phi0.c[i];
    double err = dot(m, w, y, y) - a0 * dot(m, w, eval(phi0, m, x), y);
    // step 2
    double B1 = dot(m, w, eval(shl(phi0), m, x), eval(phi0, m, x)) / dot(m, w, eval(phi0, m, x), eval(phi0, m, x));
    phi1.c[0] = -B1, phi1.c[1] = 1;
    double a1 = dot(m, w, eval(phi1, m, x), y) / dot(m, w, eval(phi1, m, x), eval(phi1, m, x));
    for (int i = 0; i <= MAX_n; i++) P.c[i] += a1 * phi1.c[i];
    err -= a1 * dot(m, w, eval(phi1, m, x), y);
    // step 3
    int k = 1;
    // step 4
    while (k < MAX_n && fabs(err) >= *eps) {
        // step 5
        k++;
        // step 6
        double Bk = dot(m, w, eval(shl(phi1), m, x), eval(phi1, m, x)) / dot(m, w, eval(phi1, m, x), eval(phi1, m, x));
        double Ck = dot(m, w, eval(shl(phi1), m, x), eval(phi0, m, x)) / dot(m, w, eval(phi0, m, x), eval(phi0, m, x));
        poly phi2; clear(&phi2);
        for (int i = 0; i <= MAX_n; i++) {
            if (i + 1 <= MAX_n) phi2.c[i + 1] += phi1.c[i];
            phi2.c[i] -= Bk * phi1.c[i];
            phi2.c[i] -= Ck * phi0.c[i];
        }
        double Ak = dot(m, w, eval(phi2, m, x), y) / dot(m, w, eval(phi2, m, x), eval(phi2, m, x));
        for (int i = 0; i <= MAX_n; i++) P.c[i] += Ak * phi2.c[i];
        err -= Ak * dot(m, w, eval(phi2, m, x), y);
        // step 7
        mov(&phi0, phi1), mov(&phi1, phi2);
    }
    // step 8
    *eps = err;
    for (int i = 0; i <= MAX_n; i++) c[i] = P.c[i];
    return k;
}
```



## P8. Shape Roof

### 题意

将一张平整的纸张折成 $y(x)=l\sin(tx)$ 的波浪形，现在已知 $l,t$，求波浪形从 $a$ 到 $b$ 拉平以后的长度，要求绝对误差在 $\text{eps}$ 内。

### 分析

由第一类曲线积分：
$$
\int_s dl = \int_a^b \sqrt{1+l^2t^2\cos^2(tx)} dx
$$
令其为 $f(x)$，我们要求的就是 $f(x)$ 在区间 $[a,b]$ 上的定积分。用 Simpson 即可。

但我不理解的一个点是，为啥自适应 Simpson 过不去（（（

```c
double Simpson(double a, double b, double (*f)(double x, double l, double t), 
               double l, double t) {
    double mid = a + (b - a) / 2;
    return (f(a, l, t) + 4 * f(mid, l, t) + f(b, l, t)) * (b - a) / 600;
}

double Integral(double a, double b, double (*f)(double x, double l, double t),
                double eps, double l, double t) {
    if (eps > 1e-9) eps = 1e-9;
    double S = Simpson(a, b, f, l, t);
    double mid = a + (b - a) / 2;
    double S1 = Simpson(a, mid, f, l, t), S2 = Simpson(mid, b, f, l, t);
    if (fabs(S1 + S2 - S) <= eps) return S;
    else return Integral(a, mid, f, eps, l, t) + Integral(mid, b, f, eps, l, t);
}
```

