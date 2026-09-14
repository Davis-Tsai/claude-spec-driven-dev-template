---
文件: 參考資料登錄表 (Reference Registry)
狀態: 進行中
---

# 參考資料登錄表 (Reference Registry)

> 規範見 `references/README.md`。**此檔：Base 由你設定；下方登錄表由 Claude 自動維護（你不必手動改表）。**
>
> **填好本表＝授權 Claude 讀取**：你在此登錄 Base 後，即表示
> **Claude 可讀取該 Base 下 `references\` 目錄樹的所有檔案與子目錄**，以便分析時自行查閱參考。
> 下表是給你維護的**索引**（供 `REF-ID` 引用與快速查找），**不是限制讀取範圍的白名單** —— 目錄裡沒列進表的檔案 Claude 也能讀。
> （為效率，Claude 會挑與當前任務相關的內容讀、大型 PDF 讀需要的章節，不會把整包塞進 context。）

## 主目錄 (Base)

**怎麼填**（這一段是要你編輯的，不是範例）：
- 一個 Drive 用一個 Base；**只用到一個 Drive 就只留 `BASE-A` 一行**，跨 Drive 才加 `BASE-B`、`BASE-C`…。
- 每行格式：`` `代號`：`路徑` ``。路徑填到「`references` 資料夾的上一層」、結尾帶 `\`。
- 行尾小括號 `（…）` 是**給你自己看的註解**，可留、可改、可刪，不影響 Claude 讀取。
- **完整路徑 ＝ 這裡的 Base ＋ 下表「位置」欄**。換機器 / 搬專案 / 換 Drive → 只改這裡對應那一行，整表不用動。

**填寫區**（把下面改成你的實際路徑；用不到的行就刪掉）：
- `BASE-A`：`G:\Shared drives\<你的專案>\`　（公司 / Shared Drive）
- `BASE-B`：`G:\My Drive\<你的資料夾>\`　（私人 / My Drive；沒有就刪這行）

> 給 Claude 讀時把「Base ＋ 位置」相接，例：`G:\Shared drives\<你的專案>\` ＋ `references\datasheets\ICM-42688.pdf`。

> ⚠️ 範例可刪：下方為格式示範（Claude 首次登錄真實項目時會清掉這些範例列）。
> 本表由 Claude 自動維護：讀取參考目錄或收到你提供的檔案後，自動新增/更新對應 REF 列。

| REF-ID | 分類 | 標題 | Base | 位置（相對該 Base） | 版本 / 查閱日期 | 一句話內容 |
|--------|------|------|------|---------------------|-----------------|------------|
| REF-001 | datasheet | 範例：某 IMU datasheet | BASE-A | `references\datasheets\ICM-42688.pdf` | Rev C / 2026-09-14 | 陀螺量程、暫存器設定 |
| REF-002 | standard | 範例：某協定規格 | BASE-A | `references\standards\xxx.pdf` | 2026-09 | 封包格式與時序 |
| REF-003 | note | 範例：個人研究筆記 | BASE-B | `references\notes\meeting-20260914.md` | 2026-09-14 | 初期選型討論 |

> **分類**（參考）：`datasheet`｜`standard`｜`vendor-doc`｜`note`｜`capture`｜其他。
