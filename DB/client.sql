CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    clientName VARCHAR(255) NOT NULL,
    clientAddress TEXT NOT NULL,
    contactNumber VARCHAR(20) NOT NULL,
    createdAt TIMESTAMP
);

CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    vendorName VARCHAR(255) NOT NULL,
    vendorAddress TEXT NOT NULL,
    supplyType VARCHAR(255),
    companyName TEXT,
    contactNumber VARCHAR(20) NOT NULL,
    createdAt TIMESTAMP
);