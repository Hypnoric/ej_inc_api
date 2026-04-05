CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	sku VARCHAR(50) UNIQUE NOT NULL,
	name VARCHAR(255) NOT NULL,
	description TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE purchases (
	id SERIAL PRIMARY KEY,
	purchase_id INTEGER NOT NULL,
	product_id INTEGER NOT NULL,
	quantity INTEGER NOT NULL,
	unit_cost NUMERIC(10,2) NOT NULL,
	supplier_name VARCHAR(255),
	purchase_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (product_id)
		REFERENCES products(id)
);

CREATE TABLE sales (
	id SERIAL PRIMARY KEY,
	sale_id INTEGER NOT NULL,
	product_id INTEGER NOT NULL,
	quantity INTEGER NOT NULL,
	unit_price NUMERIC(10,2) NOT NULL,
	sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (product_id)
		REFERENCES products(id)
);

CREATE VIEW inventory AS
SELECT
	p.id,
	p.name,

	COALESCE((
		SELECT SUM(pi.quantity)
		FROM purchase_items pi
		WHERE pi.product_id = p.id
	), 0)

	-

	COALESCE((
		SELECT SUM(si.quantity)
		FROM sale_items si
		WHERE si.product_id = p.id
	), 0)

	AS quantity_in_stock

FROM products p;
