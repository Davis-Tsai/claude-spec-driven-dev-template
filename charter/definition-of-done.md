---
文件: 完成的定義 (Definition of Done, DoD)
狀態: 進行中
---

# 完成的定義 (Definition of Done)

> 「做完」不只是程式跑得動。一項需求/任務要**同時滿足**以下條件才算完成。
> AI 在回報「完成」前，應對照此清單逐項確認。可依專案調整。

## 軟體功能
- [ ] 對應 PRD 需求有唯一 ID，且 `ERD.md` 追溯表已更新
- [ ] 相關契約（schema / API）已定案且彼此一致
- [ ] `acceptance/software/` 測試已撰寫，且全數通過
- [ ] 程式碼由文件生成，未繞過文件手改（或手改已回補文件，見鐵則 6）
- [ ] 已 commit，且 pre-commit 測試通過
- [ ] 若改動的是「已定案」文件，`changes/change-log.md` 已記錄一筆

## 硬體功能
- [ ] 硬體契約（腳位 / 時序 / 電氣 / BOM）已定案且一致
- [ ] 對應的人工量測程序（`acceptance/hardware/`）已定義
- [ ] 實測值已記錄，且符合合格標準
- [ ] 實體設計檔（原理圖 / PCB）已存入 `hardware_build/`

## 通用
- [ ] 用語符合 `charter/glossary.md`
- [ ] 相關風險已檢視（`charter/risk-register.md`）
