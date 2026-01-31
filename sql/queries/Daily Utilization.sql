-- Revenue by hour of day and Number of trips by hour of day
SELECT EXTRACT(HOUR FROM r."StartedAt")::int as "Hour", SUM("RidePrice") "Revenue/Hour", COUNT(*) "Trips/Hour"
FROM "RIDE" r
GROUP BY "Hour"
ORDER BY "Revenue/Hour" DESC;

-- Avg revenue per trip per hour
SELECT
  EXTRACT(HOUR FROM r."StartedAt")::int AS "Hour",
  ROUND(
    (SUM(COALESCE(r."RidePrice", 0)) / NULLIF(COUNT(*), 0))::numeric,
    2
  ) AS "Avg Revenue per Trip"
FROM "RIDE" r
GROUP BY "Hour"
ORDER BY "Hour";

-- Trips per hour by rider type and Revenue by rider type
SELECT
  EXTRACT(HOUR FROM r."StartedAt")::int AS "Hour",
  COUNT(*) FILTER (WHERE rt."RiderTypeName" = 'member') AS "Member Trips",
  COUNT(*) FILTER (WHERE rt."RiderTypeName" = 'casual') AS "Casual Trips",
  SUM(r."RidePrice") FILTER (WHERE rt."RiderTypeName" = 'member') AS "Member Revenue",
  SUM(r."RidePrice") FILTER (WHERE rt."RiderTypeName" = 'casual') AS "Casual Revenue"
FROM "RIDE" r
JOIN "RIDER_TYPE" rt
  ON rt."RiderTypeID" = r."RiderTypeID"
GROUP BY "Hour"
ORDER BY "Hour";

-- Trips + Revenue + Avg revenue per trip per hour (by rider type)
SELECT
  EXTRACT(HOUR FROM r."StartedAt")::int AS "Hour",
  COUNT(*) FILTER (WHERE rt."RiderTypeName" = 'member') AS "Member Trips",
  COUNT(*) FILTER (WHERE rt."RiderTypeName" = 'casual') AS "Casual Trips",
  SUM(COALESCE(r."RidePrice", 0)) FILTER (WHERE rt."RiderTypeName" = 'member') AS "Member Revenue",
  SUM(COALESCE(r."RidePrice", 0)) FILTER (WHERE rt."RiderTypeName" = 'casual') AS "Casual Revenue",
  ROUND(
    (
      SUM(COALESCE(r."RidePrice", 0)) FILTER (WHERE rt."RiderTypeName" = 'member')
      / NULLIF(COUNT(*) FILTER (WHERE rt."RiderTypeName" = 'member'), 0)
    )::numeric,
    2
  ) AS "Member Avg Rev/Trip",
  ROUND(
    (
      SUM(COALESCE(r."RidePrice", 0)) FILTER (WHERE rt."RiderTypeName" = 'casual')
      / NULLIF(COUNT(*) FILTER (WHERE rt."RiderTypeName" = 'casual'), 0)
    )::numeric,
    2
  ) AS "Casual Avg Rev/Trip"
FROM "RIDE" r
JOIN "RIDER_TYPE" rt
  ON rt."RiderTypeID" = r."RiderTypeID"
GROUP BY "Hour"
ORDER BY "Hour";

-- Trips per hour by bike type, Revenue per hour by Bike type 
SELECT
  EXTRACT(HOUR FROM r."StartedAt")::int AS "Hour",
  COUNT(*) FILTER (WHERE bt."BikeTypeName" = 'classic_bike') AS "Classic Trips",
  COUNT(*) FILTER (WHERE bt."BikeTypeName" = 'electric_bike') AS "Electric Trips",
  SUM(r."RidePrice") FILTER (WHERE bt."BikeTypeName" = 'classic_bike') AS "Classic Trips Revenue",
  SUM(r."RidePrice") FILTER (WHERE bt."BikeTypeName" = 'electric_bike') AS "Electric Trips Revenue"
FROM "RIDE" r
JOIN "BIKE_TYPE" bt
  ON bt."BikeTypeID" = r."BikeTypeID"
GROUP BY "Hour"
ORDER BY "Hour";

-- Avg trips on weekday vs weekend by rider type
WITH labeled AS (
  SELECT
    r."StartedAt"::date AS day,
    rt."RiderTypeName"  AS rider_type,
    CASE
      WHEN EXTRACT(ISODOW FROM r."StartedAt") BETWEEN 1 AND 5 THEN 'Weekday'
      ELSE 'Weekend'
    END AS day_type
  FROM "RIDE" r
  JOIN "RIDER_TYPE" rt
    ON rt."RiderTypeID" = r."RiderTypeID"
),
counts_per_day AS (
  SELECT
    day_type,
    rider_type,
    day,
    COUNT(*) AS rides_per_day
  FROM labeled
  GROUP BY day_type, rider_type, day
)
SELECT
  day_type AS "Weekday/Weekend",
  rider_type AS "Rider Type",
  AVG(rides_per_day)::numeric(10,2) AS "Avg Trips per Day"
FROM counts_per_day
GROUP BY day_type, rider_type
ORDER BY rider_type, day_type;

-- Avg trips + avg revenue on weekday vs weekend by rider type
WITH labeled AS (
  SELECT
    r."StartedAt"::date AS day,
    rt."RiderTypeName"  AS rider_type,
    CASE
      WHEN EXTRACT(ISODOW FROM r."StartedAt") BETWEEN 1 AND 5 THEN 'Weekday'
      ELSE 'Weekend'
    END AS day_type,
    COALESCE(r."RidePrice", 0) AS ride_price
  FROM "RIDE" r
  JOIN "RIDER_TYPE" rt
    ON rt."RiderTypeID" = r."RiderTypeID"
),
daily AS (
  SELECT
    day_type,
    rider_type,
    day,
    COUNT(*) AS rides_per_day,
    SUM(ride_price) AS revenue_per_day
  FROM labeled
  GROUP BY day_type, rider_type, day
)
SELECT
  day_type   AS "Weekday/Weekend",
  rider_type AS "Rider Type",
  AVG(rides_per_day)::numeric(10,2)    AS "Avg Trips per Day",
  AVG(revenue_per_day)::numeric(10,2)  AS "Avg Revenue per Day",
  ROUND((AVG(revenue_per_day) / NULLIF(AVG(rides_per_day), 0))::numeric, 2) AS "Avg Revenue per Trip"
FROM daily
GROUP BY day_type, rider_type
ORDER BY rider_type, day_type;

-- Avg trips on weekday vs weekend by bike type
WITH labeled AS (
  SELECT
    r."StartedAt"::date AS day,
    bt."BikeTypeName"   AS bike_type,
    CASE
      WHEN EXTRACT(ISODOW FROM r."StartedAt") BETWEEN 1 AND 5 THEN 'Weekday'
      ELSE 'Weekend'
    END AS day_type
  FROM "RIDE" r
  JOIN "BIKE_TYPE" bt
    ON bt."BikeTypeID" = r."BikeTypeID"
),
counts_per_day AS (
  SELECT
    day_type,
    bike_type,
    day,
    COUNT(*) AS rides_per_day
  FROM labeled
  GROUP BY day_type, bike_type, day
)
SELECT
  day_type  AS "Weekday/Weekend",
  bike_type AS "Bike Type",
  AVG(rides_per_day)::numeric(10,2) AS "Avg Trips per Day"
FROM counts_per_day
GROUP BY day_type, bike_type
ORDER BY bike_type, day_type;