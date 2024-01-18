
--Corregir nulos y vacíos

UPDATE customer_orders
SET exclusions = ''
WHERE exclusions IS NULL OR exclusions LIKE 'null'

UPDATE customer_orders
SET extras = ''
WHERE extras IS NULL OR extras LIKE 'null'

UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time LIKE 'null'

UPDATE runner_orders
SET distance = NULL
WHERE distance LIKE 'null'

UPDATE runner_orders
SET duration = NULL
WHERE duration LIKE 'null'

UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation LIKE 'null'

UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation IN ('')


--Extraer distancias en km

UPDATE runner_orders
SET distance = TRIM('km' FROM distance)
WHERE distance LIKE '%km'

ALTER TABLE runner_orders
ALTER COLUMN  distance float

-- convertir pickup_time a datetime

ALTER TABLE runner_orders
ALTER COLUMN  pickup_time datetime


--Extraer minutos

UPDATE runner_orders
SET duration = TRIM('mins' FROM duration)
WHERE duration LIKE '%mins'

UPDATE runner_orders
SET duration = TRIM('minute' FROM duration)
WHERE duration LIKE '%minute'

UPDATE runner_orders
SET duration = TRIM('minutes' FROM duration)
WHERE duration LIKE '%minutes'

ALTER TABLE runner_orders
ALTER COLUMN  duration INTEGER 

-- Cambiar de tipo TEXT a varchar para evitar errores en consultas
ALTER TABLE pizza_names
ALTER COLUMN pizza_name VARCHAR(MAX);

