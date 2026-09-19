CREATE EXTENSION IF NOT EXISTS "pgcrypto";
-- 1. Branches / Showrooms
CREATE TABLE branches (
                          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                          name VARCHAR(150) NOT NULL,
                          code VARCHAR(50) NOT NULL UNIQUE,
                          phone VARCHAR(20),
                          city VARCHAR(100) NOT NULL,
                          address TEXT NOT NULL,
                          is_active BOOLEAN NOT NULL DEFAULT TRUE,
                          created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                          updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                          created_by VARCHAR(100),
                          updated_by VARCHAR(100),
                          version BIGINT NOT NULL DEFAULT 0
);

-- 2. Roles and Permissions
CREATE TABLE roles (
                       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                       name VARCHAR(50) NOT NULL UNIQUE,
                       description VARCHAR(255),
                       created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                       updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                       created_by VARCHAR(100),
                       updated_by VARCHAR(100),
                       version BIGINT NOT NULL DEFAULT 0
);

-- 3. Unified Users Table
-- Includes employees, managers, drivers, accountants, and customers.
CREATE TABLE users (
                       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                       branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
                       full_name VARCHAR(150) NOT NULL,
                       email VARCHAR(150) UNIQUE,
                       phone_number VARCHAR(20) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       is_active BOOLEAN NOT NULL DEFAULT TRUE,
                       created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                       updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                       created_by VARCHAR(100),
                       updated_by VARCHAR(100),
                       version BIGINT NOT NULL DEFAULT 0
);

-- 4. User-Role Mapping (Many-to-Many)
CREATE TABLE user_roles (
                            user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                            role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
                            PRIMARY KEY (user_id, role_id)
);

-- 5. Performance Indexes
CREATE INDEX idx_users_phone ON users(phone_number);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_branch_id ON users(branch_id);
CREATE INDEX idx_branches_city ON branches(city);

-- 6. Standard Seed Data
INSERT INTO roles (name, description) VALUES
                                          (
                                              'ROLE_SUPER_ADMIN',
                                              'Full system access, including branch management and system configuration'
                                          ),
                                          (
                                              'ROLE_BRANCH_MANAGER',
                                              'Manage branch and showroom operations, daily reports, and warehouse inventory'
                                          ),
                                          (
                                              'ROLE_CASHIER',
                                              'Issue point-of-sale invoices, open and close the cash drawer, and manage shifts'
                                          ),
                                          (
                                              'ROLE_SALES_REP',
                                              'Showroom sales representative responsible for customer orders, measurements, and commissions'
                                          ),
                                          (
                                              'ROLE_WAREHOUSE_KEEPER',
                                              'Manage warehouse operations, inspect incoming transfers, record damaged items, and confirm stock receipts'
                                          ),
                                          (
                                              'ROLE_DELIVERY_DRIVER',
                                              'Delivery driver responsible for delivery routes and confirming customer deliveries'
                                          ),
                                          (
                                              'ROLE_ACCOUNTANT',
                                              'Manage accounting operations, cash management, checks, expenses, and income statements'
                                          ),
                                          (
                                              'ROLE_CUSTOMER',
                                              'Online store customer using e-commerce and warranty services'
                                          );