/* Otázka č.4
 * 
 * Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 * 
 * (category_code, name, price_average, year, salary)
 */


WITH salary AS 
	(SELECT t1.price_year AS rok,
		round((t1.salary - t2.salary) / t2.salary * 100, 2) AS growth_salary
	FROM t_Jan_Jurik_project_SQL_primary_final t1
	JOIN t_Jan_Jurik_project_SQL_primary_final t2
	ON t1.price_year = t2.price_year +1
	WHERE t1.industry_branch_code IS NULL
	GROUP BY t1.price_year
	),
price AS
	(SELECT t1.price_year AS rok, sum(t1.price_average) AS souhrn, sum(t2.price_average) AS souhrn_loni
	FROM t_Jan_Jurik_project_SQL_primary_final t1
	JOIN t_Jan_Jurik_project_SQL_primary_final t2
	ON t1.price_year = t2.price_year +1
	GROUP BY t1.price_year
	),
inflace AS 
	(SELECT rok, 
		round((souhrn - souhrn_loni) / souhrn_loni * 100, 2) AS growth_price
	FROM price
	)
SELECT	i.rok,  s.growth_salary, i.growth_price,
		i.growth_price - s.growth_salary AS rozdil
FROM inflace i
JOIN salary s ON i.rok = s.rok
;