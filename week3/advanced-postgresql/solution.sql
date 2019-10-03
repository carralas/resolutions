/* CHALLENGE 1 */
SELECT authors.au_id, authors.au_lname, authors.au_fname, titles.title, publishers.pub_name
FROM authors JOIN titleauthor ON authors.au_id = titleauthor.au_id
	JOIN titles ON titleauthor.title_id = titles.title_id
	JOIN publishers ON titles.pub_id = publishers.pub_id;

/* CHALLENGE 2 */
SELECT authors.au_id, authors.au_lname, authors.au_fname, COUNT(titles.title) AS title_count, publishers.pub_name
FROM authors JOIN titleauthor ON authors.au_id = titleauthor.au_id
	JOIN titles ON titleauthor.title_id = titles.title_id
	JOIN publishers ON titles.pub_id = publishers.pub_id
GROUP BY authors.au_id, authors.au_lname, authors.au_fname, publishers.pub_name
ORDER BY authors.au_lname;

/* CHALLENGE 3 */
SELECT authors.au_id, authors.au_lname, authors.au_fname, SUM(sales.qty) AS total_sales
FROM authors JOIN titleauthor ON authors.au_id = titleauthor.au_id
	JOIN titles ON titleauthor.title_id = titles.title_id
	JOIN sales ON titles.title_id = sales.title_id
GROUP BY authors.au_id, authors.au_lname, authors.au_fname
ORDER BY total_sales DESC
LIMIT 3;

/* CHALLENGE 4 */
SELECT authors.au_id, authors.au_lname, authors.au_fname, COALESCE(SUM(sales.qty), 0) AS total_sales
FROM authors LEFT JOIN titleauthor ON authors.au_id = titleauthor.au_id
	LEFT JOIN titles ON titleauthor.title_id = titles.title_id
	LEFT JOIN publishers ON titles.pub_id = publishers.pub_id
	LEFT JOIN sales ON titles.title_id = sales.title_id
GROUP BY authors.au_id, authors.au_lname, authors.au_fname
ORDER BY total_sales DESC;

/* CHALLENGE 5 */
/* step 1 */
SELECT titleauthor.au_id, titleauthor.title_id, COALESCE(titles.price::FLOAT*sales.qty*titles.royalty::FLOAT/100*titleauthor.royaltyper/100, 0) AS sales_royalty
FROM titleauthor LEFT JOIN titles ON titleauthor.title_id = titles.title_id
	LEFT JOIN publishers ON titles.pub_id = publishers.pub_id
	LEFT JOIN sales ON titles.title_id = sales.title_id;
/* step 2 */
SELECT titleauthor.au_id, titleauthor.title_id, COALESCE(SUM(titles.price::FLOAT*sales.qty*titles.royalty::FLOAT/100*titleauthor.royaltyper/100), 0) AS sales_royalty
FROM titleauthor LEFT JOIN titles ON titleauthor.title_id = titles.title_id
	LEFT JOIN publishers ON titles.pub_id = publishers.pub_id
	LEFT JOIN sales ON titles.title_id = sales.title_id
GROUP BY titleauthor.au_id, titleauthor.title_id;
/* step 3 */
SELECT titleauthor.au_id, COALESCE(SUM(titles.price::FLOAT*sales.qty*titles.royalty::FLOAT/100*titleauthor.royaltyper/100), 0) AS sales_royalty
FROM titleauthor LEFT JOIN titles ON titleauthor.title_id = titles.title_id
	LEFT JOIN publishers ON titles.pub_id = publishers.pub_id
	LEFT JOIN sales ON titles.title_id = sales.title_id
GROUP BY titleauthor.au_id
ORDER BY sales_royalty DESC
LIMIT 3;

/* CHALLENGE 6 */

SELECT titleauthor.au_id, titleauthor.title_id, COALESCE(titles.price::FLOAT*sales.qty*titles.royalty::FLOAT/100*titleauthor.royaltyper/100, 0) AS sales_royalty
INTO TEMP TABLE author_sales
FROM titleauthor LEFT JOIN titles ON titleauthor.title_id = titles.title_id
	LEFT JOIN publishers ON titles.pub_id = publishers.pub_id
	LEFT JOIN sales ON titles.title_id = sales.title_id;

SELECT author_sales.au_id, COALESCE(SUM(sales_royalty), 0) AS sales
FROM author_sales
GROUP BY author_sales.au_id
ORDER BY sales DESC
LIMIT 3;

/* CHALLENGE 7 */

SELECT author_sales.au_id, COALESCE(SUM(sales_royalty), 0) AS profits
INTO TABLE most_profiting_authors
FROM author_sales
GROUP BY author_sales.au_id
ORDER BY profits DESC;