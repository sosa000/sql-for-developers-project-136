-- Таблица курсов
CREATE TABLE courses (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP NOT NULL
);

-- Таблица уроков
CREATE TABLE lessons (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_id BIGINT REFERENCES courses (id),
    name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    video_url VARCHAR(255),
    position INT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP NOT NULL
);

-- таблица квизов
CREATE TABLE quizzes (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
    name VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- таблица практик
CREATE TABLE exercises (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
    name VARCHAR(255) NOT NULL,
    url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Таблица модулей
CREATE TABLE modules (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP NOT NULL
);

-- связующая таблица курсов и модулей
CREATE TABLE course_modules (
    module_id BIGINT REFERENCES modules (id) NOT NULL,
    course_id BIGINT REFERENCES courses (id) NOT NULL,
    PRIMARY KEY (module_id, course_id)
);

-- Таблица программ
CREATE TABLE programs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    program_type VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- связующая таблица программ и модулей
CREATE TABLE program_modules (
    program_id BIGINT REFERENCES programs (id) NOT NULL,
    module_id BIGINT REFERENCES modules (id) NOT NULL,
    PRIMARY KEY (program_id, module_id)
);

-- таблица группы
CREATE TABLE teaching_groups (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    slug VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- таблица пользователей
CREATE TABLE users (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(100),
    teaching_group_id BIGINT REFERENCES teaching_groups (id),
    role VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TYPE status_enrollment AS ENUM ('active', 'pending', 'cancelled', 'completed');
-- таблица подписок
CREATE TABLE enrollments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users (id) NOT NULL,
    program_id BIGINT REFERENCES programs (id) NOT NULL,
    status status_enrollment NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'failed', 'refunded');
-- таблица оплаты
CREATE TABLE payments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    enrollment_id BIGINT REFERENCES enrollments (id) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    status payment_status NOT NULL,
    paid_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TYPE status_completion AS ENUM ('active', 'completed', 'pending', 'cancelled');
-- таблица прогресса прохождения
CREATE TABLE program_completions (
    completed_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users (id) NOT NULL,
    program_id BIGINT REFERENCES programs (id) NOT NULL,
    status status_completion NOT NULL,
    started_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- таблица сертификатов
CREATE TABLE certificates (
    created_at TIMESTAMP NOT NULL,
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    issued_at TIMESTAMP NOT NULL,
    program_id BIGINT REFERENCES programs (id) NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    url VARCHAR(255) NOT NULL,
    user_id BIGINT REFERENCES users (id)
);

-- таблица обсуждений
CREATE TABLE discussions (
    created_at TIMESTAMP NOT NULL,
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
    text TEXT,
    updated_at TIMESTAMP NOT NULL,
    user_id BIGINT REFERENCES users (id) NOT NULL
);

CREATE TYPE status_blog AS ENUM ('created', 'in moderation', 'published', 'archived');
-- таблица личных блогов
CREATE TABLE blogs (
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    status status_blog NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    user_id BIGINT REFERENCES users (id)
);