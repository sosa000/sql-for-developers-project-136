-- Таблица курсов
CREATE TABLE courses (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_course VARCHAR(255) NOT NULL,
    description_course TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    is_deleted SMALLINT NOT NULL
);

-- Таблица уроков
CREATE TABLE lessons (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_id BIGINT REFERENCES courses (id) NOT NULL,
    name_lesson VARCHAR(255) NOT NULL,
    content_lesson TEXT NOT NULL,
    link_video VARCHAR(255),
    position INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    is_deleted SMALLINT NOT NULL
);

-- Таблица модулей
CREATE TABLE modules (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_module VARCHAR(255) NOT NULL,
    description_module TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    is_deleted SMALLINT NOT NULL
);

-- связующая таблица курсов и модулей
CREATE TABLE courses_modules (
    module_id BIGINT REFERENCES modules (id) NOT NULL,
    course_id BIGINT REFERENCES courses (id) NOT NULL,
    PRIMARY KEY (module_id, course_id)
);

-- Таблица программ
CREATE TABLE programs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_program VARCHAR(255) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    type_program VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- связующая таблица программ и модулей
CREATE TABLE programs_modules (
    program_id BIGINT REFERENCES programs (id) NOT NULL,
    module_id BIGINT REFERENCES modules (id) NOT NULL,
    PRIMARY KEY (program_id, module_id)
);

-- таблица группы
CREATE TABLE teaching_groups (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    slack_group VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- CREATE TYPE roles AS ENUM ('student', 'teacher', 'admin'); возможное перечисление для ролей
-- таблица пользователей
CREATE TABLE users (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_user VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_user VARCHAR(100) NOT NULL,
    teaching_group_id BIGINT REFERENCES teaching_groups (id),
    role_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
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
    payment_amount DECIMAL(12, 2) NOT NULL,
    status payment_status NOT NULL,
    date_payment TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TYPE status_completion AS ENUM ('active', 'completed', 'pending', 'cancelled');
-- таблица прогресса прохождения
CREATE TABLE program_completions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users (id) NOT NULL,
    program_id BIGINT REFERENCES programs (id) NOT NULL,
    status status_completion NOT NULL,
    start_program TIMESTAMP NOT NULL,
    end_program TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- таблица сертификатов
CREATE TABLE certificates (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users (id),
    program_id BIGINT REFERENCES programs (id) NOT NULL,
    url_certificate VARCHAR(255) NOT NULL,
    date_certificate TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- таблица квизов
CREATE TABLE quizzes (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
    name_quizze VARCHAR(255) NOT NULL,
    content_quizze TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- таблица практик
CREATE TABLE exercises (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
    name_exercise VARCHAR(255) NOT NULL,
    url_exercise VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- таблица обсуждений
CREATE TABLE discussions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
    content_discussion TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TYPE status_blog AS ENUM ('created', 'in moderation', 'published', 'archived');
-- таблица личных блогов
CREATE TABLE blogs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users (id),
    header_blog VARCHAR(255) NOT NULL,
    content_blog TEXT NOT NULL,
    status status_blog NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
)