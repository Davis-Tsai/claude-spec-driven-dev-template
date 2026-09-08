# 維護指南 (Maintaining this Template)

> 給**模板維護者**看的：如何持續改善本模板，以及既有專案如何吸收改善。
> （這份對「用模板開的新專案」用處不大，可自行刪除。）

## 1. 改善模板的流程
1. 在本 repo 編輯檔案（規則、文件範本、hook…）。
2. `git commit`（訊息說明改了什麼、為什麼）。
3. `git push` 到 GitHub → 範本即更新，之後按「Use this template」的人拿到新版。
4. （建議）重要改善後打版本：`git tag v1.1 && git push --tags`，或用 GitHub Releases，方便追蹤「哪個改善在哪一版」。

> 想更嚴謹可用分支 + PR：改在 feature 分支 → 開 PR → 合併回 `main`。

## 2. 關鍵：既有專案不會自動更新
「Use this template」是**某個時間點的複製**，不是連動。所以模板改善後：
- **之後**建立的新專案 → 自動拿到新版。
- **之前**已建立的專案 → 不會自動變，需**手動同步**（見下）。

## 3. 既有專案如何吸收模板改善
只同步「框架檔」，**不要覆蓋你已填的專案內容**。

- **可安全覆蓋（框架/通用）**：`CLAUDE.md`、`README.md`、`.githooks/`、`.gitignore`、`.gitattributes`、
  `charter/design-decisions.md`、`charter/reverse-spec-checklist.md`、`charter/definition-of-done.md`、`LICENSE`。
- **不要覆蓋（你的專案內容）**：`charter/scope.md`、`requirements/`（PRD/ERD/ADR）、`contracts/`、
  `acceptance/`、`charter/{glossary,open-questions,risk-register}.md`、`changes/change-log.md`、`src/`、`hardware_build/`。

做法：從新版模板把上述「框架檔」複製過去覆蓋，再 `git diff` 確認只動到框架、commit。
（若框架檔曾被你客製，改用 `git diff` 逐項挑要的改動，別整檔蓋掉。）

## 4. 版本相容
- 若某次改善牽動「已定案文件」的規則，於既有專案同步時比照變更管理（見 `CLAUDE.md §4`）。
- 大改可在 commit/Release 註明「破壞性變更」，提醒下游同步時注意。
