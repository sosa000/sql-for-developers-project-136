-- Таблица курсов
CREATE TABLE courses (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_course VARCHAR(255) NOT NULL,
    description_course TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    is_deleted TINYINT
);

-- Таблица уроков
CREATE TABLE lessons (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_id BIGINT REFERENCES courses (id),
    name_lesson VARCHAR(255) NOT NULL,
    content_lesson TEXT NOT NULL,
    link_video VARCHAR(255),
    position INT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    is_deleted TINYINT
);

-- Таблица модулей
CREATE TABLE modules (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_module VARCHAR(255) NOT NULL,
    description_module TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    is_deleted TINYINT
);

-- связующая таблица курсов и модулей
CREATE TABLE courses_modules (
    module_id BIGINT REFERENCES modules (id),
    course_id BIGINT REFERENCES courses (id),
    PRIMARY KEY (module_id, course_id)
)

-- Таблица программ
CREATE TABLE programs (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_program VARCHAR(255) NOT NULL,
    price INT,
    type_program VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
);

-- связующая таблица программ и модулей
CREATE TABLE programs_modules (
    program_id BIGINT REFERENCES programs (id),
    module_id BIGINT REFERENCES modules (id),
    PRIMARY KEY (program_id, module_id)
);

-- таблица группы
CREATE TABLE teaching_groups (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    slag_group VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- таблица ролей
CREATE TABLE roles (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_role VARCHAR(255) NOT NULL
);

-- таблица пользователей
CREATE TABLE users (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name_user VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_user VARCHAR(100) NOT NULL,
    teaching_group_id BIGINT REFERENCES teaching_groups (id),
    role_id BIGINT REFERENCES roles (id),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

