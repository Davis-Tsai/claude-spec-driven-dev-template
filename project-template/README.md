# 規格驅動開發倉庫 (Spec-Driven Development Repo)

> 核心理念：**文件是「原始碼」，軟體與韌體是「編譯產物」。**
> 保留 `requirements/`、`contracts/`、`acceptance/`，即使刪除 `src/`，
> 也能重新生成一份**功能等價**且**通過所有驗收測試**的軟體/韌體。

---

## 新專案怎麼開始（Quick Start）

1. **複製整個這個資料夾**到你要放新專案的位置，並改成你的專案名稱。
   - 資料夾內的隱藏檔（`.gitignore`、`.gitattributes`、`.githooks/`）會隨資料夾一起複製，不用另外處理。
   - `.git` 在這個資料夾的**外層**、不在裡面，所以複製出去的資料夾**天生不含 Git 歷史**，不會污染母版、也不會 push 到錯的 repo。
2. 在複製出來的資料夾開啟 Claude Code。
3. **第一句話直接說：**

   > 請依 CLAUDE.md 初始化這個專案

   Claude Code 會先做版控自檢（沒有 Git 就 `git init` + 第一個 commit），再開始後續開發。
   GitHub 遠端請自行處理，AI 不會代為連接或 push。

---

## 可重生 vs. 需保存（重要邊界）

| 對象 | 策略 | 原因 |
|------|------|------|
| 軟體程式碼 (`src/`) | **可由文件重生** | 有契約 + 自動化測試作硬保證 |
| 韌體邏輯 | **可由文件重生** | 邏輯由腳位/時序/需求決定 |
| PCB、原理圖、layout (`hardware_build/`) | **一起進 Git 保存，不重生** | 佈線/EMC/類比高度依賴實體調校，無法純文字還原 |

---

## 決定性錨點（重建靠這三樣）

| 錨點 | 軟體 | 硬體 | 位置 |
|------|------|------|------|
| 1. 意圖 | 要做什麼、給誰 | 同左 | `requirements/PRD.md` |
| 2. 契約 | 資料模型、API | 腳位、時序、電氣、BOM | **`contracts/`（唯一真相）** |
| 3. 正確性 | 自動化測試 | 人工量測程序 | `acceptance/` |

外加 **ADR**（`requirements/decisions/`）鎖住「為什麼這樣選」，避免重建時架構走樣。

> **唯一真相原則**：資料模型/介面以 `contracts/` 為準。`requirements/ERD.md` 內的圖只是導讀；
> 衝突時以 `contracts/` 為準。**生成程式碼時我只讀 `contracts/`。**

---

## 資料夾結構（依功能分類）

```
.
├── charter/         規劃（範疇、時程、設計決策、待討論、詞彙表、DoD、風險登記）
├── requirements/    需求與設計（PRD、ERD、ADR、UI）
├── contracts/       決定性錨點：DB schema、API、硬體規格 ← 唯一真相
├── acceptance/      驗收：軟體自動化測試 + 硬體人工量測
├── changes/         變更紀錄（已定案文件的修改歷史）
├── ops/             部署與維運（CI/CD、runbook、環境與機密）
├── src/             軟體產物（可拋棄後重建）
└── hardware_build/  硬體產物（PCB/原理圖/韌體，納入版控保存）
```

---

## 協作循環（與 Claude Code 一起）

1. **需求**：你講想法 → 我寫成 PRD / ERD / ADR。
2. **契約**：確認並凍結 `contracts/`（schema / API / 硬體規格）。
3. **驗收**：定義「怎樣算對」→ 我轉成 `acceptance/` 測試與量測表。
4. **實作**：你說「依文件生成」→ 我**只讀 `requirements/` + `contracts/` + `acceptance/`** 生成 `src/` 與韌體。
5. **驗證**：軟體跑測試、硬體人工量測記錄，證明還原成功。

### 重建指令範例
> 「請只讀取 `requirements/`、`contracts/`、`acceptance/`，重新生成 `src/` 與韌體，
> 並確保通過 `acceptance/` 內所有測試。」

---

## 文件慣例

- **版本控制交給 Git**：不在文件裡手寫版本號或日期。「這份文件是什麼版本」看 `git log` 即可。
- **frontmatter 只保留 Git 看不出來的資訊**：目前僅 `狀態: 草稿 | 審核中 | 已定案 | 修改中 | 不適用 (N/A)`。
- **模板同時涵蓋軟體與硬體**：純軟體或純硬體專案，把用不到的維度文件狀態標為「不適用」即可（見 `charter/scope.md` 專案型態）。
- **已定案文件的修改走變更管理**：先進「修改中」→ 與 AI 討論 → 改完同步更新 PRD/ERD/契約，並在 `changes/change-log.md` 留一筆紀錄（見 CLAUDE.md §4）。
- **文件優先 (spec-first)**：功能改動先改文件再生成程式碼；不繞過文件直接手改 `src/`。
- **同步防護**：pre-commit hook（`.githooks/`）會在 commit 前跑 `acceptance/run-tests.sh`，擋下「契約變了但程式碼沒跟上」（測試指令待技術棧定案後填入，見 CLAUDE.md §5）。
  - ⚠️ 若日後把專案 **clone 到別處**，hook 設定不會跟著走，需重跑一次 `git config core.hooksPath .githooks`。
- **機密不進版控**：金鑰/密碼用環境變數，`.env`/`*.key` 等已被忽略；設定方式見 `ops/environment.md`。
- 圖表用 **Mermaid**（純文字、可版控）。
- 契約用**業界標準格式**（SQL / OpenAPI / CSV），確保無歧義。

> 想了解**這套模板為什麼這樣設計、有哪些選擇與限制**？看 `charter/design-decisions.md`（決策與限制總覽）。
- 每次「改文件 → 重新生成」都是一個 commit，message 說明改了哪份文件。
