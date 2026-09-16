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

本模板以 **GitHub 範本倉庫**散佈（`Use this template` / Download ZIP / `git clone`），也可直接複製資料夾。
**觸發時機：在這個專案第一次收到任何開發指令時，先完成以下版控自檢，再動手做事。**

1. **檢查是否為 Git 倉庫**：`git rev-parse --is-inside-work-tree`。
   - 若**不是** → 執行 `git init` 並做第一個 commit（本地動作，安全，可直接做）。
2. **檢查 `.git` 是否來自範本本身**：`git remote -v` 與 `git log --oneline`。
   - 用 **Use this template** 或 **Download ZIP** 取得者：無範本建置歷史，正常，跳過本步。
   - 但若直接 `git clone` 本範本 repo 來用（remote 指向範本倉庫，或歷史含範本 bootstrap commit `建立規格驅動開發文件骨架`）
     → **停下來警告使用者**：這是範本的歷史/遠端，繼續 commit/push 會污染範本。
     **強烈建議重置**：`rm -rf .git && git init`（執行前向使用者確認一次）。
3. **GitHub 完全交給使用者自行處理**：AI 不建立遠端 repo、不 `git remote add`、不 `git push`，
   也不主動詢問是否要連 GitHub。只做本地 `git init` 與本地 commit。
4. **安裝同步防護 hook**：`git init` 後執行 `git config core.hooksPath .githooks`，
   讓 §5 的 pre-commit 驗收測試防護生效（hook 已隨模板附在 `.githooks/`）。
   - 若 `.githooks/` 或 `.gitignore` 不存在 → **提醒使用者**：可能取得時漏了隱藏檔（`.` 開頭），
     請重新以 Use this template / ZIP 取得完整內容（見 README Quick Start）。
   - ⚠️ `core.hooksPath` 設定寫在 `.git/config`，**不隨版控帶走**。若本專案日後被 clone 到別的地方，
     hook 不會自動生效，須在該 clone 重跑一次 `git config core.hooksPath .githooks`。

5. **提醒設定參考資料 Base**：若本專案會用到參考素材（datasheet／標準／廠商文件…），
   提醒使用者到 `references/registry.md` 設定 **Base 路徑**（指向 G drive 的參考目錄）；見 `references/README.md`。
   - 使用者也可**直接把資料夾的 `G:\` 路徑貼給你**，由你代填/更新 registry 的 Base，不必手動編輯。

> 完成自檢、確認在乾淨的本地 Git 倉庫下，才開始後續開發。

---

## 0.7 專案型態：軟體？硬體？兩者？

本模板同時涵蓋軟體與硬體。**開始工作前先讀 `charter/scope.md` 的「專案型態」**：

- 型態為 **純軟體** → `contracts/hardware/`、`acceptance/hardware/`、`hardware_build/` 屬**不適用**。
- 型態為 **純硬體** → `contracts/data-schema.sql`、`contracts/api.openapi.yaml`、`acceptance/software/`、`src/` 屬**不適用**。
- 型態為 **軟硬整合** → 全部適用。

處理**不適用**的維度時：
1. 不要強迫使用者填寫那些文件，也不要視為「未完成」。
2. 把那些文件 frontmatter 的 `狀態:` 標為 `不適用 (N/A)`，並在檔首寫一句說明（例：「本專案不含硬體」）。
3. 生成/重生程式碼時**略過**不適用的維度。

> `狀態:` 的合法值：`草稿 | 審核中 | 已定案 | 修改中 | 不適用 (N/A)`。

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
6. **文件優先 (spec-first)。** 任何功能改動**先改文件（PRD/契約），再據此生成或更新程式碼**。
   **禁止**繞過文件、直接手改 `src/` 就當完成；若因臨時需要手改了程式碼，**必須立即回補**對應文件與
   `changes/change-log.md`，否則視為漂移。詳見 §5「契約變更後的程式碼同步」。
7. **機密絕不進版控。** 金鑰/密碼/憑證一律用環境變數或密鑰服務，不寫死於程式碼、不 commit。
   詳見 `ops/environment.md`。

---

## 2. 資料夾地圖

| 路徑 | 是什麼 | 你更新它的時機 |
|------|--------|----------------|
| `charter/scope.md` | 專案範疇、利害關係人、KPI | 專案啟動、範疇變更 |
| `charter/timeline.md` | 時程（Mermaid 甘特圖） | 排程調整 |
| `charter/design-decisions.md` | 設計決策與限制總覽（為什麼這樣設計） | 有新的方法論決策或限制時 |
| `charter/open-questions.md` | 方法論待討論清單 | 有新的方法論決策待定或已定 |
| `charter/glossary.md` | 詞彙表（統一術語） | 出現新的重要名詞 |
| `charter/definition-of-done.md` | 完成的定義 (DoD) | 回報「完成」前對照 |
| `charter/risk-register.md` | 風險登記表 | 發現/更新風險 |
| `charter/reverse-spec-checklist.md` | 逆向規格化操作步驟 (SOP) | 文件化既有專案時（見 §4.5） |
| `charter/reverse-spec-provenance.md` | 逆向規格化溯源記錄（僅逆向專案需要） | 文件化既有專案時（見 §4.5） |
| `ops/environment.md` | 環境變數、機密、**工具鏈就緒清單** | 設定環境、處理 secrets、技術棧 ADR 定案時 |
| `changes/change-log.md` | 變更紀錄（已定案文件的修改歷史） | 每次修改已定案文件時（見 §4） |
| `requirements/PRD.md` | 產品需求（意圖層，**不寫實作**） | 需求新增／變更 |
| `requirements/ERD.md` | 技術結構、軟硬體邊界、追溯表 | PRD 變更後同步 |
| `requirements/decisions/` | ADR 架構決策紀錄 | 每個重大技術決策 |
| `requirements/ui/` | UI/UX 原型與流程 | 介面設計 |
| `references/README.md` | 參考資料規範（界線、Drive 分工、給 AI 讀取方式） | 大多不動 |
| `references/registry.md` | 參考資料登錄表（Base + 連結列表，指向 G drive；**要填的表**） | 有新的參考素材時 |
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

### 硬體契約（`contracts/hardware/`）
- **腳位不只記 pin↔訊號，還要記每支 pin 的「內部組態」**：AF/mux 模式、GPIO 推挽/開漏、上下拉、速度、電位。
- **跨零件/板對板的連接，用 `pinout.md` 的「連接組態對照表」列出兩端各自組態並檢查相容性**（方向、電位、協定模式、open-drain 是否有上拉）——這是重生韌體 pin 設定、以及一次核對連接的關鍵，別讓組態只藏在程式碼裡。

### 驗收（`acceptance/`）
- 軟體用 Gherkin，每個 Scenario 對一個 AC-ID，AC-ID 對回 PRD 需求。
- 硬體用人工量測程序表；不要嘗試把它自動化成軟體測試。

### ADR（`requirements/decisions/`）
- 重大決策 = 新增一份，編號遞增，**永不刪除**；被推翻時新增一份標記「取代 ADR-XXXX」。
- **技術棧選型必記 ADR**：資料庫、後端/前端框架、語言、通訊協定、MCU/硬體平台等第一次選定時，
  各記一則 ADR，並在 `requirements/ERD.md` 的技術選型表引用其編號。
  這是「重生時不會選到不同技術」的關鍵——沒有 ADR，重生結果可能不等價。
- 選定技術棧後，記得把對應的測試指令填進 `acceptance/run-tests.sh`（見 §5），讓 pre-commit 防護真正生效。
- **播種工具鏈清單**：每記一則技術棧選型 ADR（語言/框架/DB/MCU/SDK/工具鏈），同步在 `ops/environment.md` 的「工具鏈就緒清單」新增對應列，並提醒使用者：此工具需安裝，之後生成/建置會用到。

---

## 4. 狀態流轉與變更管理

`狀態:` 生命週期：`草稿 → 審核中 → 已定案`；已定案後若要修改則進入 `修改中`，改完再回到 `已定案`。
（`不適用 (N/A)` 為正交狀態，見 §0.7。）

### 升級權限
- `草稿 → 審核中`：**AI 可自行升級**（意思是「我認為寫好了，請你審」）。
- `審核中 → 已定案`：**只有使用者能按下**。AI 只能建議，不可自行定案。

### 定案前檢查（尤其契約）
在使用者定案前，AI 先跑並回報：
- 每條 PRD 需求（FR/NFR）都有對應契約與驗收（AC/HW-AC）？追溯表無缺口？
- `data-schema.sql` / `api.openapi.yaml` 語法有效、彼此無矛盾？
- 硬體契約（腳位/時序/電氣/BOM）彼此一致？

回報「可定案 ✅ / 有 N 處待補 ⚠️」，由使用者決定是否定案。

### 契約凍結
`contracts/` 文件標為「已定案」＝契約凍結，此後才適合大規模生成程式碼（見 §5）。

### 修改已定案文件 —— 變更管理流程（重要）
已定案文件**不可直接改**。要改時走以下流程：

1. 把該文件狀態改為 **`修改中`**，等於宣告「這份規格要動了」。
2. **與使用者討論修改方案**（怎麼改、影響哪裡）。
3. 方案確定 / 修改完成後，AI 一次做完三件事：
   - a. **同步更新所有受影響文件**（PRD → ERD → 契約 → 驗收，維持追溯一致，不可只改一處）。
   - b. **在 `changes/change-log.md` 新增一筆變更紀錄**（編號遞增；寫明動機、變更內容、受影響文件清單、是否需重生程式碼）。
   - c. 重跑「定案前檢查」，通過後把狀態改回 **`已定案`**。
4. 以一個 commit 收尾，message 對應變更編號（例：`change(CHG-0003): 調整遙測上報欄位`）。

> 目的：將來既能看到**完整修改過程**（change-log），又能保證**最終功能文件永遠是最新**（PRD/ERD/契約/驗收同步）。

---

## 4.5 逆向規格化（文件化既有專案）

當任務是「把一個**既有實作**的功能/硬體當成規格填進文件」（而非從零開發）時，信任問題與正向相反——
**程式碼才是真相，文件必須被證明忠於它**。因此逆向填入的內容須遵守：

1. **來源可追溯**：每條逆向填入的規格都要標出處（哪個原始檔/文件），讓人可抽查。
2. **審核閘（重要）**：逆向來的文件**預設狀態 `審核中`**、檔首註「來源：逆向萃取，待核」。
   **AI 不可自行標 `已定案`**（呼應 §4 升級權限）——須懂專案的人核對後才升。
3. **覆蓋率矩陣**：在 `charter/reverse-spec-provenance.md` 建立「原始碼項目 → 文件位置」對應表，露出缺口以證明完整性。
4. **獨立對抗式複核**：以獨立一輪（另一個 agent 或人）反向查「無臆造（文件有、碼無）、無遺漏（碼有、文件無）」，差異記入 provenance。

> **真相優先序（僅逆向萃取階段）**：as-built 程式碼 > 註解/檔頭 > 舊設計文件；三者衝突時以**實際執行的程式碼**為準
> （常見坑：註解/檔頭描述的是被撤銷的舊設計）。
> ⚠️ 一旦簽核升 `已定案`，即切回正向模式——文件/契約才是真相（鐵則 1、6），此後改功能先改文件。

**執行時逐步依 `charter/reverse-spec-checklist.md`（操作步驟）。** 全程記錄於 `charter/reverse-spec-provenance.md`。
最強驗證是「往返再生測試」（只靠文件重生程式碼並跑原驗收），成本高、非必需，有能力時再做。

---

## 5. 生成 / 重生程式碼

**前提**：
- 相關 `contracts/` 已定案（見 §4）。
- **建置/測試環境就緒**（見下「環境就緒門檻」）——文件與純邏輯可先生成，但**編譯／跑測試／燒錄前**必須環境就緒。

**流程**：
1. 只讀 `requirements/` + `contracts/` + `acceptance/`。
2. 生成 `src/`（軟體）與韌體邏輯。
3. 跑 `acceptance/software/` 的測試；全數通過才算完成。硬體則列出對應的人工量測項給使用者。
4. 一次生成 = 一個 commit。

**重建指令**（使用者可能會這樣說）：
> 「請只讀取 requirements/、contracts/、acceptance/，重新生成 src/ 與韌體，並通過 acceptance/ 內所有測試。」
收到此類指令時，**先刪除或忽略 `src/` 舊內容的影響**，純粹依文件重生。

### 環境就緒門檻 (Environment Readiness)
生成/重生「文件與純邏輯」可先做；但**編譯、跑測試、燒錄前**，環境必須就緒：
1. 依已定案的技術棧 ADR 推導所需工具鏈（SDK、編譯器、RTOS、runtime、DB、燒錄器…）。
2. 核對 `ops/environment.md`「工具鏈就緒清單」：**缺項 → 停下來，提供安裝清單（官方連結 + 版本 + 驗證指令），不得假裝環境已就緒**。
3. **安裝政策**（詳見 `ops/environment.md`）：**AI 不擅自安裝**；只給連結/步驟/驗證指令，套件管理器安裝須使用者明確同意才代跑、不靜默安裝。
4. **「可生成程式碼」≠「可建置/驗證程式碼」**：缺工具時程式碼可生成，但**不得回報「建置/測試通過」**，須明講「跳過：工具鏈未安裝」。

**觸發時機總表**
| 時機 | 動作 |
|------|------|
| 技術棧 ADR 定案 | 在 `ops/environment.md` 播種工具鏈清單 + 提醒需安裝 |
| §5 生成程式碼前 | 環境就緒門檻檢查；缺項則提供安裝清單 |
| 首次要編譯/跑測試 | 驗證版本、更新就緒狀態；未就緒不謊報通過 |
| 硬體 bring-up | 提醒燒錄器/驅動（如 XDS110 VCP、UniFlash）與實體板需求 |

### 契約變更後的程式碼同步
- **文件優先**：功能改動一律先改文件，再更新程式碼（§1 鐵則 6）。不允許程式碼偷跑。
- **更新策略**：小改用**局部更新**（只改受影響的程式碼）；累積較多或懷疑漂移時，做一次**全量重生**驗證。
- **同步判定靠測試**：契約改 → 先更新 `acceptance/` 對應測試 → 跑測試，全過才算「程式碼已同步」。
- **自動防護**：本倉庫裝了 pre-commit hook（見 §0.5 安裝），commit 前自動跑 `acceptance/run-tests.sh`；
  沒過就擋下 commit，從機制上防止「契約變了但程式碼沒跟上」。測試指令集中維護在 `acceptance/run-tests.sh`。
- **跳過 ≠ 通過**：`run-tests.sh` 偵測不到工具鏈時應**優雅跳過並 `exit 0`**（不擋 commit），但輸出須明示「**跳過 ≠ 通過**」；工具鏈就緒後自動開始真正執行，避免使用者誤以為綠燈。
- 每次同步結果記到 `changes/change-log.md` 的「是否需重生程式碼」欄。

---

## 6. Commit 慣例

- 每次「改文件」或「重新生成」都獨立 commit。
- message 說明改了哪份文件／為何重生（例：`feat(contracts): 新增裝置設定 API` 或 `chore: 依契約重生 src/`）。
- 不需要在文件內寫版本號——`git log` 就是版本史。
- commit 前 pre-commit hook 會自動跑 acceptance 測試（見 §0.5、§5）；請勿隨意用 `--no-verify` 跳過。

---

## 6.5 輔助文件的使用
- **詞彙表**：命名與用語以 `charter/glossary.md` 為準；遇到新的重要名詞就補一列。
- **完成的定義**：回報「完成」前，對照 `charter/definition-of-done.md` 逐項確認。
- **風險**：發現風險或其變化，記到 `charter/risk-register.md`。
- **環境/機密**：需要設定或金鑰時看 `ops/environment.md`；絕不 commit 機密（鐵則 7）。
- **參考資料**：`references/` 是輸入素材（指向 G drive，非真相）。**`references/registry.md` 的登錄表由你（Claude）自動維護** —— 讀取參考目錄或使用者提供檔案後，自動新增/更新對應 REF 列；Base（路徑）由使用者設定。你可讀該 Base 下 `references\` 目錄樹全部內容作分析參考。
  - **逐行判斷 Base**：含角括號 `<...>` 佔位符＝未設定；具體路徑（無 `<>`）＝已設定，**直接去讀**。只要有任一 Base 是具體路徑就讀它，**別因其他 Base 行仍是佔位符、或範例 REF 列還在，就誤判整個 references 未設定**。首次真實登錄時清掉未用的 BASE 佔位行與範例列。詳見 `references/README.md`。

---

## 7. 你常見的動作清單

- 使用者講一個新想法 → 幫他寫進 PRD（給 ID）→ 提醒同步 ERD／acceptance。
- 使用者要「定案某個契約」→ 確認內容、必要時補 ADR、由使用者升級狀態。
- 使用者說「生成/重生」→ 依 §5 執行。
- 使用者問「這個專案現在到哪了」→ 看各文件 `狀態:` 與 `charter/open-questions.md`。
- **主動提示「這步我可以做」**：凡可自動化的步驟（套件安裝、跑測試、產生/重生檔、git 操作、查驗環境…），主動告訴使用者可請你代勞，別讓使用者手動做你能做的事；對外/破壞性動作仍先徵得同意。
