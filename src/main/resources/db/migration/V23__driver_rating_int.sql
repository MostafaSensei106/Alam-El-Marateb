-- Forward fix: SMALLINT maps to Short in Hibernate; service uses Int.
ALTER TABLE driver_ratings ALTER COLUMN rating TYPE INT;
