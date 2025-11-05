CREATE DATABASE QuanLyKTX
ON PRIMARY
(
    NAME = QuanLyKTX_Data,
    FILENAME = '.mdf',
    SIZE = 20MB,          
    MAXSIZE = 100MB,      
    FILEGROWTH = 5MB      
),
FILEGROUP FG_SinhVien
(
    NAME = QuanLyKTX_SinhVien,
    FILENAME = '.ndf',
    SIZE = 20MB,
    MAXSIZE = 200MB,
    FILEGROWTH = 10MB
)
LOG ON
(
    NAME = QuanLyKTX_Log,
    FILENAME = '.ldf',
    SIZE = 6MB,           
    MAXSIZE = 20MB,       
    FILEGROWTH = 2MB     
);
GO

USE QuanLyKTX
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

CREATE TABLE NHANVIEN (
    MaNV CHAR(6) PRIMARY KEY,
    HoTen NVARCHAR(50),
    GioiTinh NVARCHAR(3) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    ChucVu NVARCHAR(30),
    SDT VARCHAR(15),
    MaKhu CHAR(5),
    CONSTRAINT FK_NV_KHU FOREIGN KEY (MaKhu) REFERENCES KHU_KTX(MaKhu)
);

CREATE TABLE BAOTRI (
    MaBT CHAR(8) PRIMARY KEY,
    MaPhong CHAR(5) NOT NULL,
    NgayBao DATE NOT NULL,
    MoTa NVARCHAR(200),
    TrangThai NVARCHAR(20),
    MaNV CHAR(6) NULL,
    CONSTRAINT FK_BT_PHONG FOREIGN KEY (MaPhong) REFERENCES PHONG(MaPhong),
    CONSTRAINT FK_BT_NV FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);

CREATE TABLE THANHTOAN (
    MaTT CHAR(8) PRIMARY KEY,
    MaHDN CHAR(8) NOT NULL,
    NgayTT DATE DEFAULT GETDATE(),
    SoTien DECIMAL(12,0) CHECK (SoTien > 0),
    PhuongThuc NVARCHAR(20),
    GhiChu NVARCHAR(100),
    CONSTRAINT FK_TT_HD FOREIGN KEY (MaHDN) REFERENCES HOADON(MaHDN)
);

INSERT INTO KHU_KTX VALUES
('K01', N'Khu A', N'Nam', 5, N'69/68 Đặng Thùy Trâm, Bình Thạnh'),
('K02', N'Khu B', N'Nữ', 4, N'69/70 Đặng Thùy Trâm, Bình Thạnh');

INSERT INTO PHONG VALUES
('P101', 'K01', 101, 4, 800000, NULL),
('P102', 'K01', 102, 4, 800000, NULL),
('P103', 'K01', 103, 4, 850000, NULL),
('P201', 'K02', 201, 3, 900000, NULL),
('P202', 'K02', 202, 3, 900000, NULL),
('P203', 'K02', 203, 3, 950000, NULL);

INSERT INTO NHANVIEN VALUES
('NV0001', N'Lê Văn Kỹ', N'Nam', N'Quản lý khu', '0911222333', 'K01'),
('NV0002', N'Nguyễn Thị Hoa', N'Nữ', N'Quản lý khu', '0911444555', 'K02'),
('NV0003', N'Phạm Quốc Dũng', N'Nam', N'Nhân viên bảo trì', '0911555666', 'K01');

INSERT INTO SINHVIEN VALUES
('SV0001', N'Nguyễn Văn A', '2003-05-10', N'Nam', N'D21CQCN01', N'Công nghệ thông tin', '0912345678', 'vana@vanlanguni.vn', N'Đang học'),
('SV0002', N'Lê Thị B', '2004-07-12', N'Nữ', N'D22KTPM01', N'Kỹ thuật phần mềm', '0987654321', 'leb@vanlanguni.vn', N'Đang học'),
('SV0003', N'Trần Quốc C', '2003-08-22', N'Nam', N'D21QTKD01', N'Quản trị kinh doanh', '0912123456', 'quocc@vanlanguni.vn', N'Đang học'),
('SV0004', N'Đỗ Thị D', '2004-09-01', N'Nữ', N'D22TCNH01', N'Tài chính ngân hàng', '0912234567', 'dothid@vanlanguni.vn', N'Đang học'),
('SV0005', N'Lê Văn E', '2002-02-18', N'Nam', N'D20XD01', N'Xây dựng', '0912345679', 'leve@vanlanguni.vn', N'Tốt nghiệp'),
('SV0006', N'Nguyễn Hồng F', '2003-06-30', N'Nữ', N'D21KTPM02', N'Kỹ thuật phần mềm', '0987000111', 'hongf@vanlanguni.vn', N'Đang học'),
('SV0007', N'Phan Minh G', '2003-10-15', N'Nam', N'D21QTKD02', N'Quản trị kinh doanh', '0908000222', 'minhg@vanlanguni.vn', N'Đang học'),
('SV0008', N'Võ Anh H', '2004-03-25', N'Nữ', N'D22DL01', N'Du lịch', '0977000333', 'anhh@vanlanguni.vn', N'Đang học'),
('SV0009', N'Phạm Tấn I', '2002-11-02', N'Nam', N'D20XD02', N'Xây dựng', '0968000444', 'tani@vanlanguni.vn', N'Tốt nghiệp'),
('SV0010', N'Lý Thu J', '2003-04-10', N'Nữ', N'D21TT01', N'Truyền thông', '0909000555', 'thuj@vanlanguni.vn', N'Đang học'),
('SV0011', N'Ngô Minh K', '2004-02-19', N'Nam', N'D22KTPM02', N'Kỹ thuật phần mềm', '0935000666', 'minhk@vanlanguni.vn', N'Đang học'),
('SV0012', N'Bùi Hồng L', '2003-07-08', N'Nữ', N'D21MKT01', N'Marketing', '0936000777', 'hongl@vanlanguni.vn', N'Đang học'),
('SV0013', N'Tạ Quốc M', '2003-03-14', N'Nam', N'D21CNTP01', N'Công nghệ thực phẩm', '0917000888', 'quocm@vanlanguni.vn', N'Đang học'),
('SV0014', N'Phan Thị N', '2004-09-20', N'Nữ', N'D22DL02', N'Du lịch', '0977000999', 'thinh@vanlanguni.vn', N'Đang học'),
('SV0015', N'Lâm Hữu O', '2003-01-28', N'Nam', N'D21CNTT01', N'Công nghệ thông tin', '0918001000', 'huuo@vanlanguni.vn', N'Đang học'),
('SV0016', N'Vũ Ngọc P', '2003-10-02', N'Nữ', N'D21QTKD03', N'Quản trị kinh doanh', '0929001111', 'ngocp@vanlanguni.vn', N'Đang học'),
('SV0017', N'Đặng Thành Q', '2004-11-10', N'Nam', N'D22KT01', N'Kế toán', '0930001222', 'thanhq@vanlanguni.vn', N'Đang học'),
('SV0018', N'Nguyễn Hoàng R', '2002-06-06', N'Nam', N'D20KTDL01', N'Kinh tế du lịch', '0941001333', 'hoangr@vanlanguni.vn', N'Tốt nghiệp'),
('SV0019', N'Lê Tường S', '2003-09-17', N'Nữ', N'D21QTDL01', N'Quản trị du lịch', '0952001444', 'tuongs@vanlanguni.vn', N'Đang học'),
('SV0020', N'Phạm Anh T', '2004-01-22', N'Nữ', N'D22TCNH02', N'Tài chính ngân hàng', '0963001555', 'anht@vanlanguni.vn', N'Đang học');

INSERT INTO HOPDONG VALUES
('HD000001', 'SV0001', 'P101', '2025-01-01', '2025-12-31', 500000, N'Còn hiệu lực'),
('HD000003', 'SV0003', 'P102', '2025-03-01', '2025-12-31', 400000, N'Còn hiệu lực'),
('HD000004', 'SV0004', 'P202', '2025-01-15', '2025-12-31', 500000, N'Còn hiệu lực'),
('HD000006', 'SV0006', 'P203', '2025-03-01', '2025-12-31', 400000, N'Còn hiệu lực'),
('HD000007', 'SV0007', 'P101', '2025-01-01', '2025-12-31', 400000, N'Còn hiệu lực'),
('HD000008', 'SV0008', 'P202', '2025-02-01', '2025-12-31', 500000, N'Còn hiệu lực'),
('HD000010', 'SV0010', 'P203', '2025-04-01', '2025-12-31', 500000, N'Còn hiệu lực'),
('HD000011', 'SV0011', 'P103', '2025-01-01', '2025-12-31', 400000, N'Còn hiệu lực'),
('HD000012', 'SV0012', 'P201', '2025-02-01', '2025-12-31', 400000, N'Còn hiệu lực'),
('HD000013', 'SV0013', 'P101', '2025-03-01', '2025-12-31', 500000, N'Còn hiệu lực'),
('HD000014', 'SV0014', 'P202', '2025-01-01', '2025-12-31', 400000, N'Còn hiệu lực'),
('HD000015', 'SV0015', 'P102', '2025-02-01', '2025-12-31', 500000, N'Còn hiệu lực'),
('HD000016', 'SV0016', 'P203', '2025-03-01', '2025-12-31', 400000, N'Còn hiệu lực'),
('HD000017', 'SV0017', 'P103', '2025-01-01', '2025-12-31', 500000, N'Còn hiệu lực'),
('HD000002', 'SV0002', 'P201', '2025-02-01', '2025-12-31', 500000, N'Hết hạn'),
('HD000005', 'SV0005', 'P103', '2025-01-01', '2025-12-31', 500000, N'Hết hạn'),
('HD000009', 'SV0009', 'P102', '2025-01-01', '2025-12-31', 500000, N'Hết hạn'),
('HD000018', 'SV0018', 'P101', '2025-04-01', '2025-12-31', 500000, N'Hết hạn'),
('HD000019', 'SV0019', 'P202', '2025-01-01', '2025-12-31', 400000, N'Hết hạn'),
('HD000020', 'SV0020', 'P203', '2025-02-01', '2025-12-31', 500000, N'Hết hạn');


INSERT INTO DIENNUOC VALUES
('DN000001', 'P101', 9, 2025, 250, 120),
('DN000002', 'P102', 9, 2025, 220, 100),
('DN000003', 'P103', 9, 2025, 180, 90),
('DN000004', 'P201', 9, 2025, 260, 110),
('DN000005', 'P202', 9, 2025, 230, 95),
('DN000006', 'P203', 9, 2025, 200, 105);

INSERT INTO HOADON VALUES
('HDN0001', 'HD000001', 'DN000001', '2025-09-30', 1200000, N'Chưa thanh toán'),
('HDN0002', 'HD000002', 'DN000004', '2025-09-30', 1350000, N'Đã thanh toán'),
('HDN0003', 'HD000003', 'DN000002', '2025-09-30', 1250000, N'Chưa thanh toán'),
('HDN0004', 'HD000004', 'DN000005', '2025-09-30', 1150000, N'Đã thanh toán'),
('HDN0005', 'HD000006', 'DN000006', '2025-09-30', 1300000, N'Chưa thanh toán');

INSERT INTO THANHTOAN VALUES
('TT000001', 'HDN0002', '2025-10-01', 1350000, N'Tiền mặt', N'Thanh toán đủ'),
('TT000002', 'HDN0004', '2025-10-02', 1150000, N'Chuyển khoản', N'Thanh toán đủ');

INSERT INTO BAOTRI VALUES
('BT000001', 'P101', '2025-09-05', N'Hỏng bóng đèn trần', N'Đã xử lý', 'NV0003'),
('BT000002', 'P102', '2025-09-07', N'Rò rỉ nước lavabo', N'Đang xử lý', 'NV0001');

-- Cơ bản
-- Liệt kê danh sách sinh viên đang học tại ký túc xá.
SELECT MaSV, HoTen, Lop, Khoa, GioiTinh, TrangThai
FROM SINHVIEN
WHERE TrangThai = N'Đang học';
    
-- Hiển thị thông tin các phòng thuộc khu K01 có giá thuê lớn hơn 800,000.
SELECT MaPhong, SoPhong, GiaPhong, SucChua
FROM PHONG
WHERE MaKhu = 'K01' AND GiaPhong > 800000;

-- JOIN
-- Liệt kê thông tin sinh viên và phòng mà họ đang thuê.
SELECT sv.MaSV, sv.HoTen, p.MaPhong, p.GiaPhong, hd.NgayBatDau, hd.NgayKetThuc
FROM SINHVIEN sv
JOIN HOPDONG hd ON sv.MaSV = hd.MaSV
JOIN PHONG p ON hd.MaPhong = p.MaPhong;

-- Hiển thị hóa đơn điện nước kèm theo tên sinh viên và trạng thái thanh toán.
SELECT sv.HoTen, hdg.MaHD, hdn.MaHDN, hdn.NgayLap, hdn.TongTien, hdn.TrangThai
FROM SINHVIEN sv
JOIN HOPDONG hdg ON sv.MaSV = hdg.MaSV
JOIN HOADON hdn ON hdg.MaHD = hdn.MaHD;

-- Subquery
-- Tìm sinh viên có tiền cọc hợp đồng cao hơn mức cọc trung bình của tất cả sinh viên.
SELECT sv.MaSV, sv.HoTen, hd.TienCoc
FROM SINHVIEN sv
JOIN HOPDONG hd ON sv.MaSV = hd.MaSV
WHERE hd.TienCoc > (SELECT AVG(TienCoc) FROM HOPDONG);

-- Liệt kê các phòng chưa có yêu cầu bảo trì nào.
SELECT MaPhong, SoPhong, GiaPhong
FROM PHONG
WHERE MaPhong NOT IN (SELECT MaPhong FROM BAOTRI);

-- Tính tổng số sinh viên đang thuê ở từng khu ký túc xá.
SELECT k.TenKhu, COUNT(hd.MaSV) AS SoSinhVien
FROM KHU_KTX k
JOIN PHONG p ON k.MaKhu = p.MaKhu
JOIN HOPDONG hd ON p.MaPhong = hd.MaPhong
GROUP BY k.TenKhu;

-- Tính tổng tiền hóa đơn từng hợp đồng và chỉ hiển thị những hợp đồng có tổng tiền > 1,200,000.
SELECT hdn.MaHD, SUM(hdn.TongTien) AS TongTienHoaDon
FROM HOADON hdn
GROUP BY hdn.MaHD
HAVING SUM(hdn.TongTien) > 1200000;

-- Liệt kê sinh viên, phòng, tổng số tiền đã thanh toán và phương thức thanh toán.
SELECT sv.HoTen, p.MaPhong, SUM(tt.SoTien) AS TongThanhToan, MAX(tt.PhuongThuc) AS HinhThuc
FROM SINHVIEN sv
JOIN HOPDONG hd ON sv.MaSV = hd.MaSV
JOIN HOADON hdn ON hd.MaHD = hdn.MaHD
JOIN THANHTOAN tt ON hdn.MaHDN = tt.MaHDN
JOIN PHONG p ON hd.MaPhong = p.MaPhong
GROUP BY sv.HoTen, p.MaPhong;

-- Thống kê số lượng yêu cầu bảo trì theo từng nhân viên phụ trách.
SELECT nv.HoTen AS NhanVien, COUNT(bt.MaBT) AS YeuCauBaoTri
FROM NHANVIEN nv
LEFT JOIN BAOTRI bt ON nv.MaNV = bt.MaNV
GROUP BY nv.HoTen;

-- CHECK (SoLuongDangO <= SucChua)
CREATE TRIGGER trg_KiemTraSucChuaPhong
ON HOPDONG
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Loi NVARCHAR(200);

    -- Nếu có phòng nào vượt sức chứa sau khi thêm
    IF EXISTS (
        SELECT 1
        FROM PHONG p
        JOIN (
            SELECT MaPhong, COUNT(*) AS SoNguoiDangO
            FROM HOPDONG
            WHERE TrangThai = N'Còn hiệu lực'
            GROUP BY MaPhong
        ) hd ON p.MaPhong = hd.MaPhong
        WHERE hd.SoNguoiDangO > p.SucChua
    )
    BEGIN
        SET @Loi = N'Phòng đã vượt quá sức chứa, không thể thêm hợp đồng mới!';
        ROLLBACK TRANSACTION;
        RAISERROR(@Loi, 16, 1);
        RETURN;
    END;
END;
GO

-- Xem thông tin phòng còn nhiêu slot
DROP VIEW V_ThongTinPhong;
CREATE VIEW V_ThongTinPhong
AS
SELECT
    P.MaPhong,
    P.MaKhu,
    P.SoPhong,
    P.SucChua,
    P.GiaPhong,
    ISNULL(SoLuongDangO, 0) AS SoLuongDangO,
    (P.SucChua - ISNULL(SoLuongDangO, 0)) AS ChoTrong
FROM PHONG AS P
LEFT JOIN (
    SELECT
        MaPhong,
        COUNT(*) AS SoLuongDangO
    FROM HOPDONG
    WHERE GETDATE() BETWEEN NgayBatDau AND NgayKetThuc
      AND (TrangThai IS NULL OR TrangThai <> N'Đã hủy')
    GROUP BY MaPhong
) AS HienTai ON HienTai.MaPhong = P.MaPhong;

SELECT * FROM V_ThongTinPhong;

CREATE FUNCTION fn_PhongConTrong
(
    @MaPhong CHAR(5),
    @TuNgay DATE,
    @DenNgay DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @ConTrong BIT = 0;
    DECLARE @SucChua INT;
    DECLARE @SoNguoiDangO INT;

    SELECT @SucChua = SucChua FROM dbo.PHONG WHERE MaPhong = @MaPhong;

    IF @SucChua IS NULL RETURN 0;

    SELECT @SoNguoiDangO = COUNT(*)
    FROM dbo.HOPDONG
    WHERE MaPhong = @MaPhong
      AND NOT (NgayKetThuc < @TuNgay OR NgayBatDau > @DenNgay)
      AND (TrangThai IS NULL OR TrangThai <> N'Đã hủy');

    IF @SoNguoiDangO < @SucChua
        SET @ConTrong = 1;

    RETURN @ConTrong;
END;
GO
SELECT fn_PhongConTrong('P102', '2025-11-01', '2025-11-30') AS ConTrong;

