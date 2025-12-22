CREATE TABLE events
(
    event_date Date,
    user_id    UInt64,
    event_type String,
    payload    String,
    INDEX idx_event_type event_type TYPE set(100) GRANULARITY 1
)
ENGINE = MergeTree
ORDER BY (event_date, user_id);

