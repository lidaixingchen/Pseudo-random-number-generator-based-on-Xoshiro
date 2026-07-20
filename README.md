# Pseudo-random-number-generator-based-on-Xoshiro

基于 **xoshiro/xoroshiro** 算法族的纯头文件伪随机数生成器库。

原始算法：[David Blackman & Sebastiano Vigna](http://prng.di.unimi.it/)
原始 C++ 封装：[Ryo Suzuki (Xoshiro-cpp)](https://github.com/Reputeless/Xoshiro-cpp)

## 版本选择

本仓库提供两个头文件，按需选用：

| 头文件 | 标准 | 命名空间 | 说明 |
|--------|------|----------|------|
| **Random.hpp** | C++23 | `xoshiro` | 增强版：concepts 约束、便捷 API（`RandInt`/`RandReal`/`RandBool`/`RandElement`）、线程局部默认引擎、`discard(n)`、中文注释 |
| **XoshiroCpp.hpp** | C++17 / C++20 | `XoshiroCpp` | 原始版：与上游 Xoshiro-cpp 保持一致，英文注释，无额外依赖 |

> 如果你的编译器支持 C++23，推荐使用 `Random.hpp`；否则使用 `XoshiroCpp.hpp`。
> 两者算法实现完全一致，输出序列相同（相同种子下）。

## 特性（Random.hpp）

- 满足 `std::uniform_random_bit_generator` 概念，可直接配合标准库 distribution / `std::shuffle` 使用
- 全 `constexpr`，编译期可用
- 内置便捷 API：`RandInt` / `RandReal` / `RandBool` / `RandElement`
- 线程局部默认引擎（`DefaultEngine()`），零配置即用
- 支持 `jump()` / `longJump()` 并行子序列、`discard(n)` 跳过、`serialize()` / `deserialize()` 状态持久化
- 12 个引擎全覆盖

## 引擎一览

| 引擎 | 输出 | 周期 | 状态 | 适用场景 |
|------|------|------|------|----------|
| Xoshiro256StarStar | 64-bit | 2^256-1 | 32B | 通用首选，统计质量最优 |
| Xoshiro256PlusPlus | 64-bit | 2^256-1 | 32B | 通用，略快于 ** |
| Xoshiro256Plus | 64-bit | 2^256-1 | 32B | 最快，低位质量稍弱 |
| Xoroshiro128PlusPlus | 64-bit | 2^128-1 | 16B | 内存受限场景 |
| Xoroshiro128StarStar | 64-bit | 2^128-1 | 16B | 同上，统计更优 |
| Xoroshiro128Plus | 64-bit | 2^128-1 | 16B | 同上，最快 |
| Xoshiro128PlusPlus | 32-bit | 2^128-1 | 16B | 32 位平台 |
| Xoshiro128StarStar | 32-bit | 2^128-1 | 16B | 32 位平台，统计更优 |
| Xoshiro128Plus | 32-bit | 2^128-1 | 16B | 32 位平台，最快 |
| Xoroshiro64StarStar | 32-bit | 2^64-1 | 8B | 极端内存受限 |
| Xoroshiro64Star | 32-bit | 2^64-1 | 8B | 极端内存受限，最快 |
| SplitMix64 | 64-bit | 2^64 | 8B | 种子扩展 / 哈希，非通用 PRNG |

## 快速上手

```cpp
#include "Random.hpp"
#include <iostream>

int main()
{
    // 最简用法：便捷函数（内部使用线程局部 Xoshiro256StarStar）
    std::cout << xoshiro::RandInt(1, 6) << '\n';   // 掷骰子 [1, 6]
    std::cout << xoshiro::RandReal() << '\n';       // [0.0, 1.0)
    std::cout << xoshiro::RandBool(0.3) << '\n';    // 30% 概率为 true
}
```

## 手动管理引擎

```cpp
#include "Random.hpp"
#include <random>
#include <iostream>

int main()
{
    // 用真随机种子创建引擎
    xoshiro::Xoshiro256StarStar rng{ xoshiro::RandomSeed() };

    // 指定引擎的便捷函数
    std::cout << xoshiro::RandInt(rng, 0, 99) << '\n';

    // 配合标准库 distribution
    std::normal_distribution<double> norm(0.0, 1.0);
    std::cout << norm(rng) << '\n';

    // 序列化 / 反序列化
    auto state = rng.serialize();
    rng.deserialize(state);

    // 跳跃（并行子序列）
    rng.jump();      // 前进 2^128 步
    rng.longJump();  // 前进 2^192 步

    // 跳过
    rng.discard(1000);
}
```

## 配合 std::shuffle

```cpp
#include "Random.hpp"
#include <algorithm>
#include <array>
#include <iostream>

int main()
{
    xoshiro::Xoshiro256PlusPlus rng{ 12345 };

    std::array<int, 10> ar = { 0,1,2,3,4,5,6,7,8,9 };
    std::shuffle(ar.begin(), ar.end(), rng);

    for (const auto& x : ar)
        std::cout << x << ' ';
}
```

## 从容器中随机取元素

```cpp
#include "Random.hpp"
#include <vector>
#include <iostream>

int main()
{
    std::vector<int> items = { 10, 20, 30, 40, 50 };
    std::cout << xoshiro::RandElement(items) << '\n';
}
```

## 编译要求

| 头文件 | 最低标准 | 推荐编译器 |
|--------|----------|------------|
| Random.hpp | C++23 | GCC 14+ / Clang 18+ / MSVC 17.10+ |
| XoshiroCpp.hpp | C++17 | GCC 9+ / Clang 10+ / MSVC 16.8+ |

- 无外部依赖，纯头文件，复制即用

## 致谢

- 算法设计：David Blackman & Sebastiano Vigna
- 原始 C++ 封装：Ryo Suzuki ([Xoshiro-cpp](https://github.com/Reputeless/Xoshiro-cpp), MIT License)
