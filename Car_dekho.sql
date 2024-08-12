CREATE DATABASE cars;
USE cars;
--- READ_DATA---
SELECT * FROM car_d;

--- COUNT ----
SELECT COUNT(*) FROM car_d;

--- CARS AVAILABLE_IN _2023 ---
SELECT COUNT(*)
FROM car_d
WHERE year = 2023;

--- CARS AVAILABLE_IN _2020,2021,2022 ---
SELECT COUNT(*)
FROM car_d
WHERE year IN (2020,2021,2022)
GROUP BY year;

--- TOTALS_OF_ALL_CARS_AVAILABLE_BY_YEAR ---
SELECT year, COUNT(*)
FROM car_d
GROUP BY year;

--- DIESEL_CAR_IN_2020 ---
SELECT COUNT(*) 
FROM car_d
WHERE  year = 2020 AND fuel = 'Diesel';

--- PETROL_CAR_IN_2020 ---
SELECT COUNT(*) 
FROM car_d
WHERE  year = 2020 AND fuel = 'Petrol';

--- FUEL CARS COME BY ALL YEARS ---
SELECT name, year, fuel
FROM car_d
WHERE fuel IN ('Petrol','Diesel','CNG')
GROUP BY name, year, fuel
ORDER BY fuel;
 --- OR ---
SELECT year, COUNT(*) FROM car_d WHERE fuel = 'CNG' GROUP BY year;
SELECT year, COUNT(*) FROM car_d WHERE fuel = 'Diesel' GROUP BY year;
SELECT year, COUNT(*) FROM car_d WHERE fuel = 'Petrol' GROUP BY year;

--- WHICH YEAR HAD MORE THAN 100 CARS ---
SELECT year, COUNT(*) 
FROM car_d 
GROUP BY year
HAVING COUNT(*) > 100;

SELECT year, COUNT(*) 
FROM car_d 
GROUP BY year
HAVING COUNT(*) < 50;


--- COMPLETE CARS LIST BETWEEN 2015 TO 2023 ---
SELECT year, COUNT(*)
FROM car_d
WHERE year BETWEEN 2015 AND 2023
GROUP BY year;

SELECT COUNT(*)
FROM car_d
WHERE year BETWEEN 2015 AND 2023;

--- COMPLETE CARS DETAILS BETWEEN 2015 TO 2023 ---
SELECT * 
FROM car_d 
WHERE year BETWEEN 2015 AND 2023
ORDER BY year;











