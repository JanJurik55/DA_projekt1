/* Otázka č.2
 * Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 * 
 * (price_year, price_average, category_code (mléko, chleba), salary, industry_branch_code is null)
 */



SELECT price_year AS 'year', food_name,
		round(salary/price_average, 0) AS amount, price_unit AS unit
FROM t_Jan_Jurik_project_SQL_primary_final t
WHERE price_year IN (2006, 2018)
	AND (food_name LIKE "Mléko%" OR food_name LIKE "Chléb%")
	AND industry_branch_code IS NULL
;
