# CodeQL

## WorkFlow Overview

### Step

1. **WorkFlow1**
    - 通过xml文件, 再使用codeql中的dataflow来找到具体在hadoop中的大写的静态变量

2. **WorkFlow2**
    - 通过workflow1找到的静态变量去找binaryExpr, 我们binaryExpr的两端的右端就是我们workflow1中找到的静态变量, 我们将找到左边

3. **WorkFlow3**
    - 我们通过workflow2中找到的左边的变量, 然后再用dataflow来反向寻找

    //TODO: 反向寻找的终点应该是系统的lib或者是metadata的东西



## Installation

`pip install pandas subprocess tqdm`

