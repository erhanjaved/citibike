# Citi Bike Ride Analysis - September 2024
## By Prashant Chopra & Erhan Asad Javed
 
## Project Overview
This is an ongoing **data analytics project** analyzing Citi Bike ride data for September 2024. The goal of the project is to understand rider behavior, bike usage patterns, and pricing outcomes through a full analytics workflow that spans **data engineering, SQL analysis, and data visualization**.

The project begins with downloading and cleaning raw Citi Bike trip data using Python, followed by feature engineering such as ride duration and per-ride price computation based on Citi Bike’s pricing rules. The cleaned dataset is then prepared for downstream analysis using **SQL** for querying and aggregation, and **Tableau** for interactive dashboards and visual insights.

Riders are classified as:
- **Casual riders**: users paying for a single ride or a day pass  
- **Members**: users subscribed to a Citi Bike membership  

As the project progresses, additional analysis will be conducted to explore temporal usage patterns, revenue implications, and differences between casual and member riding behavior.



## Data Source
The raw data consists of Citi Bike trip data files hosted on [Google Drive](https://drive.google.com/drive/folders/1NhBgnlArKS2kISV44Cl-JOexjGWTcllE). Each file represents a portion of September 2024 ride activity.

**Raw files:**
- `202409-citibike-tripdata_1.csv`
- `202409-citibike-tripdata_2.csv`
- `202409-citibike-tripdata_3.csv`
- `202409-citibike-tripdata_4.csv`
- `202409-citibike-tripdata_5.csv`

The files are downloaded programmatically using `gdown` and stored locally in a `data/` directory. Run the `data.ipynb` file to locally save the data (not added in the repository due to it exceeding the storage capacity.)


## Data Cleaning & Preprocessing
The following preprocessing steps are applied:

1. **Combine datasets**
   - All September CSV files are concatenated into a single DataFrame.

2. **Datetime conversion**
   - `started_at` and `ended_at` are converted to pandas datetime objects.

3. **Ride duration**
   - `ride_duration_min` is computed as the difference between `ended_at` and `started_at`.
   - Ride durations are **rounded up to the nearest minute** to match Citi Bike billing rules.

4. **Missing data**
   - All rows containing **any null values** are removed.


## Pricing Logic
A per-ride price is computed based on Citi Bike’s pricing rules.

### Rider Types
- **Casual**: single ride or day pass  
- **Member**: annual membership  

### Included Ride Time
| Rider Type | Included Minutes |
|-----------|------------------|
| Casual    | 30 minutes       |
| Member    | 45 minutes       |

### Per-Minute Rates
- **Classic / Docked bikes**
  - $0/min within included time
- **Electric bikes**
  - Casual: $0.38/min  
  - Member: $0.25/min  

### Overage Charges
- Any minute beyond the included ride time incurs an **additional $0.25/min**
- Applies to **both classic and electric bikes**
- Overage minutes are charged at:  
  **base rate + $0.25**


### Key Columns
- `ride_id`
- `rideable_type`
- `started_at`
- `ended_at`
- `start_station_name`
- `start_station_id`
- `end_station_name`
- `end_station_id`
- `member_casual`
- `ride_duration_min`
- `ride_minutes_charged`
- `ride_price`

The dataset contains no missing values and is ready for analysis.


## Tools and Libraries
- Python
- pandas
- numpy
- gdown

