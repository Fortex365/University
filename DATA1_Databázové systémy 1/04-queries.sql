
-- zaměstnání (title zaměstnání), která má alespoň jeden zaměstnanec

SELECT DISTINCT
       t.job_title AS title
FROM
	((TABLE jobs) AS r
	NATURAL JOIN
	(TABLE employees) AS s)
AS t;

-- zaměstnání (id zaměstnání, title zaměstnání) konkretniho zaměstnance (zde zaměstnanec s id 100)

SELECT DISTINCT
       t.job_id AS id,
       t.job_title AS title
FROM
	((TABLE jobs) AS r
	NATURAL JOIN
	(TABLE employees) AS s)
AS t
WHERE
	t.employee_id = 100;

-- města (city) v zadané zemi (zde USA)

SELECT
	t.city
FROM
	((TABLE locations) AS r
	NATURAL JOIN
	(TABLE countries) AS s)
AS t
WHERE
	t.country_name = 'United States of America';

--zaměstnance (id zaměstnance, title zaměstnání), jejichž zaměstnání může mít daný plat (tj daný plat mezi zadaným min a max). (zde plat 10000)

SELECT
	t.employee_id AS id,
	t.job_title AS title
FROM
	((TABLE employees) AS r
	NATURAL JOIN
	(TABLE jobs) AS s)
AS t
WHERE
	t.min_salary < 10000
	AND
	t.max_salary > 10000;

--zaměstnance (id zaměstnance, title zaměstnání, city) pracující v zadaném městě. (zde Londýn)

SELECT
	t.employee_id AS id,
	t.job_title AS title,
	t.city
FROM
	(((TABLE employees) AS r
	   NATURAL JOIN
	   (TABLE jobs) AS s)
	  NATURAL JOIN
	 (TABLE locations) AS u)
AS t
WHERE
	city='London';
