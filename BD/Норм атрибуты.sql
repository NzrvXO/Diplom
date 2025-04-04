USE КонфигураторСервисаПК;
GO

-- Таблица пользователей
CREATE TABLE Пользователи (
    ПользовательID INT IDENTITY PRIMARY KEY,
    Имя NVARCHAR(100) NOT NULL,
    Фамилия NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    Телефон NVARCHAR(20),
    ДатаРегистрации DATETIME DEFAULT GETDATE()
);

-- Таблица конфигураций
CREATE TABLE Конфигурации (
    КонфигурацияID INT IDENTITY PRIMARY KEY,
    ПользовательID INT NOT NULL,
    Название NVARCHAR(255) NOT NULL,
    ДатаСоздания DATETIME DEFAULT GETDATE(),
    Описание NVARCHAR(500),
    Цена DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (ПользовательID) REFERENCES Пользователи(ПользовательID) ON DELETE CASCADE
);

-- Таблица процессоров
CREATE TABLE Процессоры (
    ПроцессорID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    Производитель NVARCHAR(50) NOT NULL,
    ЧастотаGHz DECIMAL(3,2) NOT NULL,
    КоличествоЯдер INT NOT NULL,
    КоличествоПотоков INT NOT NULL,
    Сокет NVARCHAR(50) NOT NULL,
    TDP INT NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);

-- Связь конфигураций с процессорами (1 к 1)
CREATE TABLE Конфигурация_Процессор (
    КонфигурацияID INT PRIMARY KEY,
    ПроцессорID INT NOT NULL UNIQUE,
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (ПроцессорID) REFERENCES Процессоры(ПроцессорID) ON DELETE CASCADE
);

-- Таблица видеокарт
CREATE TABLE Видеокарты (
    ВидеокартаID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    Производитель NVARCHAR(50) NOT NULL,
    ОбъемПамятиGB INT NOT NULL,
    ТипПамяти NVARCHAR(50) NOT NULL,
    Интерфейс NVARCHAR(50) NOT NULL,
    ЧастотаГП INT NOT NULL,
    TDP INT NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);

-- Связь конфигураций с видеокартами (1 ко многим)
CREATE TABLE Конфигурация_Видеокарта (
    КонфигурацияID INT NOT NULL,
    ВидеокартаID INT NOT NULL,
    PRIMARY KEY (КонфигурацияID, ВидеокартаID),
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (ВидеокартаID) REFERENCES Видеокарты(ВидеокартаID) ON DELETE CASCADE
);

-- Таблица оперативной памяти
CREATE TABLE ОперативнаяПамять (
    ОЗУ_ID INT IDENTITY PRIMARY KEY,
    ОбъемGB INT NOT NULL,
    Тип NVARCHAR(50) NOT NULL,
    ЧастотаMHz INT NOT NULL,
    ФормФактор NVARCHAR(50) NOT NULL,
    Напряжение DECIMAL(3,2) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);

-- Связь конфигураций с оперативной памятью (много модулей)
CREATE TABLE Конфигурация_ОЗУ (
    КонфигурацияID INT NOT NULL,
    ОЗУ_ID INT NOT NULL,
    PRIMARY KEY (КонфигурацияID, ОЗУ_ID),
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (ОЗУ_ID) REFERENCES ОперативнаяПамять(ОЗУ_ID) ON DELETE CASCADE
);

-- Таблица накопителей (SSD, HDD)
CREATE TABLE Накопители (
    НакопительID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    ОбъемGB INT NOT NULL,
    Тип NVARCHAR(50) NOT NULL,
    СкоростьЧтенияMBs INT NOT NULL,
    СкоростьЗаписиMBs INT NOT NULL,
    Интерфейс NVARCHAR(50) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);

-- Связь конфигураций с накопителями (много накопителей)
CREATE TABLE Конфигурация_Накопитель (
    КонфигурацияID INT NOT NULL,
    НакопительID INT NOT NULL,
    PRIMARY KEY (КонфигурацияID, НакопительID),
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (НакопительID) REFERENCES Накопители(НакопительID) ON DELETE CASCADE
);

-- Таблица блоков питания
CREATE TABLE БлокиПитания (
    БлокПитанияID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    МощностьВт INT NOT NULL,
    Сертификация NVARCHAR(50) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);

-- Связь конфигураций с блоками питания (1 к 1)
CREATE TABLE Конфигурация_БлокПитания (
    КонфигурацияID INT PRIMARY KEY,
    БлокПитанияID INT NOT NULL UNIQUE,
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (БлокПитанияID) REFERENCES БлокиПитания(БлокПитанияID) ON DELETE CASCADE
);

-- Таблица корпусов
CREATE TABLE Корпусы (
    КорпусID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    ФормФактор NVARCHAR(50) NOT NULL,
    ПоддержкаБП NVARCHAR(50) NOT NULL,
    ПоддержкаМатеринскойПлаты NVARCHAR(50) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);

-- Связь конфигураций с корпусами (1 к 1)
CREATE TABLE Конфигурация_Корпус (
    КонфигурацияID INT PRIMARY KEY,
    КорпусID INT NOT NULL UNIQUE,
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (КорпусID) REFERENCES Корпусы(КорпусID) ON DELETE CASCADE
);

-- Таблица материнских плат
CREATE TABLE МатеринскиеПлаты (
    МатеринскаяПлатаID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    ФормФактор NVARCHAR(50) NOT NULL,
    Чипсет NVARCHAR(50) NOT NULL,
    Сокет NVARCHAR(50) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);

-- Связь конфигураций с материнскими платами (1 к 1)
CREATE TABLE Конфигурация_МатеринскаяПлата (
    КонфигурацияID INT PRIMARY KEY,
    МатеринскаяПлатаID INT NOT NULL UNIQUE,
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (МатеринскаяПлатаID) REFERENCES МатеринскиеПлаты(МатеринскаяПлатаID) ON DELETE CASCADE
);
