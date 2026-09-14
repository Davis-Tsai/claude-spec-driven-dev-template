---
文件: 參考資料說明 (References — 說明)
狀態: 進行中
---

# 參考資料 (References)

> 撰寫規格時參考的**輸入素材**（datasheet、通訊標準、廠商文件、研究/會議筆記、截圖…）。
> **要填的登錄表在 `references/registry.md`。** 本檔只放規範；實體檔放 Google Drive，**不進 git**。

## 定位與界線（重要）
- **references 是輸入，不是真相。** 專案真相永遠在 `contracts/`。
- **關鍵事實要萃取進 `contracts/` / ADR**（規格不綁死連結或檔案，失效也不影響規格成立）。
- **實體檔放 Google Drive，不進 git**（避免撐大 repo）。

## Drive 放哪裡
- **私人專案 → My Drive**。
- **公司專案 → 必須 Shared Drive**（檔案由團隊擁有；有人離職也不斷鏈，接手者靠團隊權限即可存取）。
- Drive 內依分類建資料夾（`datasheets` / `standards` / `vendor-docs` / `notes` / `captures`…），與 registry 的「分類」對應，視覺管理一致。

## 給 Claude 讀取的方式
- Claude **可讀取登錄之 Base 下 `references\` 目錄樹的所有檔案與子目錄**（授權說明見 `registry.md`）。
- 掛載為本機 `G:\` 路徑即可讀（PDF 也能讀）；**`https://drive.google.com/...` 網址無法直接開**，請用 `G:\` 路徑。
- 為效率：知道是哪一份時直接**指名該檔/該節**；大型 PDF 讀需要的章節，不必整包讀進 context。

## 引用方式
- 在 `requirements/PRD.md`、ADR、`charter/reverse-spec-provenance.md` 需要溯源時，寫「依據 `REF-003`」即可追回來源。

## 誰維護
- **Base（路徑）→ 使用者設定**：Claude 無法得知你的 Drive 路徑/磁碟代號，這行要你填（或 Claude 問你一次）。
- **登錄表（REF 列）→ Claude 自動維護**：Claude 讀取參考目錄、或你把檔案交給它後，會**自動新增/更新對應 REF 列**（id、分類、標題、Base、位置、版本、一句話），你不必手動改表。
- **「自動」的時機**：Claude 是在**為此專案工作時**同步表格（讀參考目錄／收到你給的檔），不是背景常駐監看。若你在對話外把檔案丟進 Drive，下次請 Claude「同步 references」即可補上。
- registry 是**活的索引**：狀態維持「進行中」，**不套用已定案/變更管理那套**（要嚴管的是 `contracts/`）。
