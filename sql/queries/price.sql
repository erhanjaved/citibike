-- Inclusion of the price column

BEGIN;

-- 1) Add the missing columns to "RIDE"
ALTER TABLE public."RIDE"
  ADD COLUMN IF NOT EXISTS "RideMinsCharged" DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS "RidePrice"       DOUBLE PRECISION;

-- 2) Backfill them from the staging table citibike1
UPDATE public."RIDE" r
SET
  "RideMinsCharged" = c.ride_minutes_charged::double precision,
  "RidePrice"       = c.ride_price::double precision
FROM public.citibike1 c
WHERE r."RideID" = c.ride_id::text;

COMMIT;

-- Check:
SELECT
  COUNT(*) AS total_rides,
  COUNT("RideMinsCharged") AS mins_filled,
  COUNT("RidePrice") AS price_filled
FROM public."RIDE";

