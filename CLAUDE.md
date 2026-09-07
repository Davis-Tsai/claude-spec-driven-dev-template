# CLAUDE.md — AI 操作手冊

> 這是一個**規格驅動開發 (Spec-Driven Development)** 倉庫。
> 你（Claude Code）在這個專案的工作方式，以本檔為準。開始任何工作前先讀完本檔。
> 面向人類的方法論說明在 `README.md`；本檔是給你的**行為規範**。

---

## 0. 一句話原則

**文件是原始碼，程式碼與韌體是編譯產物。** 你的核心工作是：
維護 `requirements/` + `contracts/` + `acceptance/` 這三層文件，並在需要時據此**生成**或**重生** `src/` 與韌體。

---

## 0.5 專案初始化 (Bootstrap) — 動手開發前先做

本模板常以「複製資料夾」方式散佈到新專案。**在這個資料夾第一次開始工作前，先做版控自檢：**

1. **檢查是否為 Git 倉庫**：`git rev-parse --is-inside-work-tree`。
   - 若**不是** → 執行 `git init` 並做第一個 commit（本地動作，安全，可直接做）。
2. **檢查 `.git` 是否從模板繼承而來**：`git remote -v` 與 `git log --oneline`。
   - 若遠端 origin 指向模板倉庫，或歷史中含模板的 bootstrap commit（`建立規格驅動開發文件骨架`）
     → **停下來警告使用者**：這是模板的歷史/遠端，繼續 commit/push 會污染模板。
     建議重置：`rm -rf .git && git init`（先向使用者確認）。
3. **連接 GitHub 屬對外動作**：建立遠端 repo、`git remote add`、`git push`
   → **一律先徵得使用者同意**，不可自行執行。`git init` 與本地 commit 才可自行進行。

> 完成自檢、確認在乾淨的本地 Git 倉庫下，才開始後續開發。

---

## 1. 鐵則（不可違反）

1. **`contracts/` 是唯一真相 (single source of truth)。** 資料模型／API／硬體規格以 `contracts/` 為準。
   `requirements/ERD.md` 裡的圖只是導讀；若與 `contracts/` 衝突，一律以 `contracts/` 為準。
2. **生成程式碼時，只讀 `requirements/`、`contracts/`、`acceptance/`。** 不要參考 `src/` 舊程式碼來「延續寫法」，
   否則就違背了「可從文件重生」的目的。
3. **`hardware_build/`（PCB／原理圖／layout）是保存物，不是重生物。** 韌體「邏輯」可依文件重生，
   但**不要**嘗試用純文字生成 PCB 佈線／類比電路／EMC 設計——那些一律以 `hardware_build/` 內既有檔案為準。
4. **版本交給 Git。** 不要在文件裡手寫版本號或日期。frontmatter 只保留 `狀態:`。
5. **需求要可追溯。** 每條需求有 ID（FR-xxx / NFR-xxx），對應驗收 ID（AC-xxx / HW-AC-xxx）。
   改動需求時，必須同步維護 `requirements/ERD.md` 的追溯表與 `acceptance/` 的測試。

---

## 2. 資料夾地圖

| 路徑 | 是什麼 | 你更新它的時機 |
|------|--------|----------------|
| `charter/scope.md` | 專案範疇、利害關係人、KPI | 專案啟動、範疇變更 |
| `charter/timeline.md` | 時程（Mermaid 甘特圖） | 排程調整 |
| `charter/open-questions.md` | 方法論待討論清單 | 有新的方法論決策待定或已定 |
| `requirements/PRD.md` | 產品需求（意圖層，**不寫實作**） | 需求新增／變更 |
| `requirements/ERD.md` | 技術結構、軟硬體邊界、追溯表 | PRD 變更後同步 |
| `requirements/decisions/` | ADR 架構決策紀錄 | 每個重大技術決策 |
| `requirements/ui/` | UI/UX 原型與流程 | 介面設計 |
| `contracts/data-schema.sql` | DB 結構契約 | 資料模型定案／變更 |
| `contracts/api.openapi.yaml` | API 契約 | 介面定案／變更 |
| `contracts/hardware/` | 腳位、時序、電氣、BOM | 硬體規格定案／變更 |
| `acceptance/software/` | 軟體驗收（Gherkin，可執行） | 定義／變更驗收條件 |
| `acceptance/hardware/` | 硬體驗收（人工量測程序） | 定義／變更量測程序 |
| `ops/` | CI/CD、runbook | 部署與維運 |
| `src/` | 軟體產物（可拋棄後重建） | 由文件生成 |
| `hardware_build/` | 硬體產物（納入版控保存） | 保存實體設計檔 |

---

## 3. 更新文件的規則（依文件類型）

### PRD（`requirements/PRD.md`）
- 只寫「要做什麼、為誰、為什麼」，**不寫技術實作**。
- 每條需求給唯一 ID。新增需求後，**主動提醒使用者**是否要同步更新 ERD 與 acceptance。

### ERD（`requirements/ERD.md`）
- 是 PRD 的技術轉譯。內容須與 `contracts/` 一致；衝突時改的是這裡（除非決策要改契約）。
- 維護「需求追溯表」：PRD 需求 → 模組 → 契約 → 測試。

### 契約（`contracts/`）
- 這是最需謹慎的地方。**若文件狀態為「已定案」，不要擅自修改**；
  要改契約，先與使用者確認，並記錄一則 ADR 說明變更原因（因為契約變更會連動程式碼重生）。
- 用標準格式（SQL / OpenAPI / CSV），保持無歧義。

### 驗收（`acceptance/`）
- 軟體用 Gherkin，每個 Scenario 對一個 AC-ID，AC-ID 對回 PRD 需求。
- 硬體用人工量測程序表；不要嘗試把它自動化成軟體測試。

### ADR（`requirements/decisions/`）
- 重大決策 = 新增一份，編號遞增，**永不刪除**；被推翻時新增一份標記「取代 ADR-XXXX」。

---

## 4. 狀態流轉（暫定，見 `charter/open-questions.md` Q1）

frontmatter 的 `狀態:` 有三階：`草稿 → 審核中 → 已定案`。

- **暫定規則**：只有使用者能把文件標記為「已定案」。你可以建議，但不要自行升級狀態。
- **契約凍結**：`contracts/` 內文件標為「已定案」＝契約凍結，此後才適合大規模生成程式碼。
- ⚠️ 此節為暫定，正式規則待 Q1 討論後更新本檔。

---

## 5. 生成 / 重生程式碼

**前提**：相關 `contracts/` 已定案（見 §4）。

**流程**：
1. 只讀 `requirements/` + `contracts/` + `acceptance/`。
2. 生成 `src/`（軟體）與韌體邏輯。
3. 跑 `acceptance/software/` 的測試；全數通過才算完成。硬體則列出對應的人工量測項給使用者。
4. 一次生成 = 一個 commit。

**重建指令**（使用者可能會這樣說）：
> 「請只讀取 requirements/、contracts/、acceptance/，重新生成 src/ 與韌體，並通過 acceptance/ 內所有測試。」
收到此類指令時，**先刪除或忽略 `src/` 舊內容的影響**，純粹依文件重生。

---

## 6. Commit 慣例

- 每次「改文件」或「重新生成」都獨立 commit。
- message 說明改了哪份文件／為何重生（例：`feat(contracts): 新增裝置設定 API` 或 `chore: 依契約重生 src/`）。
- 不需要在文件內寫版本號——`git log` 就是版本史。

---

## 7. 你常見的動作清單

- 使用者講一個新想法 → 幫他寫進 PRD（給 ID）→ 提醒同步 ERD／acceptance。
- 使用者要「定案某個契約」→ 確認內容、必要時補 ADR、由使用者升級狀態。
- 使用者說「生成/重生」→ 依 §5 執行。
- 使用者問「這個專案現在到哪了」→ 看各文件 `狀態:` 與 `charter/open-questions.md`。
