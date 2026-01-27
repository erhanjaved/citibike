BEGIN;

-- Drop in dependency order
DROP TABLE IF EXISTS ride;
DROP TABLE IF EXISTS station;
DROP TABLE IF EXISTS rider_type;
DROP TABLE IF EXISTS bike_type;

-- 1) BIKE_TYPE
CREATE TABLE bike_type (
  bike_type_id   BIGSERIAL PRIMARY KEY,
  bike_type_name TEXT NOT NULL UNIQUE
);

INSERT INTO bike_type (bike_type_name)
SELECT DISTINCT rideable_type
FROM "Citibike1"
WHERE rideable_type IS NOT NULL
ON CONFLICT (bike_type_name) DO NOTHING;

-- 2) RIDER_TYPE
CREATE TABLE rider_type (
  rider_type_id   BIGSERIAL PRIMARY KEY,
  rider_type_name TEXT NOT NULL UNIQUE
);

INSERT INTO rider_type (rider_type_name)
SELECT DISTINCT member_casual
FROM "Citibike1"
WHERE member_casual IS NOT NULL
ON CONFLICT (rider_type_name) DO NOTHING;

-- 3) STATION
-- Use TEXT for station_id to avoid decimal/float issues (e.g., '6816.07')
CREATE TABLE station (
  station_id        TEXT PRIMARY KEY,
  station_name      TEXT,
  station_latitude  DOUBLE PRECISION,
  station_longitude DOUBLE PRECISION
);

INSERT INTO station (station_id, station_name, station_latitude, station_longitude)
SELECT
  s.station_id,
  MAX(s.station_name)      AS station_name,
  MAX(s.station_latitude)  AS station_latitude,
  MAX(s.station_longitude) AS station_longitude
FROM (
  SELECT
    start_station_id::text AS station_id,
    start_station_name     AS station_name,
    start_lat::double precision AS station_latitude,
    start_lng::double precision AS station_longitude
  FROM "Citibike1"
  WHERE start_station_id IS NOT NULL

  UNION ALL

  SELECT
    end_station_id::text AS station_id,
    end_station_name     AS station_name,
    end_lat::double precision AS station_latitude,
    end_lng::double precision AS station_longitude
  FROM "Citibike1"
  WHERE end_station_id IS NOT NULL
) s
GROUP BY s.station_id
ON CONFLICT (station_id) DO NOTHING;

-- 4) RIDE (fact table)
CREATE TABLE ride (
  ride_id            TEXT PRIMARY KEY,
  started_at         TIMESTAMP NOT NULL,
  ended_at           TIMESTAMP NOT NULL,
  ride_duration_min  DOUBLE PRECISION,

  start_station_id   TEXT,
  end_station_id     TEXT,

  bike_type_id       BIGINT NOT NULL REFERENCES bike_type(bike_type_id),
  rider_type_id      BIGINT NOT NULL REFERENCES rider_type(rider_type_id),

  CONSTRAINT fk_ride_start_station
    FOREIGN KEY (start_station_id) REFERENCES station(station_id),

  CONSTRAINT fk_ride_end_station
    FOREIGN KEY (end_station_id) REFERENCES station(station_id)
);

INSERT INTO ride (
  ride_id, started_at, ended_at, ride_duration_min,
  start_station_id, end_station_id,
  bike_type_id, rider_type_id
)
SELECT
  r.ride_id::text,
  r.started_at::timestamp,
  r.ended_at::timestamp,
  r.ride_duration_min::double precision,
  r.start_station_id::text,
  r.end_station_id::text,
  bt.bike_type_id,
  rt.rider_type_id
FROM "Citibike1" r
JOIN bike_type  bt ON bt.bike_type_name  = r.rideable_type
JOIN rider_type rt ON rt.rider_type_name = r.member_casual
ON CONFLICT (ride_id) DO NOTHING;

COMMIT;



