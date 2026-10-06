-- Stores information about the Customers
CREATE DATABASE Customers

USE Saas_Revenue_Management

CREATE TABLE Customers(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_type VARCHAR(30),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    country VARCHAR(50),
    activation_date DATE NOT NULL,
    customer_status VARCHAR(20) NOT NULL
);

INSERT INTO Customers (
    customer_id,
    customer_name,
    customer_type,
    email,
    phone,
    country,
    activation_date,
    customer_status
)
VALUES
(101, 'Nova Technologies', 'Enterprise', 'billing@novatech.com', '+447700100101', 'United Kingdom', '2026-01-15', 'Active'),
(102, 'Bright Systems', 'Mid-Market', 'finance@brightsystems.com', '+447700100102', 'United Kingdom', '2026-02-10', 'Active'),
(103, 'CloudWorks Ltd', 'Small Business', 'admin@cloudworks.com', '+447700100103', 'United Kingdom', '2026-03-01', 'Active'),
(104, 'Vertex Solutions', 'Enterprise', 'accounts@vertexsolutions.com', '+447700100104', 'United Kingdom', '2025-11-20', 'Active'),
(105, 'DataBridge Ltd', 'Mid-Market', 'finance@databridge.com', '+447700100105', 'United Kingdom', '2026-01-05', 'Active'),
(106, 'NextWave Digital', 'Small Business', 'admin@nextwave.com', '+447700100106', 'United Kingdom', '2026-04-12', 'Active'),
(107, 'Quantum Analytics', 'Enterprise', 'billing@quantumanalytics.com', '+447700100107', 'United Kingdom', '2025-10-08', 'Active'),
(108, 'BluePeak Consulting', 'Mid-Market', 'accounts@bluepeak.com', '+447700100108', 'United Kingdom', '2026-02-18', 'Active'),
(109, 'PixelCore Ltd', 'Small Business', 'hello@pixelcore.com', '+447700100109', 'United Kingdom', '2026-05-01', 'Active'),
(110, 'Apex Innovations', 'Enterprise', 'finance@apexinnovations.com', '+447700100110', 'United Kingdom', '2025-12-10', 'Active');


-- Stores information about the type of product customer bought
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    pricing_model VARCHAR(30) NOT NULL,
    standard_price DECIMAL(10,2) NOT NULL,
    billing_frequency VARCHAR(20),
    included_users INT,
    extra_user_price DECIMAL(10,2),
    max_discount_pct DECIMAL(5,2),
    product_status VARCHAR(20) NOT NULL
);
ALTER TABLE Products
ADD CONSTRAINT chk_standard_price
CHECK (standard_price >= 0);

--Adding data`s into the table_product
INSERT INTO Products (
    product_id,
    product_name,
    pricing_model,
    standard_price,
    billing_frequency,
    included_users,
    extra_user_price,
    max_discount_pct,
    product_status
)
VALUES
(1, 'Starter Plan', 'Subscription', 100.00, 'Monthly', 10, 5.00, 20.00, 'Active'),
(2, 'Growth Plan', 'Subscription', 200.00, 'Monthly', 25, 5.00, 20.00, 'Active'),
(3, 'Professional Plan', 'Subscription', 350.00, 'Monthly', 50, 7.50, 20.00, 'Active'),
(4, 'Business Plan', 'Subscription', 500.00, 'Monthly', 100, 10.00, 20.00, 'Active'),
(5, 'Enterprise Plan', 'Subscription', 800.00, 'Monthly', 200, 12.00, 20.00, 'Active');

CREATE TABLE Subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    subscription_start_date DATE NOT NULL,
    subscription_end_date DATE NULL,
    subscription_status VARCHAR(20) NOT NULL,
    contracted_price DECIMAL(10,2) NOT NULL,
    billing_frequency VARCHAR(20) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

-- Adding data`s into the table_subscription
INSERT INTO Subscriptions (
    subscription_id,
    customer_id,
    product_id,
    subscription_start_date,
    subscription_end_date,
    subscription_status,
    contracted_price,
    billing_frequency
)
VALUES
(1001, 101, 5, '2026-01-15', NULL, 'Active', 800.00, 'Monthly'),
(1002, 102, 3, '2026-02-10', NULL, 'Active', 350.00, 'Monthly'),
(1003, 103, 1, '2026-03-01', NULL, 'Active', 100.00, 'Monthly'),
(1004, 104, 5, '2025-11-20', NULL, 'Active', 800.00, 'Monthly'),
(1005, 105, 2, '2026-01-05', NULL, 'Active', 200.00, 'Monthly'),
(1006, 106, 1, '2026-04-12', NULL, 'Active', 100.00, 'Monthly'),
(1007, 107, 5, '2025-10-08', NULL, 'Active', 800.00, 'Monthly'),
(1008, 108, 3, '2026-02-18', NULL, 'Active', 350.00, 'Monthly'),
(1009, 109, 2, '2026-05-01', NULL, 'Active', 200.00, 'Monthly'),
(1010, 110, 4, '2025-12-10', NULL, 'Active', 500.00, 'Monthly');


CREATE TABLE Billing (
    billing_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    subscription_id INT NOT NULL,
    product_id INT NOT NULL,
    billing_cycle_start DATE NOT NULL,
    billing_cycle_end DATE NOT NULL,
    expected_amount DECIMAL(10,2) NOT NULL,
    billed_amount DECIMAL(10,2) NOT NULL,
    bill_date DATE NOT NULL,
    due_date DATE NOT NULL,
    payment_date DATE NULL,
    payment_status VARCHAR(20) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    FOREIGN KEY (subscription_id)
        REFERENCES Subscriptions(subscription_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

ALTER TABLE Billing
ADD CONSTRAINT chk_payment_status
CHECK (payment_status IN ('Paid', 'Pending', 'Overdue', 'Cancelled'));



 INSERT INTO Billing(
   billing_id,
    customer_id,
    subscription_id,
    product_id,
    billing_cycle_start,
    billing_cycle_end,
    expected_amount,
    billed_amount,
    bill_date,
    due_date,
    payment_date,
    payment_status
)
VALUES
-- Customer 101 - correctly billed
(5001, 101, 1001, 5, '2026-06-01', '2026-06-30', 800.00, 800.00, '2026-06-01', '2026-06-15', '2026-06-10', 'Paid'),
(5002, 101, 1001, 5, '2026-07-01', '2026-07-31', 800.00, 800.00, '2026-07-01', '2026-07-15', '2026-07-12', 'Paid'),
(5003, 101, 1001, 5, '2026-08-01', '2026-08-31', 800.00, 800.00, '2026-08-01', '2026-08-15', '2026-08-11', 'Paid'),

-- Customer 102 - consistently under-billed
(5004, 102, 1002, 3, '2026-06-01', '2026-06-30', 350.00, 300.00, '2026-06-01', '2026-06-15', '2026-06-14', 'Paid'),
(5005, 102, 1002, 3, '2026-07-01', '2026-07-31', 350.00, 300.00, '2026-07-01', '2026-07-15', '2026-07-14', 'Paid'),
(5006, 102, 1002, 3, '2026-08-01', '2026-08-31', 350.00, 300.00, '2026-08-01', '2026-08-15', '2026-08-13', 'Paid'),

-- Customer 103 - correctly billed
(5007, 103, 1003, 1, '2026-06-01', '2026-06-30', 100.00, 100.00, '2026-06-01', '2026-06-15', '2026-06-10', 'Paid'),
(5008, 103, 1003, 1, '2026-07-01', '2026-07-31', 100.00, 100.00, '2026-07-01', '2026-07-15', '2026-07-12', 'Paid'),
(5009, 103, 1003, 1, '2026-08-01', '2026-08-31', 100.00, 100.00, '2026-08-01', '2026-08-15', '2026-08-12', 'Paid'),

-- Customer 104 - consistently under-billed
(5010, 104, 1004, 5, '2026-06-01', '2026-06-30', 800.00, 650.00, '2026-06-01', '2026-06-15', '2026-06-12', 'Paid'),
(5011, 104, 1004, 5, '2026-07-01', '2026-07-31', 800.00, 650.00, '2026-07-01', '2026-07-15', '2026-07-13', 'Paid'),
(5012, 104, 1004, 5, '2026-08-01', '2026-08-31', 800.00, 650.00, '2026-08-01', '2026-08-15', '2026-08-14', 'Paid'),

-- Customer 105 - correctly billed
(5013, 105, 1005, 2, '2026-06-01', '2026-06-30', 200.00, 200.00, '2026-06-01', '2026-06-15', '2026-06-10', 'Paid'),
(5014, 105, 1005, 2, '2026-07-01', '2026-07-31', 200.00, 200.00, '2026-07-01', '2026-07-15', '2026-07-12', 'Paid'),
(5015, 105, 1005, 2, '2026-08-01', '2026-08-31', 200.00, 200.00, '2026-08-01', '2026-08-15', NULL, 'Overdue'),

-- Customer 106 - under-billed in only one month
(5016, 106, 1006, 1, '2026-06-01', '2026-06-30', 100.00, 100.00, '2026-06-01', '2026-06-15', '2026-06-11', 'Paid'),
(5017, 106, 1006, 1, '2026-07-01', '2026-07-31', 100.00, 80.00, '2026-07-01', '2026-07-15', '2026-07-13', 'Paid'),
(5018, 106, 1006, 1, '2026-08-01', '2026-08-31', 100.00, 100.00, '2026-08-01', '2026-08-15', '2026-08-13', 'Paid'),

-- Customer 107 - correctly billed but latest invoice overdue
(5019, 107, 1007, 5, '2026-06-01', '2026-06-30', 800.00, 800.00, '2026-06-01', '2026-06-15', '2026-06-10', 'Paid'),
(5020, 107, 1007, 5, '2026-07-01', '2026-07-31', 800.00, 800.00, '2026-07-01', '2026-07-15', '2026-07-14', 'Paid'),
(5021, 107, 1007, 5, '2026-08-01', '2026-08-31', 800.00, 800.00, '2026-08-01', '2026-08-15', NULL, 'Overdue'),

-- Customer 108 - consistently under-billed
(5022, 108, 1008, 3, '2026-06-01', '2026-06-30', 350.00, 320.00, '2026-06-01', '2026-06-15', '2026-06-12', 'Paid'),
(5023, 108, 1008, 3, '2026-07-01', '2026-07-31', 350.00, 320.00, '2026-07-01', '2026-07-15', '2026-07-13', 'Paid'),
(5024, 108, 1008, 3, '2026-08-01', '2026-08-31', 350.00, 320.00, '2026-08-01', '2026-08-15', '2026-08-13', 'Paid'),

-- Customer 109 - correctly billed but unpaid
(5025, 109, 1009, 2, '2026-06-01', '2026-06-30', 200.00, 200.00, '2026-06-01', '2026-06-15', '2026-06-10', 'Paid'),
(5026, 109, 1009, 2, '2026-07-01', '2026-07-31', 200.00, 200.00, '2026-07-01', '2026-07-15', '2026-07-11', 'Paid'),
(5027, 109, 1009, 2, '2026-08-01', '2026-08-31', 200.00, 200.00, '2026-08-01', '2026-08-15', NULL, 'Overdue'),

-- Customer 110 - correctly billed
(5028, 110, 1010, 4, '2026-06-01', '2026-06-30', 500.00, 500.00, '2026-06-01', '2026-06-15', '2026-06-11', 'Paid'),
(5029, 110, 1010, 4, '2026-07-01', '2026-07-31', 500.00, 500.00, '2026-07-01', '2026-07-15', '2026-07-12', 'Paid'),
(5030, 110, 1010, 4, '2026-08-01', '2026-08-31', 500.00, 500.00, '2026-08-01', '2026-08-15', '2026-08-13', 'Paid');



CREATE TABLE Discounts (
    discount_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    billing_id INT NULL,
    discount_type VARCHAR(30) NOT NULL,
    discount_percentage DECIMAL(5,2) NOT NULL,
    discount_amount DECIMAL(10,2),
    discount_date DATE NOT NULL,
    discount_status VARCHAR(20),

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id),

    FOREIGN KEY (billing_id)
        REFERENCES Billing(billing_id)
);


ALTER TABLE Discounts
ADD CONSTRAINT chk_discount_percentage
CHECK (discount_percentage BETWEEN 0 AND 100);


INSERT INTO Discounts(
    discount_id,
    customer_id,
    product_id,
    billing_id,
    discount_type,
    discount_percentage,
    discount_amount,
    discount_date,
    discount_status
)
VALUES
(7001, 101, 5, 5003, 'Loyalty', 10.00, 80.00, '2026-08-01', 'Applied'),
(7002, 102, 3, 5006, 'Promotional', 15.00, 52.50, '2026-08-01', 'Applied'),
(7003, 103, 1, 5009, 'Referral', 20.00, 20.00, '2026-08-01', 'Applied'),

-- Excessive discounts
(7004, 104, 5, 5012, 'Manual', 30.00, 240.00, '2026-08-01', 'Applied'),
(7005, 105, 2, 5015, 'Promotional', 25.00, 50.00, '2026-08-01', 'Applied'),

(7006, 106, 1, 5018, 'Loyalty', 5.00, 5.00, '2026-08-01', 'Applied'),

-- Excessive discount
(7007, 107, 5, 5021, 'Manual', 35.00, 280.00, '2026-08-01', 'Applied'),

(7008, 108, 3, 5024, 'Contract', 18.00, 63.00, '2026-08-01', 'Applied'),

-- Excessive discount
(7009, 109, 2, 5027, 'Promotional', 22.00, 44.00, '2026-08-01', 'Applied'),

(7010, 110, 4, 5030, 'Loyalty', 10.00, 50.00, '2026-08-01', 'Applied');



CREATE TABLE Product_Usage (
    usage_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    subscription_id INT NOT NULL,
    usage_month DATE NOT NULL,
    active_users INT NOT NULL,
    included_users INT NOT NULL,
    usage_units DECIMAL(10,2),
    recorded_date DATE NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id),

    FOREIGN KEY (subscription_id)
        REFERENCES Subscriptions(subscription_id)
);






INSERT INTO Product_Usage (
    usage_id,
    customer_id,
    product_id,
    subscription_id,
    usage_month,
    active_users,
    included_users,
    usage_units,
    recorded_date
)
VALUES
(9001, 101, 5, 1001, '2026-08-01', 185, 200, 4200.00, '2026-08-31'),

-- Above plan limit
(9002, 102, 3, 1002, '2026-08-01', 68, 50, 2100.00, '2026-08-31'),

(9003, 103, 1, 1003, '2026-08-01', 8, 10, 350.00, '2026-08-31'),

-- Above plan limit
(9004, 104, 5, 1004, '2026-08-01', 245, 200, 5900.00, '2026-08-31'),

(9005, 105, 2, 1005, '2026-08-01', 21, 25, 950.00, '2026-08-31'),

-- Above plan limit
(9006, 106, 1, 1006, '2026-08-01', 16, 10, 500.00, '2026-08-31'),

-- Above plan limit
(9007, 107, 5, 1007, '2026-08-01', 270, 200, 6600.00, '2026-08-31'),

(9008, 108, 3, 1008, '2026-08-01', 43, 50, 1800.00, '2026-08-31'),

-- Above plan limit
(9009, 109, 2, 1009, '2026-08-01', 34, 25, 1200.00, '2026-08-31'),

(9010, 110, 4, 1010, '2026-08-01', 92, 100, 3100.00, '2026-08-31');


SELECT * FROM Billing;

SELECT * FROM Products


