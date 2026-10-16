DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS enrollements CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;

CREATE TABLE students (
    student_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(250) NOT NULL UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(100),
    registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE teachers (
    teacher_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(250) NOT NULL UNIQUE,
    specialization VARCHAR(100) NOT NULL,
    hired_at DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE courses (
    course_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    teacher_id INT NOT NULL REFERENCES teachers(teacher_id) ON DELETE RESTRICT,
    price NUMERIC(10, 2) NOT NULL CHECK ( PRICE >= 0 ),
    level VARCHAR(20) NOT NULL CHECK ( level IN ('beginner', 'intermediate', 'advanced')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE enrollments (
    enrollment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INT NOT NULL REFERENCES courses(course_id) ON DELETE RESTRICT,
    enrolled_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK ( status IN ('active', 'completed', 'cancelled') ),
    progress_percent SMALLINT NOT NULL DEFAULT 0 CHECK ( progress_percent BETWEEN 0 AND 100 ),
    UNIQUE (student_id, course_id)
);

CREATE TABLE payments (
    payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    enrollment_id INT NOT NULL REFERENCES enrollments(enrollment_id) ON DELETE RESTRICT,
    amount NUMERIC(10, 2) NOT NULL CHECK ( amount > 0 ),
    method VARCHAR(20) NOT NULL CHECK ( method IN ('card', 'sbp', 'paypal') ),
    status VARCHAR(20) NOT NULL DEFAULT 'success' CHECK ( status IN ('success', 'pending', 'refunded', 'failed') )
);

