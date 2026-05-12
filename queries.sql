-- Query 5a: All work items for customer Berger, Franz
-- Relational algebra: filter customer by name, join with order, vehicle, work_item
SELECT o.order_no, o.date, o.plate, wi.description, wi.hours
FROM customer c
JOIN "order" o    ON c.cust_no  = o.cust_no
JOIN vehicle v    ON o.plate    = v.plate
JOIN work_item wi ON o.order_no = wi.order_no
WHERE c.cust_name = 'Berger, Franz'
ORDER BY o.date, wi.item_no;

-- Query 5b: Total hours per mechanic in March 2026
SELECT m.mech_name,
       ROUND(SUM(wi.hours), 1)     AS total_hours,
       COUNT(DISTINCT wi.order_no) AS orders
FROM mechanic m
JOIN work_item wi ON m.mech_id   = wi.mech_id
JOIN "order"   o  ON wi.order_no = o.order_no
WHERE o.date BETWEEN '2026-03-01' AND '2026-03-31'
GROUP BY m.mech_id, m.mech_name
ORDER BY total_hours DESC;

-- Query 5c-1: Vehicles with no repair order (EXCEPT)
SELECT plate, model FROM vehicle
EXCEPT
SELECT v.plate, v.model
FROM vehicle v JOIN "order" o ON v.plate = o.plate;

-- Query 5c-2: Vehicles with no repair order (NOT EXISTS)
SELECT v.plate, v.model
FROM vehicle v
WHERE NOT EXISTS (
    SELECT 1 FROM "order" o WHERE o.plate = v.plate
);
