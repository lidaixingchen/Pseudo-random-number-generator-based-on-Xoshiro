# Xoshiro-cpp <a href="https://github.com/Reputeless/Xoshiro-cpp/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-4aaa4a"></a> 
**Xoshiro-cpp** 是一个适用于现代 C++ 的纯头文件伪随机数生成器库。  
基于 **David Blackman 和 Sebastiano Vigna 的 [xoshiro/xoroshiro 生成器](http://prng.di.unimi.it/)**。

![](xoshiro-cpp.png)

## 特性
- 符合 **`std::uniform_random_bit_generator` 概念** (C++20)
  - 可配合 `std::uniform_int_distribution`、`std::shuffle` 及其他标准库函数使用
- 在 C++17 中绝大部分为 **`constexpr`**
- 支持序列化 / 反序列化
- 实用函数 `double DoubleFromBits(uint64 v);`
  - 将给定的 uint64 值 `v` 转换为 [0.0, 1.0) 范围内的 64 位浮点值

PRNG (伪随机数生成器) | 输出位数 | 周期 | 内存占用
--|--|--|--
SplitMix64   | 64 bits | 2^64    | 8 bytes
xoshiro256+  | 64 bits | 2^256-1 | 32 bytes
xoshiro256++ | 64 bits | 2^256-1 | 32 bytes
xoshiro256** | 64 bits | 2^256-1 | 32 bytes
xoroshiro128+  | 64 bits | 2^128-1 | 16 bytes
xoroshiro128++ | 64 bits | 2^128-1 | 16 bytes
xoroshiro128** | 64 bits | 2^128-1 | 16 bytes
xoshiro128+  | 32 bits | 2^128-1 | 16 bytes
xoshiro128++ | 32 bits | 2^128-1 | 16 bytes
xoshiro128** | 32 bits | 2^128-1 | 16 bytes
xoroshiro64* | 32 bits | 2^64-1  | 8 bytes
xoroshiro64** | 32 bits | 2^64-1  | 8 bytes

## 示例

```C++
# include <iostream>
# include "XoshiroCpp.hpp"

int main()
{
    using namespace XoshiroCpp;

    const std::uint64_t seed = 12345;

    Xoshiro256PlusPlus rng(seed);

    for (int i = 0; i < 5; ++i)
    {
        std::cout << rng() << '\n';
    }
}

```

```
10201931350592234856
3780764549115216544
1570246627180645737
3237956550421933520
4899705286669081817

```

---

```c++
# include <iostream>
# include <random>
# include "XoshiroCpp.hpp"

int main()
{
    using namespace XoshiroCpp;

    const std::uint64_t seed = 12345;

    Xoshiro256PlusPlus rng(seed);

    std::uniform_int_distribution<int> dist(1, 6);

    for (int i = 0; i < 5; ++i)
    {
        std::cout << dist(rng) << '\n';
    }
}

```

```
1
5
4
3
6

```

---

```c++
# include <algorithm>
# include <iostream>
# include "XoshiroCpp.hpp"

int main()
{
    using namespace XoshiroCpp;

    const std::uint64_t seed = 12345;

    Xoshiro256PlusPlus rng(seed);

    std::array<int, 10> ar = { 0,1,2,3,4,5,6,7,8,9 };

    std::shuffle(ar.begin(), ar.end(), rng);

    for (const auto& x : ar)
    {
        std::cout << x << '\n';
    }
}

```

```
6
3
7
2
8
5
4
9
1
0

```

---

```c++
# include <iostream>
# include "XoshiroCpp.hpp"

int main()
{
    using namespace XoshiroCpp;

    const std::uint64_t seed = 12345;

    Xoshiro256PlusPlus rng(seed);

    for (int i = 0; i < 5; ++i)
    {
        std::cout << DoubleFromBits(rng()) << '\n';
    }
}

```

```
0.553048
0.204956
0.0851232
0.17553
0.265614

```

---

```c++
# include <iostream>
# include "XoshiroCpp.hpp"

int main()
{
    using namespace XoshiroCpp;

    // 这个示例的种子序列 { 111, 222, 333, 444 } 分布不佳
    // (含有大量的 '0' 位)，不适合直接用于生成器的内部状态。
    // 可以使用 SplitMix64 PRNG 来增加熵。
    const Xoshiro256Plus::state_type initialStateA =
    {
        SplitMix64{ 111 }(),
        SplitMix64{ 222 }(),
        SplitMix64{ 333 }(),
        SplitMix64{ 444 }(),
    };

    Xoshiro256PlusPlus rngA(initialStateA);

    for (int i = 0; i < 3; ++i)
    {
        std::cout << rngA() << '\n';
    }

    const Xoshiro256Plus::state_type state = rngA.serialize();

    Xoshiro256PlusPlus rngB(state);

    for (int i = 0; i < 3; ++i)
    {
        std::cout << std::boolalpha << (rngA() == rngB()) << '\n';
    }

    rngB.deserialize(initialStateA);

    for (int i = 0; i < 3; ++i)
    {
        std::cout << rngB() << '\n';
    }
}

```

```
9228892280983206813
11892737616047535485
12786908792686548306
true
true
true
9228892280983206813
11892737616047535485
12786908792686548306

```

## 路线图 (Roadmap)

* [x] SplitMix64
* [x] xoshiro256+
* [x] xoshiro256++
* [x] xoshiro256** - [x] xoroshiro128+
* [x] xoroshiro128++
* [x] xoroshiro128**
* [x] xoshiro128+
* [x] xoshiro128++
* [x] xoshiro128**
* [x] xoroshiro64*
* [x] xoroshiro64**

## 许可证

Xoshiro-cpp 根据 MIT 许可证分发。
