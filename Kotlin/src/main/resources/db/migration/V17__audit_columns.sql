-- EntityBase maps created_by/updated_by on every entity; these tables missed them.
ALTER TABLE quiz_questions ADD COLUMN created_by VARCHAR(100);
ALTER TABLE quiz_questions ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE quiz_options ADD COLUMN created_by VARCHAR(100);
ALTER TABLE quiz_options ADD COLUMN updated_by VARCHAR(100);
ALTER TABLE variant_attribute_values ADD COLUMN created_by VARCHAR(100);
ALTER TABLE variant_attribute_values ADD COLUMN updated_by VARCHAR(100);
