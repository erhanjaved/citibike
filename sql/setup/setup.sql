-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.BIKE_TYPE (
  BikeTypeID bigint NOT NULL DEFAULT nextval('bike_type_bike_type_id_seq'::regclass),
  BikeTypeName text NOT NULL UNIQUE,
  CONSTRAINT BIKE_TYPE_pkey PRIMARY KEY (BikeTypeID)
);
CREATE TABLE public.RIDE (
  RideID text NOT NULL,
  StartedAt timestamp without time zone NOT NULL,
  EndedAt timestamp without time zone NOT NULL,
  RideDurationMin double precision,
  StartStationID text,
  EndStationID text,
  BikeTypeID bigint NOT NULL,
  RiderTypeID bigint NOT NULL,
  RideMinsCharged double precision,
  RidePrice double precision,
  CONSTRAINT RIDE_pkey PRIMARY KEY (RideID),
  CONSTRAINT FK_RIDE_BIKE_TYPE FOREIGN KEY (BikeTypeID) REFERENCES public.BIKE_TYPE(BikeTypeID),
  CONSTRAINT FK_RIDE_RIDER_TYPE FOREIGN KEY (RiderTypeID) REFERENCES public.RIDER_TYPE(RiderTypeID),
  CONSTRAINT FK_RIDE_START_STATION FOREIGN KEY (StartStationID) REFERENCES public.STATION(StationID),
  CONSTRAINT FK_RIDE_END_STATION FOREIGN KEY (EndStationID) REFERENCES public.STATION(StationID)
);
CREATE TABLE public.RIDER_TYPE (
  RiderTypeID bigint NOT NULL DEFAULT nextval('rider_type_rider_type_id_seq'::regclass),
  RiderTypeName text NOT NULL UNIQUE,
  CONSTRAINT RIDER_TYPE_pkey PRIMARY KEY (RiderTypeID)
);
CREATE TABLE public.STATION (
  StationID text NOT NULL,
  StationName text,
  StationLatitude double precision,
  StationLongitude double precision,
  CONSTRAINT STATION_pkey PRIMARY KEY (StationID)
);
CREATE TABLE public.citibike1 (
  ride_id text,
  rideable_type text,
  started_at timestamp with time zone,
  ended_at timestamp with time zone,
  start_station_name text,
  start_station_id text,
  end_station_name text,
  end_station_id text,
  start_lat double precision,
  start_lng double precision,
  end_lat double precision,
  end_lng double precision,
  member_casual text,
  ride_duration_min double precision,
  ride_minutes_charged bigint,
  ride_price double precision
);