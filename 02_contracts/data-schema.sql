-- =====================================================================
-- 資料結構契約 (Data Schema Contract)
-- 版本: 0.1.0   狀態: 草稿   最後更新: 2026-09-07
-- 說明: 此檔為「決定性錨點」。程式碼中的資料模型必須與此檔完全一致。
--       重建程式碼時，以此檔為準生成 ORM/migration。
-- =====================================================================

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
