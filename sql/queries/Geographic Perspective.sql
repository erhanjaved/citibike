-- Trips per station (start v end)
WITH start_station_counts AS (
  SELECT "StationName" as "Start station name", COUNT("StationName") as "Start Station Freq"
  FROM "RIDE" r
  JOIN "STATION" s 
    ON r."StartStationID" = s."StationID"
  GROUP BY "StationName"
),
end_station_counts AS (
  SELECT "StationName" as "End station name", COUNT("StationName") as "End Station Freq"
  FROM "RIDE" r
  JOIN "STATION" s 
    ON r."EndStationID" = s."StationID"
  GROUP BY "StationName"
)
SELECT s."Start station name" as "Station Name", s."Start Station Freq" as "# of Rides Started Here", e."End Station Freq" as "# of Rides Ended Here"
FROM start_station_counts s
JOIN end_station_counts e
  ON s."Start station name" = e."End station name"
ORDER BY "Start Station Freq" DESC;


-- Pick up stations v Drop of Stations in the Afternoon
SELECT
  s."Station",
  "Departing Frequency",
  "Arrival Frequency"
FROM (
  SELECT
    s."StationName" AS "Station",
    COUNT(*) AS "Departing Frequency",
    CASE
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 4 AND EXTRACT(HOUR FROM r."StartedAt") < 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 10 AND EXTRACT(HOUR FROM r."StartedAt") < 15 THEN 'Afternoon'
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 15 AND EXTRACT(HOUR FROM r."StartedAt") < 18 THEN 'Evening'
      ELSE 'Night'
    END AS "Time_of_Day"
  FROM "RIDE" r
  JOIN "STATION" s ON r."StartStationID" = s."StationID"
  GROUP BY s."StationName", "Time_of_Day"
) t, (
  SELECT
    s."StationName" AS "Station",
    COUNT(*) AS "Arrival Frequency",
    CASE
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 4 AND EXTRACT(HOUR FROM r."EndedAt") < 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 10 AND EXTRACT(HOUR FROM r."EndedAt") < 15 THEN 'Afternoon'
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 15 AND EXTRACT(HOUR FROM r."EndedAt") < 18 THEN 'Evening'
      ELSE 'Night'
    END AS "Time_of_Day"
  FROM "RIDE" r
  JOIN "STATION" s ON r."EndStationID" = s."StationID"
  GROUP BY s."StationName", "Time_of_Day"
) s
WHERE t."Time_of_Day" = 'Afternoon' AND s."Time_of_Day" = 'Afternoon';


-- Pick up stations v Drop of Stations in the Morning
SELECT
  s."Station",
  "Departing Frequency",
  "Arrival Frequency"
FROM (
  SELECT
    s."StationName" AS "Station",
    COUNT(*) AS "Departing Frequency",
    CASE
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 4 AND EXTRACT(HOUR FROM r."StartedAt") < 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 10 AND EXTRACT(HOUR FROM r."StartedAt") < 15 THEN 'Afternoon'
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 15 AND EXTRACT(HOUR FROM r."StartedAt") < 18 THEN 'Evening'
      ELSE 'Night'
    END AS "Time_of_Day"
  FROM "RIDE" r
  JOIN "STATION" s ON r."StartStationID" = s."StationID"
  GROUP BY s."StationName", "Time_of_Day"
) t, (
  SELECT
    s."StationName" AS "Station",
    COUNT(*) AS "Arrival Frequency",
    CASE
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 4 AND EXTRACT(HOUR FROM r."EndedAt") < 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 10 AND EXTRACT(HOUR FROM r."EndedAt") < 15 THEN 'Afternoon'
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 15 AND EXTRACT(HOUR FROM r."EndedAt") < 18 THEN 'Evening'
      ELSE 'Night'
    END AS "Time_of_Day"
  FROM "RIDE" r
  JOIN "STATION" s ON r."EndStationID" = s."StationID"
  GROUP BY s."StationName", "Time_of_Day"
) s
WHERE t."Time_of_Day" = 'Morning' AND s."Time_of_Day" = 'Morning';


-- Pick up stations v Drop of Stations in the Evening
SELECT
  s."Station",
  "Departing Frequency",
  "Arrival Frequency"
FROM (
  SELECT
    s."StationName" AS "Station",
    COUNT(*) AS "Departing Frequency",
    CASE
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 4 AND EXTRACT(HOUR FROM r."StartedAt") < 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 10 AND EXTRACT(HOUR FROM r."StartedAt") < 15 THEN 'Afternoon'
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 15 AND EXTRACT(HOUR FROM r."StartedAt") < 18 THEN 'Evening'
      ELSE 'Night'
    END AS "Time_of_Day"
  FROM "RIDE" r
  JOIN "STATION" s ON r."StartStationID" = s."StationID"
  GROUP BY s."StationName", "Time_of_Day"
) t, (
  SELECT
    s."StationName" AS "Station",
    COUNT(*) AS "Arrival Frequency",
    CASE
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 4 AND EXTRACT(HOUR FROM r."EndedAt") < 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 10 AND EXTRACT(HOUR FROM r."EndedAt") < 15 THEN 'Afternoon'
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 15 AND EXTRACT(HOUR FROM r."EndedAt") < 18 THEN 'Evening'
      ELSE 'Night'
    END AS "Time_of_Day"
  FROM "RIDE" r
  JOIN "STATION" s ON r."EndStationID" = s."StationID"
  GROUP BY s."StationName", "Time_of_Day"
) s
WHERE t."Time_of_Day" = 'Evening' AND s."Time_of_Day" = 'Evening';


-- Pick up stations v Drop of Stations in the Night
SELECT
  s."Station",
  "Departing Frequency",
  "Arrival Frequency"
FROM (
  SELECT
    s."StationName" AS "Station",
    COUNT(*) AS "Departing Frequency",
    CASE
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 4 AND EXTRACT(HOUR FROM r."StartedAt") < 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 10 AND EXTRACT(HOUR FROM r."StartedAt") < 15 THEN 'Afternoon'
      WHEN EXTRACT(HOUR FROM r."StartedAt") >= 15 AND EXTRACT(HOUR FROM r."StartedAt") < 18 THEN 'Evening'
      ELSE 'Night'
    END AS "Time_of_Day"
  FROM "RIDE" r
  JOIN "STATION" s ON r."StartStationID" = s."StationID"
  GROUP BY s."StationName", "Time_of_Day"
) t, (
  SELECT
    s."StationName" AS "Station",
    COUNT(*) AS "Arrival Frequency",
    CASE
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 4 AND EXTRACT(HOUR FROM r."EndedAt") < 10 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 10 AND EXTRACT(HOUR FROM r."EndedAt") < 15 THEN 'Afternoon'
      WHEN EXTRACT(HOUR FROM r."EndedAt") >= 15 AND EXTRACT(HOUR FROM r."EndedAt") < 18 THEN 'Evening'
      ELSE 'Night'
    END AS "Time_of_Day"
  FROM "RIDE" r
  JOIN "STATION" s ON r."EndStationID" = s."StationID"
  GROUP BY s."StationName", "Time_of_Day"
) s
WHERE t."Time_of_Day" = 'Night' AND s."Time_of_Day" = 'Night';