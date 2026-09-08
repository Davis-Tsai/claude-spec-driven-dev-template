---
文件: 工程要求文件 (ERD) — 含資料模型
狀態: 草稿
---

# 工程要求文件 (ERD) — 結構層

> 把 PRD 的意圖轉成技術結構。這裡的內容應與 `contracts/` 完全一致。
>
> ⚠️ 範例可刪：本檔的架構圖、USER/DEVICE/TELEMETRY、技術選型等均為格式示範，開始真實專案時請替換。

## 1. 系統架構總覽
```mermaid
flowchart LR
    User[使用者] --> App[應用層/前端]
    App --> API[API 服務]
    API --> DB[(資料庫)]
    API <--> HW[硬體裝置/韌體]
    HW --> Sensor[感測器/致動器]
```

## 2. 軟硬體邊界 (Interface Contract)
> 軟體與硬體之間怎麼溝通？這是整合專案最容易出錯的地方，務必寫清楚。

| 介面 | 方向 | 協定 | 資料格式 | 契約檔 |
|------|------|------|----------|--------|
| 例：裝置狀態上報 | HW → API | MQTT/HTTP/UART | JSON/binary | `contracts/api.openapi.yaml` |
| 例：韌體指令下發 | API → HW | 同上 | 同上 |  |

## 3. 資料模型 (ER Diagram)
```mermaid
erDiagram
    USER ||--o{ DEVICE : owns
    DEVICE ||--o{ TELEMETRY : reports
    USER {
        int id PK
        string email
    }
    DEVICE {
        int id PK
        int user_id FK
        string serial_no
    }
    TELEMETRY {
        int id PK
        int device_id FK
        datetime ts
        float value
    }
```
> ⚠️ 此 ER 圖**僅供導讀/視覺化**。唯一真相 (single source of truth) 是
> **`contracts/data-schema.sql`**；若圖與 schema 衝突，一律以 schema 為準。生成程式碼時只讀 `contracts/`。

## 4. 技術選型 (對應 ADR)
| 項目 | 選擇 | 決策紀錄 |
|------|------|----------|
| 後端語言/框架 |  | ADR-0002 |
| 資料庫 |  |  |
| MCU / 硬體平台 |  |  |
| 通訊協定 |  |  |

## 5. 需求追溯 (Traceability)
| PRD 需求 | 對應模組/元件 | 對應契約 | 對應測試 |
|----------|---------------|----------|----------|
| FR-001 |  |  | AC-001 |
