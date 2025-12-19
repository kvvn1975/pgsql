# pgsql
Documents and notes
WITH ranked AS (
  SELECT e.*,
         ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC, emp_id) AS rn_top,
         ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary ASC,  emp_id) AS rn_low
  FROM hrms.employees e
),
tops AS (
  SELECT department_id, emp_name AS top_emp, salary AS top_sal
  FROM ranked
  WHERE rn_top = 1
),
lows AS (
  SELECT department_id, emp_name AS low_emp, salary AS low_sal
  FROM ranked
  WHERE rn_low = 1
)
SELECT t.department_id,
       t.top_emp, t.top_sal,
       l.low_emp, l.low_sal,
       (t.top_sal - l.low_sal) AS gap
FROM tops t
JOIN lows l USING (department_id)
ORDER BY gap DESC;
