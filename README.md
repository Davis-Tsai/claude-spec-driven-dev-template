# 專案開發模板（工作區）

> 這個資料夾是「規格驅動開發模板」的工作區／母版倉庫。

## 怎麼開新專案

可複製的乾淨母版在 **`project-template/`**。開新專案時：

1. 複製整個 `project-template/` 資料夾到你要的位置，改成你的專案名稱。
2. 在複製出來的資料夾開啟 Claude Code。
3. 第一句話輸入：`請依 CLAUDE.md 初始化這個專案`。

`project-template/` 是**自包含**的（含隱藏檔 `.gitignore` / `.gitattributes` / `.githooks/`），
且因為 `.git` 在**外層**、不在 `project-template/` 內，複製出去的資料夾**天生不含 Git 歷史**，
不會污染母版、也不會 push 到錯的 repo。

## 想改進模板本身

直接編輯 `project-template/` 內的檔案並 commit。
細節見 `project-template/README.md` 與 `project-template/CLAUDE.md`。
