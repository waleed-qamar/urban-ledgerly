CREATE TABLE employees (
    id BIGSERIAL PRIMARY KEY,

    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    cnic TEXT UNIQUE,

    joining_date DATE NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT true,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    user_id UUID NOT NULL DEFAULT auth.uid()
        REFERENCES auth.users(id)
        ON DELETE CASCADE,
        
    role TEXT NOT NULL DEFAULT 'accountant' 
        CHECK (role IN ('master', 'accountant'))
);