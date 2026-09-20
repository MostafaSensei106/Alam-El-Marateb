-- Forward fix: SMALLINT maps to Short in Hibernate; service uses Int.
ALTER TABLE product_reviews ALTER COLUMN rating TYPE INT;
