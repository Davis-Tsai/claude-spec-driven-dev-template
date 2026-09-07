---
文件: CI/CD 與自動化部署
狀態: 草稿
---

# CI/CD 流程

## 軟體管線
```mermaid
flowchart LR
    Commit[Git commit] --> Lint[靜態檢查]
    Lint --> Test[跑 acceptance 測試]
    Test --> Build[建置]
    Build --> Deploy[部署到環境]
```

| 階段 | 工具 | 通過條件 |
|------|------|----------|
| 檢查 |  |  |
| 測試 |  | acceptance 全數通過 |
| 部署 |  |  |

## 韌體/硬體管線
- 韌體建置：___（編譯、產生 .hex/.bin）
- 燒錄與煙霧測試：___
- 硬體驗收：依 `acceptance/hardware/` 程序

## 環境
| 環境 | 用途 | 網址/位置 |
|------|------|-----------|
| dev |  |  |
| staging |  |  |
| prod |  |  |
