CREATE TABLE Users (
    ПользовательID INT IDENTITY(1,1) PRIMARY KEY,
    Имя NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Configurations (
    КонфигурацияID INT IDENTITY(1,1) PRIMARY KEY,
    ПользовательID INT NOT NULL,
    FOREIGN KEY (ПользовательID) REFERENCES Users(ПользовательID) ON DELETE CASCADE
);

CREATE TABLE Processors (
    ПроцессорID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    Сокет NVARCHAR(50) NOT NULL,
    ПотребляемаяМощность INT NOT NULL CHECK (ПотребляемаяМощность > 0) -- Ватт
);

CREATE TABLE Motherboards (
    МатеринскаяПлатаID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    Сокет NVARCHAR(50) NOT NULL,
    ТипОЗУ NVARCHAR(50) NOT NULL,
    МаксЧастотаОЗУ INT NOT NULL CHECK (МаксЧастотаОЗУ > 0)
);

CREATE TABLE RAMs (
    ОперативнаяПамятьID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    Тип NVARCHAR(50) NOT NULL,
    Частота INT NOT NULL CHECK (Частота > 0) -- MHz
);

CREATE TABLE GPUs (
    ВидеокартаID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    ПотребляемаяМощность INT NOT NULL CHECK (ПотребляемаяМощность > 0),
    PCIe_Версия NVARCHAR(10) NOT NULL
);

CREATE TABLE PSUs (
    БлокПитанияID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    Мощность INT NOT NULL CHECK (Мощность > 0) -- Ватт
);

CREATE TABLE StorageDevices (
    НакопительID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    Тип NVARCHAR(50) NOT NULL, -- SSD, HDD и т.д.
    Объем INT NOT NULL CHECK (Объем > 0) -- ГБ
);

CREATE TABLE CPU_Coolers (
    КулерПроцессораID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    СовместимостьСокет NVARCHAR(50) NOT NULL
);

CREATE TABLE CaseCoolers (
    КорпусныйКулерID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    Размер NVARCHAR(50) NOT NULL, -- Например, 120mm, 140mm
    СкоростьОборотов INT NOT NULL CHECK (СкоростьОборотов > 0) -- RPM
);

CREATE TABLE Cases (
    КорпусID INT IDENTITY(1,1) PRIMARY KEY,
    Модель NVARCHAR(100) NOT NULL,
    ФормФактор NVARCHAR(50) NOT NULL -- ATX, MicroATX и т.д.
);

CREATE TABLE Configuration_Components (
    КонфигурацияID INT NOT NULL,
    ПроцессорID INT NULL,
    МатеринскаяПлатаID INT NULL,
    ОперативнаяПамятьID INT NULL,
    ВидеокартаID INT NULL,
    БлокПитанияID INT NULL,
    НакопительID INT NULL,
    КулерПроцессораID INT NULL,
    КорпусныйКулерID INT NULL,
    КорпусID INT NULL,
    PRIMARY KEY (КонфигурацияID),
    FOREIGN KEY (КонфигурацияID) REFERENCES Configurations(КонфигурацияID) ON DELETE CASCADE,
    FOREIGN KEY (ПроцессорID) REFERENCES Processors(ПроцессорID),
    FOREIGN KEY (МатеринскаяПлатаID) REFERENCES Motherboards(МатеринскаяПлатаID),
    FOREIGN KEY (ОперативнаяПамятьID) REFERENCES RAMs(ОперативнаяПамятьID),
    FOREIGN KEY (ВидеокартаID) REFERENCES GPUs(ВидеокартаID),
    FOREIGN KEY (БлокПитанияID) REFERENCES PSUs(БлокПитанияID),
    FOREIGN KEY (НакопительID) REFERENCES StorageDevices(НакопительID),
    FOREIGN KEY (КулерПроцессораID) REFERENCES CPU_Coolers(КулерПроцессораID),
    FOREIGN KEY (КорпусныйКулерID) REFERENCES CaseCoolers(КорпусныйКулерID),
    FOREIGN KEY (КорпусID) REFERENCES Cases(КорпусID)
);
