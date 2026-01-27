-- Percentage of trips by rider type (member vs casual)
SELECT 
  rt."RiderTypeName" AS "Rider Type", 
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS "% of Trips"
FROM "RIDE" r
JOIN "RIDER_TYPE" rt 
  ON rt."RiderTypeID" = r."RiderTypeID"
GROUP BY rt."RiderTypeName"
ORDER BY "% of Trips" DESC;

-- Percentage of trips by bike type (electric v classic)
SELECT 
  bt."BikeTypeName" AS "Bike Type", 
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS "% of Trips"
FROM "RIDE" r
JOIN "BIKE_TYPE" bt
  ON bt."BikeTypeID" = r."BikeTypeID"
GROUP BY bt."BikeTypeName"
ORDER BY "% of Trips" DESC;

-- Average Trip Duration for different rider types
SELECT 
  rt."RiderTypeName" AS "Rider Type", 
  ROUND(AVG("RideDurationMin")::numeric,2) AS "Average Trip Duration"
FROM "RIDE" r
JOIN "RIDER_TYPE" rt 
  ON rt."RiderTypeID" = r."RiderTypeID"
GROUP BY rt."RiderTypeName"
ORDER BY "Average Trip Duration" DESC;

-- Average Trip Duration for different bike types
SELECT 
  bt."BikeTypeName" AS "Bike Type", 
  ROUND(AVG("RideDurationMin")::numeric,2) AS "Average Trip Duration"
FROM "RIDE" r
JOIN "BIKE_TYPE" bt 
  ON bt."BikeTypeID" = r."BikeTypeID"
GROUP BY bt."BikeTypeName"
ORDER BY "Average Trip Duration" DESC;

-- Percentage of trips on specific days of the week
SELECT
  TO_CHAR("StartedAt", 'FMDay') AS "Day Of The Week",
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS "% of Trips"
FROM "RIDE"
GROUP BY "Day Of The Week"
ORDER BY "% of Trips" DESC;

-- Revenue by rider type vs Percentage of trips by rider

WITH PrcntOfTrips AS (
  SELECT 
    rt."RiderTypeName" AS "Rider Type", 
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS "% of Trips"
  FROM "RIDE" r
  JOIN "RIDER_TYPE" rt 
    ON rt."RiderTypeID" = r."RiderTypeID"
  GROUP BY rt."RiderTypeName"
  ORDER BY "% of Trips" DESC
  ), 
  TripRevenue AS (
    SELECT 
      rt."RiderTypeName" as "Rider Type",
      ROUND(
      (
        100.0 * SUM(COALESCE(r."RidePrice", 0))
        / NULLIF(SUM(SUM(COALESCE(r."RidePrice", 0))) OVER (), 0)
      )::numeric,
      2
    ) AS "% of Revenue"
    FROM "RIDE" r 
    JOIN "RIDER_TYPE" rt 
      ON r."RiderTypeID" = rt."RiderTypeID"
    GROUP BY "Rider Type"
    ORDER BY "% of Revenue" DESC
    )
SELECT "% of Revenue", "% of Trips", tr."Rider Type"
FROM TripRevenue tr
JOIN PrcntOfTrips pt
  ON tr."Rider Type" = pt."Rider Type";

-- ^ THIS QUERY TELLS US: While members complete ~80% of trips the revenue earned from them is only 13% greater than casual.

-- Average Trip Duration for different bike types vs Average revenue earned for different bike types
WITH AvgTripDuration AS (
  SELECT 
    bt."BikeTypeName" AS "Bike Type", 
    ROUND(AVG("RideDurationMin")::numeric,2) AS "Average Trip Duration"
  FROM "RIDE" r
  JOIN "BIKE_TYPE" bt 
    ON bt."BikeTypeID" = r."BikeTypeID"
  GROUP BY bt."BikeTypeName"
  ORDER BY "Average Trip Duration" DESC
),
AvgRevEarnedbyBikeType AS (
  SELECT 
    bt."BikeTypeName" AS "Bike Type",
    ROUND(AVG("RidePrice")::numeric, 2) AS "Average Revenue Earned"
  FROM "RIDE" r
  JOIN "BIKE_TYPE" bt 
    ON r."BikeTypeID" = bt."BikeTypeID"
  GROUP BY "Bike Type"
  ORDER BY "Average Revenue Earned" DESC
)
SELECT arebt."Bike Type", "Average Revenue Earned", "Average Trip Duration"
FROM AvgTripDuration atd
JOIN AvgRevEarnedbyBikeType arebt
  ON atd."Bike Type" = arebt."Bike Type";

