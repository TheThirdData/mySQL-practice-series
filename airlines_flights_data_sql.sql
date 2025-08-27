use airline_flight;

select *
from airlines_flights_data;

--  count of flight grouped by airlines
Select airline, Count(*) AS Total_flight
From airlines_flights_data
Group By airline
Order by Total_flight ASC;

--  Busiest route(most common source cities for flights)
Select source_city, count(*) AS Busy_route
From airlines_flights_data
Group by source_city
order by Busy_route DESC;

--  most common destination cities for flights
Select destination_city, Count(*) AS busy_cities
From airlines_flights_data
Group by destination_city
Order by busy_cities DESC;

--  the first 3 most expensive flights by average price per airline
Select airline, Round(AVG(price), 3) AS avg_price
From airlines_flights_data
Group by airline
Order by avg_price DESC
LIMIT 3;

--  the first 3 cheapest flights by average per airline
Select airline, Round(AVG(price), 2) AS avg_price
From airlines_flights_data
Group by airline
Order by avg_price ASC
LIMIT 3;

--  average duration per airline
Select airline, Round(AVG(duration)) AS avg_duration
From airlines_flights_data
Group by airline;

--  Peak departure route, analyzed as time slots (morning, afternoon, evening, night) have the most flights.”
Select
Case
	When departure_time = 'Early_morning' Then 'morning'
    when departure_time = 'morning' then 'morning'
    when departure_time = 'afternoon' then 'noon'
    when departure_time = 'evening' then 'evening'
    when departure_time = 'night' then 'night'
    Else 'unknown'
    END AS time_slot,
count(*)
From airlines_flights_data
Group by time_slot;

--  most expensive route
WITH route_avg AS (
  SELECT 
    source_city, destination_city,
    AVG(price) AS avg_price
  FROM airlines_flights_data
  GROUP BY source_city, destination_city
),
ranked AS (
  SELECT *,
         DENSE_RANK() OVER (ORDER BY avg_price DESC) AS rnk
  FROM route_avg
)
SELECT source_city, destination_city, ROUND(avg_price,2) AS avg_price
FROM ranked
WHERE rnk = 1;

--  does more stops increase the duration of flight
SELECT 
  stops,
  COUNT(*) AS flights,
  ROUND(AVG(duration),2) AS avg_duration
FROM airlines_flights_data
GROUP BY stops
ORDER BY avg_duration DESC;

--  cheapest airline for each route
WITH route_airline AS (
  SELECT 
    source_city, destination_city, airline,
    AVG(price) AS avg_price
  FROM airlines_flights_data
  GROUP BY source_city, destination_city, airline
),
ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY source_city, destination_city
           ORDER BY avg_price ASC
         ) AS rn
  FROM route_airline
)
SELECT source_city, destination_city, airline, ROUND(avg_price,2) AS avg_price
FROM ranked
WHERE rn = 1;

--  airline with the widest route
SELECT 
  airline,
  COUNT(DISTINCT CONCAT(source_city,'->',destination_city)) AS distinct_routes
FROM airlines_flights_data
GROUP BY airline
ORDER BY distinct_routes DESC;

-- shortest vs longest flight ranked by duration
SELECT 
  airline, flight, source_city, destination_city, duration,
  RANK() OVER (ORDER BY duration ASC)  AS shortest_rank,
  RANK() OVER (ORDER BY duration DESC) AS longest_rank
FROM airlines_flights_data
ORDER BY duration ASC;

--  identify outlier in price
WITH stats AS (
  SELECT 
    *,
    AVG(price)       OVER () AS avg_price_all,
    STDDEV_SAMP(price) OVER () AS std_price_all
  FROM airlines_flights_data
)
SELECT 
  airline, flight, source_city, destination_city, price,
  avg_price_all, std_price_all,
  CASE 
    WHEN price > avg_price_all + 2*std_price_all THEN 'High Outlier'
    WHEN price < avg_price_all - 2*std_price_all THEN 'Low Outlier'
    ELSE 'Normal'
  END AS price_band
FROM stats
ORDER BY price DESC;

--  airline renue potential per airline
SELECT 
  airline,
  COUNT(*) AS tickets,
  ROUND(SUM(price),2) AS est_revenue
FROM airlines_flights_data
GROUP BY airline
ORDER BY est_revenue DESC;

--  average price per hour of travel
SELECT 
  airline,
  ROUND(AVG(price / NULLIF(duration,0)), 2) AS avg_price_per_hour
FROM airlines_flights_data
GROUP BY airline
ORDER BY avg_price_per_hour ASC;

--   most competitive route served by many airline
SELECT 
  source_city, destination_city,
  COUNT(DISTINCT airline) AS airlines_serving,
  COUNT(*) AS total_flights
FROM airlines_flights_data
GROUP BY source_city, destination_city
ORDER BY airlines_serving DESC, total_flights DESC;