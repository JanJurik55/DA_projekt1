/* Otázka č.5
 * 
 * Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 */


WITH hdp AS 
	(SELECT t.`year`, t.GDP
	FROM t_j_j_table2 t
	WHERE t.country = 'Czech Republic'
	),
growth_hdp AS 
	(SELECT t1.`year` AS rok, t1.GDP, t2.gdp AS GDP_before, 
	round(((t1.gdp - t2.gdp)/t2.gdp*100),2) AS growth_hdp
	FROM hdp t1
	JOIN hdp t2
	ON t1.`year` = t2.`year`+1
	),
price AS
	(SELECT t1.price_year AS rok, sum(t1.price_average) AS souhrn, sum(t2.price_average) AS souhrn_loni
	FROM t_j_j_table1 t1
	JOIN t_j_j_table1 t2
	ON t1.price_year = t2.price_year +1
	GROUP BY t1.price_year
	),
growth_price AS 
	(SELECT rok, 
		round((souhrn - souhrn_loni) / souhrn_loni * 100, 2) AS growth_price
	FROM price
	),
salary_yearly as
	(SELECT payroll_year AS rok, salary		
	FROM t_j_j_table1 t1
	WHERE industry_branch_code IS NULL
	GROUP BY payroll_year
	),
growth_salary AS
	(SELECT s1.rok, 
		round(((s1.salary - s2.salary) / s2.salary *100),2) AS growth_salary
	FROM salary_yearly s1
	JOIN salary_yearly s2
	ON s1.rok = s2.rok + 1
	)
SELECT	g.rok,  g.growth_hdp , i.growth_price, s.growth_salary
FROM growth_hdp g
JOIN growth_price i ON i.rok = g.rok
JOIN growth_salary s ON g.rok = s.rok
;