/* 
 * Vytvoření pohledů, zvlášť pro ceny potravin a mzdy
 */

CREATE OR REPLACE VIEW v_J_J_salary AS 
	SELECT avg(value) AS salary, cpu.name AS salary_unit_name,
		payroll_year, industry_branch_code, cpib.name
	FROM czechia_payroll cpay
	LEFT JOIN czechia_payroll_industry_branch cpib
		ON cpay.industry_branch_code = cpib.code
	JOIN czechia_payroll_unit cpu
		ON cpu.code = cpay.unit_code
	WHERE cpay.value_type_code = 5958
		AND cpay.value IS NOT NULL
		AND cpay.calculation_code = 200
	GROUP BY payroll_year, industry_branch_code
;

CREATE OR REPLACE VIEW v_J_J_food AS 
	SELECT year(date_from) AS price_year, category_code, cpc.name AS food_name, avg(value) AS price_average, cpc.price_value, cpc.price_unit
	FROM czechia_price cp
	JOIN czechia_price_category cpc 
		ON cp.category_code = cpc.code
	WHERE  region_code IS NULL
	GROUP BY price_year, category_code
;

/* 
 * Vytvoření tabulky č.1 sjednocením z pohledů pro společné období pro ČR
 */

CREATE OR REPLACE TABLE t_Jan_Jurik_project_SQL_primary_final AS	
	SELECT *
	FROM v_j_j_food vf
	JOIN v_j_j_salary vs
		ON vf.price_year = vs.payroll_year
;

/* 
 *	Vytvoření tabulky č.2 - data evropských států (HDP, GINI, populace)
 * 
 */

CREATE OR REPLACE TABLE t_Jan_Jurik_project_SQL_secondary_final AS	
	SELECT c.country,
		e.`year`,
		e.GDP,
		e.population,
		e.gini
	FROM countries c
	JOIN economies e
		ON c.country = e.country
	WHERE c.continent = "Europe"
		AND e.`year` IN 
		(SELECT DISTINCT payroll_year
			FROM t_Jan_Jurik_project_SQL_primary_final)
;