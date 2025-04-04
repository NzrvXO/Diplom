USE КонфигураторСервисаПК1;
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
GO

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
GO

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
GO

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
GO

-- Таблица материнских плат
CREATE TABLE МатеринскиеПлаты (
    МатеринскаяПлатаID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    ФормФактор NVARCHAR(50) NOT NULL,
    Чипсет NVARCHAR(50) NOT NULL,
    Сокет NVARCHAR(50) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);
GO

-- Таблица блоков питания
CREATE TABLE БлокиПитания (
    БлокПитанияID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    МощностьВт INT NOT NULL,
    Сертификация NVARCHAR(50) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);
GO

-- Таблица накопителей
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
GO

-- Таблица корпусов
CREATE TABLE Корпусы (
    КорпусID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    ФормФактор NVARCHAR(50) NOT NULL,
    ПоддержкаБП NVARCHAR(50) NOT NULL,
    ПоддержкаМатеринскойПлаты NVARCHAR(50) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);
GO

-- Таблица кулеров процессора
CREATE TABLE КулерыПроцессора (
    КулерПроцессораID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    Производитель NVARCHAR(50) NOT NULL,
    Тип NVARCHAR(50) NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);
GO

-- Таблица корпусных кулеров
CREATE TABLE КорпусныеКулеры (
    КорпусныйКулерID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    Производитель NVARCHAR(50) NOT NULL,
    Шум_dB INT NOT NULL,
    Цена DECIMAL(10,2) NOT NULL
);
GO

-- Таблица конфигураций
CREATE TABLE Конфигурации (
    КонфигурацияID INT IDENTITY PRIMARY KEY,
    Название NVARCHAR(255) NOT NULL,
    ДатаСоздания DATETIME DEFAULT GETDATE(),
    Описание NVARCHAR(500),
    Цена DECIMAL(10,2) DEFAULT 0.00,
    -- Обязательные комплектующие
    ПроцессорID INT NOT NULL,            -- каждая конфигурация содержит один процессор
    МатеринскаяПлатаID INT NOT NULL,       -- каждая конфигурация содержит одну материнскую плату
    БлокПитанияID INT NOT NULL,            -- каждая конфигурация содержит один блок питания
    КорпусID INT NOT NULL,                 -- каждая конфигурация содержит один корпус (корпус не может использоваться повторно)
    КулерПроцессораID INT NOT NULL,        -- каждая конфигурация содержит один кулер процессора
    FOREIGN KEY (ПроцессорID) REFERENCES Процессоры(ПроцессорID),
    FOREIGN KEY (МатеринскаяПлатаID) REFERENCES МатеринскиеПлаты(МатеринскаяПлатаID),
    FOREIGN KEY (БлокПитанияID) REFERENCES БлокиПитания(БлокПитанияID),
    FOREIGN KEY (КорпусID) REFERENCES Корпусы(КорпусID),
    FOREIGN KEY (КулерПроцессораID) REFERENCES КулерыПроцессора(КулерПроцессораID)
);
GO

-- Связь конфигураций с видеокартами (M:N; конфигурация может не содержать видеокарту)
CREATE TABLE Конфигурация_Видеокарты (
    КонфигурацияID INT NOT NULL,
    ВидеокартаID INT NOT NULL,
    PRIMARY KEY (КонфигурацияID, ВидеокартаID),
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (ВидеокартаID) REFERENCES Видеокарты(ВидеокартаID) ON DELETE CASCADE
);
GO

-- Связь конфигураций с оперативной памятью (M:N; конфигурация обязательно содержит хотя бы один модуль)
CREATE TABLE Конфигурация_ОЗУ (
    КонфигурацияID INT NOT NULL,
    ОЗУ_ID INT NOT NULL,
    PRIMARY KEY (КонфигурацияID, ОЗУ_ID),
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (ОЗУ_ID) REFERENCES ОперативнаяПамять(ОЗУ_ID) ON DELETE CASCADE
);
GO

-- Связь конфигураций с накопителями (M:N; опционально)
CREATE TABLE Конфигурация_Накопители (
    КонфигурацияID INT NOT NULL,
    НакопительID INT NOT NULL,
    PRIMARY KEY (КонфигурацияID, НакопительID),
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (НакопительID) REFERENCES Накопители(НакопительID) ON DELETE CASCADE
);
GO

-- Связь конфигураций с корпусными кулерами (M:N; опционально)
CREATE TABLE Конфигурация_КорпусныеКулеры (
    КонфигурацияID INT NOT NULL,
    КорпусныйКулерID INT NOT NULL,
    PRIMARY KEY (КонфигурацияID, КорпусныйКулерID),
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (КорпусныйКулерID) REFERENCES КорпусныеКулеры(КорпусныйКулерID) ON DELETE CASCADE
);
GO

-- Связь между пользователями и конфигурациями (M:N; конфигурация обязательно создаётся хотя бы одним пользователем)
CREATE TABLE Пользователь_Конфигурация (
    ПользовательID INT NOT NULL,
    КонфигурацияID INT NOT NULL,
    PRIMARY KEY (ПользовательID, КонфигурацияID),
    FOREIGN KEY (ПользовательID) REFERENCES Пользователи(ПользовательID) ON DELETE CASCADE,
    FOREIGN KEY (КонфигурацияID) REFERENCES Конфигурации(КонфигурацияID) ON DELETE CASCADE
);
GO
