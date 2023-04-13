/* Otázka č.3
 * Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 * 
 * (category_code, name, price_average, year)
 */

/*
 * var.A průměrný meziroční nárůst ceny za celé období
 */
WITH table1 AS 
	(SELECT price_year, category_code, price_average, food_name
	FROM t_j_j_table1 t
	GROUP BY price_year, category_code
	),
vyber AS
	(SELECT  t1.category_code, t1.food_name,  
		round(avg((t1.price_average - t2.price_average)/ t2.price_average) *100, 2) AS prum_narust_celkem
	FROM table1 t1
	JOIN table1 t2
		ON  t1.category_code = t2.category_code AND t1.price_year = t2.price_year + 1
	GROUP BY category_code
	)
SELECT *
FROM vyber
ORDER BY prum_narust_celkem 
	;

/*
 * variant B - vybrána nejmenší hodnota meziročního nárůstu, minus hodnota znamená pokles ceny
 */
WITH table1 AS 
	(SELECT price_year, category_code, price_average, food_name
	FROM t_j_j_table1 t
	GROUP BY price_year, category_code
	),
vyber AS
	(SELECT  t1.category_code, t1.food_name, t1.price_year,  
		round(((t1.price_average - t2.price_average)/ t2.price_average *100), 2) AS mezirocni_narust
	FROM table1 t1
	JOIN table1 t2
		ON  t1.category_code = t2.category_code AND t1.price_year = t2.price_year + 1
	#WHERE t1.category_code = 111101
	#GROUP BY category_code
	ORDER BY category_code
	)
SELECT * #food_name, min(mezirocni_narust)
FROM vyber
ORDER BY mezirocni_narust 
	;