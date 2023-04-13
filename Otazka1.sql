/* Otázka č.1
 *Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 *	(payroll_value, industry_code, year)
 */


WITH salary_yearly as
	(SELECT
		salary,
		payroll_year,	
		industry_branch_code,
		t1.name
	FROM t_Jan_Jurik_project_SQL_primary_final t1
	WHERE industry_branch_code IS NOT NULL
	GROUP BY industry_branch_code, payroll_year
	)
SELECT s1.name, s1.payroll_year,
	round((s1.salary - s2.salary)/ s2.salary * 100 , 2) AS vypocet, 
	IF((s1.salary - s2.salary)/ s2.salary * 100 < 0, "pokles", "rust") AS mezirocne
FROM salary_yearly s1
JOIN salary_yearly s2
		ON s1.industry_branch_code = s2.industry_branch_code
		AND s1.payroll_year = s2.payroll_year + 1
ORDER BY s1.industry_branch_code, s1.payroll_year
;


