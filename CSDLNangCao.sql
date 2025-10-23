CREATE DATABASE KTX_VANLANG;
GO

USE KTX_VANLANG;
GO

CREATE TABLE KHU_KTX (
    MaKhu CHAR(5) PRIMARY KEY,
    TenKhu NVARCHAR(50) NOT NULL,
    GioiTinh NVARCHAR(3) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    SoTang INT CHECK (SoTang > 0),
    DiaChi NVARCHAR(100)
);

CREATE TABLE PHONG (
    MaPhong CHAR(5) PRIMARY KEY,
    MaKhu CHAR(5) NOT NULL,
    SoPhong INT NOT NULL,
    SucChua INT CHECK (SucChua BETWEEN 1 AND 10),
    GiaPhong DECIMAL(12,0) CHECK (GiaPhong > 0),
    GhiChu NVARCHAR(100),

    CONSTRAINT FK_PHONG_KHU FOREIGN KEY (MaKhu) REFERENCES KHU_KTX(MaKhu)
);

CREATE TABLE SINHVIEN (
    MaSV CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(50) NOT NULL,
    NgaySinh DATE CHECK (NgaySinh < GETDATE()),
    GioiTinh NVARCHAR(3) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    Lop NVARCHAR(20),
    Khoa NVARCHAR(50),
    SDT VARCHAR(15),
    Email VARCHAR(50),
    TrangThai NVARCHAR(20) DEFAULT N'Đang học'
);

CREATE TABLE HOPDONG (
    MaHD CHAR(8) PRIMARY KEY,
    MaSV CHAR(10) NOT NULL,
    MaPhong CHAR(5) NOT NULL,
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    TienCoc DECIMAL(12,0) CHECK (TienCoc >= 0),
    TrangThai NVARCHAR(20) DEFAULT N'Còn hiệu lực',

    CONSTRAINT FK_HD_SV FOREIGN KEY (MaSV) REFERENCES SINHVIEN(MaSV),
    CONSTRAINT FK_HD_PHONG FOREIGN KEY (MaPhong) REFERENCES PHONG(MaPhong),
    CONSTRAINT CK_Ngay CHECK (NgayKetThuc > NgayBatDau)
);

CREATE TABLE DIENNUOC (
    MaDN CHAR(8) PRIMARY KEY,
    MaPhong CHAR(5) NOT NULL,
    Thang INT CHECK (Thang BETWEEN 1 AND 12),
    Nam INT CHECK (Nam >= 2020),
    ChiSoDien INT CHECK (ChiSoDien >= 0),
    ChiSoNuoc INT CHECK (ChiSoNuoc >= 0),

    CONSTRAINT FK_DN_PHONG FOREIGN KEY (MaPhong) REFERENCES PHONG(MaPhong)
);

CREATE TABLE HOADON (
    MaHDN CHAR(8) PRIMARY KEY,
    MaHD CHAR(8) NOT NULL,
    MaDN CHAR(8) NOT NULL,
    NgayLap DATE DEFAULT GETDATE(),
    TongTien DECIMAL(12,0) CHECK (TongTien >= 0),
    TrangThai NVARCHAR(20) DEFAULT N'Chưa thanh toán',

    CONSTRAINT FK_HOADON_HD FOREIGN KEY (MaHD) REFERENCES HOPDONG(MaHD),
    CONSTRAINT FK_HOADON_DN FOREIGN KEY (MaDN) REFERENCES DIENNUOC(MaDN)
);

-- Khu ký túc xá
INSERT INTO KHU_KTX VALUES ('K01', N'Khu A', N'Nam', 5, N'69/68 Đặng Thùy Trâm, Gò Vấp');
INSERT INTO KHU_KTX VALUES ('K02', N'Khu B', N'Nữ', 4, N'69/70 Đặng Thùy Trâm, Gò Vấp');

-- Phòng
INSERT INTO PHONG VALUES ('P101', 'K01', 101, 4, 800000, NULL);
INSERT INTO PHONG VALUES ('P102', 'K01', 102, 4, 800000, NULL);
INSERT INTO PHONG VALUES ('P201', 'K02', 201, 3, 900000, NULL);

-- Sinh viên
INSERT INTO SINHVIEN VALUES ('SV0001', N'Nguyễn Văn A', '2003-05-10', N'Nam', N'D21CQCN01', N'Công nghệ thông tin', '0912345678', 'vana@vanlanguni.vn', N'Đang học');
INSERT INTO SINHVIEN VALUES ('SV0002', N'Lê Thị B', '2004-07-12', N'Nữ', N'D22KTPM01', N'Kỹ thuật phần mềm', '0987654321', 'leb@vanlanguni.vn', N'Đang học');

SELECT 
    p.MaPhong, p.SoPhong, p.SucChua, p.GiaPhong, k.TenKhu, k.GioiTinh
FROM PHONG p
JOIN KHU_KTX k ON p.MaKhu = k.MaKhu
WHERE TenKhu = N'Khu A'
