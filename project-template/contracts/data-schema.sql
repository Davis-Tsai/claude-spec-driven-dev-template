-- =====================================================================
-- 資料結構契約 (Data Schema Contract)
-- 狀態: 草稿
-- 說明: 此檔為「決定性錨點」。程式碼中的資料模型必須與此檔完全一致。
--       重建程式碼時，以此檔為準生成 ORM/migration。
-- =====================================================================

-- ⚠️ 範例可刪：以下 users/devices/telemetry 為格式示範，開始真實專案時請整段替換成你的資料模型。

CREATE TABLE users (
    id          INTEGER PRIMARY KEY,
    email       TEXT NOT NULL UNIQUE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE devices (
    id          INTEGER PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id),
    serial_no   TEXT NOT NULL UNIQUE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE telemetry (
    id          INTEGER PRIMARY KEY,
    device_id   INTEGER NOT NULL REFERENCES devices(id),
    ts          TIMESTAMP NOT NULL,
    value       REAL NOT NULL
);

CREATE INDEX idx_telemetry_device_ts ON telemetry(device_id, ts);
