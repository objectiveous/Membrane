<div align="center">

# Membrane (简体中文)

**面向 Swift 的 Actor 上下文流水线。**

[English](../README.md) | [Español](README.es.md) | [日本語](README.ja.md) | [中文](README.zh-CN.md)

</div>

---

Membrane 接收一份上下文请求，先分配预算，再压缩和分页低优先级内容，最后生成模型真正能装下的请求。

## 核心特性

- **确定性预算:** 将令牌划分为 9 个域存储桶，并执行严格的协议限制。
- **多层级压缩:** 在 `full`、`gist` 和 `micro` 层级之间动态转换上下文，以最大化信息密度。
- **Actor 隔离流水线:** 基于 Swift 6 并发构建，确保每个阶段的线程安全和非阻塞执行。
