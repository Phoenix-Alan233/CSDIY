## MIT missing-semester: The Missing Semester of Your CS Education 

![](assets/overview.png)

- Course Website: 
  - en: https://missing.csail.mit.edu/2020/
  - zh: https://missing-semester-cn.github.io/
- Course Video: https://www.bilibili.com/video/BV1uc411N7eK
- Course Content:
    - Lec 1. 课程概览与 shell
    - Lec 2. Shell 工具和脚本
    - Lec 3. 编辑器 (vim)
    - Lec 4. 数据整理
    - Lec 5. 命令行环境
    - Lec 6. 版本控制 (git)
    - Lec 7. 调试及性能分析
    - Lec 8. 元编程
    - Lec 9. 安全和密码学
    - Lec 10. 大杂烩
    - Lec 11. Q&A
- Instructors: Anish, Jon, Jose
- Semester: Jan 2020

## Lec 1. 课程概览与 shell

打开终端时, 会看到这样一个提示符, 这是 shell 最主要的文本接口, 它表示当前用户名为 `alan233`, 主机名为 `Alan`, 所在目录为 `~`. 这里的 `$` 表示非 root 用户, 若是 `#` 则表示 root.

```sh
alan233@Alan:~$
```

shell 是一款脚本语言 (最常用的是 bash), 也具备变量、条件、循环和函数功能. 当你要求 shell 执行某个指令, 但并不是它了解的关键字时, 它就会去咨询**环境变量 `$PATH`**, 里面涵盖所有的搜索路径. 例如当执行 `echo` 命令时, shell 会去 `$PATH` 中搜索由 `:` 所分割的一系列目录, 基于名字搜索该程序, 找到便执行.

```bash
alan233@Alan:~$ echo $PATH
/home/alan233/.cargo/bin:/home/alan233/miniconda3/condabin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
alan233@Alan:~$ which echo
/usr/bin/echo
```

使用 `ls -l` 会出现如下内容: 第一个字符 `d` 表示目录, 接下来每三个字符构成一组, 分别代表文件所有者 `alan233`、用户组 `users` 以及其他所有人 `others` 的权限. 其中 `-` 表示该用户不具备相应的权限, `r` 代表读取 (查看), `w` 代表写入 (修改), `x` 代表执行 (访问).

```bash
alan233@Alan:~$ ls -l
total 48
drwxr-xr-x 11 alan233 alan233 4096 Nov 15 11:41 CSDIY
...
```

在 shell 中, 程序有输入流和输出流, 分别用 `<` 和 `>` 表示. 特别地, `>` 表示写入 (stdout, 覆盖), `2>` 表示写入 (stderr), `>>` 表示末尾追加.

```bash
alan233@Alan:~$ echo hello > hello.txt
alan233@Alan:~$ cat hello.txt
hello
alan233@Alan:~$ echo alan233 > hello.txt
alan233@Alan:~$ cat hello.txt
alan233
alan233@Alan:~$ echo 666 >> hello.txt
alan233@Alan:~$ cat hello.txt
alan233
666
```

使用管道 (pipes), 我们能够更好的利用文件重定向: `|` 操作符允许我们将一个程序的输出和另外一个程序的输入连接起来.

```bash
alan233@Alan:~$ ls -l | tail -n 1
drwxr-xr-x 14 alan233 alan233 4096 Nov  8 19:45 verilator
```

## Lec 2. Shell 工具和脚本

以下默认使用 bash. 它为变量赋值的语法是 `foo=bar`, 访问变量需要 `$foo`. 注意不能写成 `foo = bar`, 因为 shell 脚本中使用空格会起到分割参数的作用, 解释器会调用程序 `foo` 并将 `=`、`bar` 作为参数, 导致报错. 

Bash 中的字符串通过 `'` 和 `"` 分隔符定义, 但是含义不同: 以 `'` 定义的字符串为**原义字符串**, 其中的变量不会被转义, 而 `"` 定义的字符串会**将变量值进行替换**.

```bash
alan233@Alan:~$ foo=bar
alan233@Alan:~$ echo '$foo'
$foo
alan233@Alan:~$ echo "$foo"
bar
```

接下来我们设计一个函数 `mcd`, 用于创建文件夹并进入.

```bash
alan233@Alan:~$ touch mcd.sh
alan233@Alan:~$ vim mcd.sh
#!/bin/bash
mcd() {
    mkdir -p "$1"
    cd "$1"
}
alan233@Alan:~$ source mcd.sh
alan233@Alan:~$ mcd hello
alan233@Alan:~/hello$ 
```

这里的脚本参数跟 C 语言的 `argv` 很像, 具体含义如下:

| 变量名 | 含义 |
|:---:|:---:|
| `$#` | 参数个数, 类似 `argc` | 
| `$0` | 脚本名 |
| `$1` ~ `$9` | 脚本参数 |
| `$@` | 所有参数 |
| `$$` | 当前脚本的进程识别码 PID |
| `$?` | 上一条命令的返回值 (错误代码) |
| `$_` | 上一条命令的最后一个参数 |
| `!!` | 完整的上一条命令, 包括参数 |

`$?` 的错误代码顾名思义, 就是返回值 $0$ 表示正常执行, 其他所有非 $0$ 的返回值都表示有错误发生.

`!!` 常用于当你权限不足, 执行命令失败时, 就可以输入 `sudo !!` 再尝试一次.

接下来是**命令替换 (command substitution)**, `$(cmd)` 来执行 `cmd` 指令, 它的输出结果会替换掉 `$(cmd)`; 还有**进程替代 (process substitution)**, `<(cmd)` 会执行 `cmd` 并将结果输出到一个临时文件中, 常见于 `diff <(ls foo) <(ls bar)` 来对比文件夹 `foo` 和 `bar` 中文件的区别.

我们实现一个脚本, 它会遍历我们提供的参数, 搜索文本中是否存在 `foobar`, 如果没有找到, 将其作为注释追加到文件中.

```bash
#!/bin/bash
echo "Starting program at $(date)"
echo "Running program $0 with $# arguments with pid $$"
for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

这里的第一行是用了黑科技 shebang, 它声明了用什么程序去运行这一段文本. 例如该脚本指名道姓是使用 shell.

在执行脚本时, 我们经常需要提供形式类似的参数. Bash 可以基于文件名展开表达式, 被称为 shell 的**通配 (globbing)**.

- 通配符: `?` 代表匹配一个字符, `*` 代表匹配任意个字符;
- 花括号: `{}` 展开一系列指令.

```bash
mv *.{py,sh} folder    # 会移动所有 *.py 和 *.sh 文件
touch {foo,bar}/{a..h} # 创建 foo/a .. foo/h, bar/a .. bar/h 
```

