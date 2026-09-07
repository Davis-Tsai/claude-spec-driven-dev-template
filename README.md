# 規格驅動開發倉庫 (Spec-Driven Development Repo)

> 核心理念：**文件是「原始碼」，軟體與韌體是「編譯產物」。**
> 保留 `requirements/`、`contracts/`、`acceptance/`，即使刪除 `src/`，
> 也能重新生成一份**功能等價**且**通過所有驗收測試**的軟體/韌體。

---

## 新專案怎麼開始（Quick Start）

1. 把這個模板複製到新專案位置。**請複製以下全部項目**（注意：`.` 開頭的是隱藏檔，
   Windows 檔案總管預設看不到，最容易漏掉——建議開啟「顯示隱藏項目」再複製，或整包複製後刪掉 `.git`）：

   | 要複製 ✅ | 說明 |
   |-----------|------|
   | `CLAUDE.md` | AI 操作手冊（**最重要**，少了它 AI 不知道規則） |
   | `README.md` | 本說明 |
   | `.gitignore` | （隱藏）版控忽略規則 |
   | `.githooks/` | （隱藏）pre-commit 同步防護 hook（少了它防護不會啟用） |
   | `charter/` `requirements/` `contracts/` `acceptance/` `changes/` `ops/` | 全部文件資料夾 |
   | `src/` `hardware_build/` | 產物資料夾（含 `.gitkeep` 佔位） |

   | 不要複製 ❌ | 原因 |
   |-------------|------|
   | `.git/` | 那是**模板自己的** Git 歷史與遠端；複製過去會污染，且 push 會推錯 repo |

   > 提示：整個資料夾複製、只把 `.git/` 刪掉，是最不會漏檔的做法。
2. 在該資料夾開啟 Claude Code。
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
├── charter/         啟動與規劃（範疇、時程、設計決策總覽、待討論清單）
├── requirements/    需求與設計（PRD、ERD、ADR、UI）
├── contracts/       決定性錨點：DB schema、API、硬體規格 ← 唯一真相
├── acceptance/      驗收：軟體自動化測試 + 硬體人工量測
├── changes/         變更紀錄（已定案文件的修改歷史）
├── ops/             部署與維運（CI/CD、runbook）
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
- 圖表用 **Mermaid**（純文字、可版控）。
- 契約用**業界標準格式**（SQL / OpenAPI / CSV），確保無歧義。

> 想了解**這套模板為什麼這樣設計、有哪些選擇與限制**？看 `charter/design-decisions.md`（決策與限制總覽）。
- 每次「改文件 → 重新生成」都是一個 commit，message 說明改了哪份文件。
