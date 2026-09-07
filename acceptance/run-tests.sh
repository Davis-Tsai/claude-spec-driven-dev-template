#!/bin/sh
# =====================================================================
# 驗收測試執行入口 (single source for「如何跑驗收測試」)
# pre-commit hook 會呼叫本檔。
#
# 技術棧定案後（見 charter/open-questions.md Q3），把下面換成實際指令，
# 並確保：測試全過 → exit 0；有失敗 → exit 非 0（pre-commit 才擋得下）。
# 例：  pytest acceptance/        (Python)
#       npm test                  (Node)
#       behave acceptance/software (Gherkin/behave)
# =====================================================================

echo "（尚未設定測試指令）技術棧確定後，請在此填入實際的 acceptance 測試指令。"

# 目前無測試 → 放行（回傳 0），避免早期階段擋住 commit。
exit 0
