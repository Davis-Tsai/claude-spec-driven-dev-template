# 規格驅動開發倉庫 (Spec-Driven Development Repo)

> 核心理念：**文件是「原始碼」，軟體與韌體是「編譯產物」。**
> 保留 `requirements/`、`contracts/`、`acceptance/`，即使刪除 `src/`，
> 也能重新生成一份**功能等價**且**通過所有驗收測試**的軟體/韌體。

---

## 新專案怎麼開始（Quick Start）

這是一個 **GitHub 範本倉庫 (template repository)**。從 GitHub 取得的最終目的通常是**雲端備份 + 團隊協作**，
所以下面把每種取得方式、以及「如何確實接上雲端」一次講清楚。

### 步驟一：把檔案取得到本地（三選一）

**A. Use this template（最推薦）**
1. 在本 repo 頁面按 **Use this template → Create a new repository**，在你的帳號建立新 repo。
2. 把它 clone 到本地：
   ```
   git clone https://github.com/<你的帳號>/<新repo名>.git
   cd <新repo名>
   ```
   - 特點：新 repo 已在你的 GitHub 上（**雲端備份/協作一開始就有**）、歷史乾淨、不含範本建置歷史。

**B. Download ZIP**
1. 在本 repo 頁面按 **Code → Download ZIP**，解壓到你要的位置。
   - 特點：純資料夾、無 `.git`、還沒上雲端（要備份/協作見步驟三）。

**C. Clone 後重置**
```
git clone https://github.com/Davis-Tsai/claude-spec-driven-dev-template.git <新專案名>
cd <新專案名>
rm -rf .git        # ⚠️ 一定要做：清掉範本的歷史與遠端，否則 commit/push 會污染範本
```
   - 特點：用 git 方式拿檔，但**必須重置**才乾淨；重置後同 B（純本地、還沒上雲端）。

> **怎麼選**：要一開始就有雲端備份/協作 → **A**；只想先本地/離線試 → **B**；習慣用 git clone → **C（記得重置）**。

### 步驟二：初始化（開 Claude Code）
在你的新專案資料夾開啟 Claude Code，第一句話：

> 請依 CLAUDE.md 初始化這個專案

Claude Code 會做版控自檢（沒有 Git 就 `git init`＋第一個 commit、安裝 pre-commit hook）、提醒你設定 references Base，再開始開發。

### 步驟三：接上雲端備份 / 協作
- **A**：已完成（新 repo 就在你的 GitHub）。
- **B / C**：本地先有 commit 後，自己建 GitHub repo 並推送即可（推完就與 A 相同）：
  ```
  # 先在 GitHub 建一個空的新 repo，然後：
  git remote add origin https://github.com/<你的帳號>/<新repo名>.git
  git branch -M main
  git push -u origin main
  ```
  （有 GitHub CLI 的話一次完成：`gh repo create <新repo名> --private --source=. --remote=origin --push`）

> 註：連 GitHub 這步**由你自己做**；依 `CLAUDE.md §0.5`，AI 不會自作主張建遠端或 push。

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
- **逆向規格化**：若規格是從既有專案逆向萃取而來，文件預設「審核中」，須標來源、建覆蓋率矩陣、經獨立複核後由人核可才定案（見 `CLAUDE.md §4.5`、`charter/reverse-spec-provenance.md`）。
- 圖表用 **Mermaid**（純文字、可版控）。
- 契約用**業界標準格式**（SQL / OpenAPI / CSV），確保無歧義。

> 想了解**這套模板為什麼這樣設計、有哪些選擇與限制**？看 `charter/design-decisions.md`（決策與限制總覽）。
>
> 維護／改善本模板、以及既有專案如何吸收改善：看 `MAINTAINING.md`。
- 每次「改文件 → 重新生成」都是一個 commit，message 說明改了哪份文件。
