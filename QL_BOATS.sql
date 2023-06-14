---1.A script creates a database.
USE MASTER
GO
IF EXISTS(SELECT NAME FROM SYSDATABASES WHERE NAME = 'QL_BOATS')
	DROP DATABASE QL_BOATS
GO
CREATE DATABASE QL_BOATS
GO
USE QL_BOATS
GO
---2.Create tables , primary keys
CREATE TABLE SAILORS
(
	SID			INT				NOT NULL,
	SNAME		VARCHAR(50)		NOT NULL,
	RATING		INT				NOT NULL,
	AGE			INT				NOT NULL,
	SEX			VARCHAR(10)		NOT NULL,
	CONSTRAINT PK_SAILORS PRIMARY KEY(SID)
);
CREATE TABLE BOATS 
(
    BID			INT				NOT NULL,
    BNAME		VARCHAR(50)		NOT NULL,
    COLOR		VARCHAR(20)		NOT NULL,
    PRICE		INT	DEFAULT 0 CHECK (PRICE >= 0)
	CONSTRAINT PK_BOATS PRIMARY KEY(BID)
);
CREATE TABLE RESERVES 
(
	SID			INT	NOT NULL,
	BID			INT	NOT NULL,
	RESERVESDATE	DATE NOT NULL,
	CONSTRAINT PK_RESERVES PRIMARY KEY(SID, BID, RESERVESDATE)
);

---3.Create foreign key
--- RESERVES ---> SAILORS, BOATS

ALTER TABLE RESERVES
	ADD CONSTRAINT FK_RESERVES_SAILORS FOREIGN KEY(SID) REFERENCES SAILORS(SID),
		CONSTRAINT FK_RESERVES_BOATS FOREIGN KEY(BID) REFERENCES BOATS(BID)

---4.Insert into data
---4.Insert date in the tables
--------BẢNG Sailors--------------------------------
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(22,'Dustin',7,45,'M')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(29,'Sara',1,33,'F')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(31,'Lubber',8,55,'M')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(32,'Andy',8,25,'M')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(58,'Adele',10,35,'F')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(64,'Horatio',7,35,'M')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(71,'Amy',10,16,'F')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(74,'Hora',9,35,'M')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(85,'Jane',3,25,'F')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(95,'Bob',3,63,'M')
INSERT INTO SAILORS(SID,SNAME,RATING,AGE,SEX) VALUES(96,'Frodo',3,25,'M')

--------BẢNG Boats--------------------------------
INSERT INTO BOATS(BID,BNAME,COLOR,PRICE) VALUES(101,'Interlake','Blue',30000)
INSERT INTO BOATS(BID,BNAME,COLOR,PRICE) VALUES(102,'Interlake','Red',29000)
INSERT INTO BOATS(BID,BNAME,COLOR,PRICE) VALUES(103,'Clipper','Green',42000)
INSERT INTO BOATS(BID,BNAME,COLOR,PRICE) VALUES(104,'Marine','Red',18000)

--------BẢNG Reserves--------------------------------
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(22,101,'2019-10-10')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(22,102,'2019-10-10')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(22,103,'2019-10-08')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(22,104,'2019-10-07')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(31,102,'2019-11-10')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(31,103,'2019-11-06')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(31,104,'2019-11-12')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(64,101,'2019-09-05')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(64,102,'2019-09-08')
INSERT INTO RESERVES(SID,BID,RESERVESDATE) VALUES(74,103,'2019-09-08')

/*-----------1.2.2. TRUY VẤN	------------------------*/
/*Câu 1: Tìm tên thủy thủ đặt thuyền buồm màu đỏ.*/
---CÁCH 1: SỬ DỤNG INNER JOIN
SELECT Sailors.Sname
FROM Sailors
INNER JOIN Reserves ON Sailors.Sid = Reserves.Sid
INNER JOIN Boats ON Reserves.Bid = Boats.Bid
WHERE Boats.color = 'Red';

--CÁCH 2: SỬ DỤNG TRUY VẤN THÔNG THƯỜNG VÀ DISTINCT
SELECT DISTINCT Sname FROM sailors s, reserves r, boats b
	WHERE s.Sid like r.Sid AND r.Bid like b.Bid AND b.Color like 'Red';

/*Câu 2: Tìm tên thủy thủ đặt thuyền buồm màu đỏ và màu xanh*/
--CÁCH 1: SỬ DỤNG TRUY VẤN THÔNG THƯỜNG
SELECT Sailors.Sname
FROM Sailors, Reserves, Boats
WHERE Sailors.Sid = Reserves.Sid
    AND Reserves.Bid = Boats.Bid
    AND Boats.color IN ('Red', 'Blue');

--CÁCH 1.1: CÓ THỂ XẢY RA TRƯỜNG HỢP XANH LÁ CÂY-SỬ DỤNG INNER JOIN
SELECT DISTINCT Sname FROM sailors s
	INNER JOIN reserves r ON s.Sid like r.Sid
	INNER JOIN boats b ON r.Bid like b.Bid
	WHERE b.Color IN ('Red', 'Blue', 'Green');

--CÁCH 2: SỬ DỤNG TRUY VẤN THÔNG THƯỜNG VÀ DISTINCT
SELECT DISTINCT Sname FROM sailors s, reserves r, boats b
	WHERE s.Sid like r.Sid AND r.Bid like b.Bid AND b.Color IN ('Red', 'Blue');

--CÁCH 3: SỬ DỤNG IN
SELECT Sailors.Sname
FROM Sailors
WHERE Sid IN (
    SELECT Sid
    FROM Reserves
    WHERE Bid IN (
        SELECT Bid
        FROM Boats
        WHERE color = 'red' OR color = 'blue'
    )
);

/*Câu 3: Tìm tên thủy thủ chưa đặt thuyền buồm bao giờ.*/
--CÁCH 1: SỬ DỤNG NOT IN
SELECT Sname
FROM Sailors
WHERE Sid NOT IN (
    SELECT Sid
    FROM Reserves
);
--CÁCH 2: SỬ DỤNG LEFT JOIN
SELECT DISTINCT Sname FROM sailors s
	LEFT JOIN reserves r ON s.Sid like r.Sid
	WHERE r.Sid IS NULL;

--CÁCH 3: SỬ DỤNG DISTINCT VÀ TRUY VẤN THÔNG THƯỜNG
SELECT DISTINCT Sname FROM sailors
	WHERE Sid NOT IN (SELECT DISTINCT Sid FROM reserves);

/*Câu 4: Tìm tên thủy thủ đặt tất cả các thuyền buồm.*/
--CÁCH 1: CÂU TRUY VẤN LỒNG BÊN TRONG CÓ HAVING trả về danh sách các Sailor ID (Sid) của những thủy thủ đã đặt số lượng thuyền buồm duy nhất bằng tổng số thuyền buồm có trong bảng "Boats".
--CÂU TRUY VẤN select COUNT sẽ trả về tổng số thuyền buồm có trong bảng "Boats".
SELECT Sname
FROM Sailors
WHERE Sid IN (
    SELECT Sid
    FROM Reserves
    GROUP BY Sid
    HAVING COUNT(DISTINCT Bid) = (
        SELECT COUNT(*)
        FROM Boats
    )
);
--CÁCH 2: SỬ DỤNG INNER JOIN
SELECT Sname FROM sailors s
	INNER JOIN reserves r ON s.Sid like r.Sid
	GROUP BY Sname
	HAVING COUNT(*) >= (SELECT COUNT(*) FROM boats);

--CÁCH 3: SỬ DỤNG TRUY VẤN THƯỜNG VỚI WHERE
SELECT Sname FROM sailors s, reserves r
	WHERE s.Sid like r.Sid
	GROUP BY Sname
	HAVING COUNT(*) >= (SELECT COUNT(*) FROM boats); 

/*Câu 5: Tìm tên thuyền buồm có nhiều thủy thủ đặt nhất.
bao gồm 102 và 103 vì có 3 lần đặt*/
--CÁCH 1: SỬ DỤNG JOIN VÀ TRUY VẤN LỒNG
SELECT Boats.bid AS 'Mã số buồm',Boats.Bname AS 'Tên buồm'
FROM Boats
JOIN Reserves ON Boats.Bid = Reserves.Bid
GROUP BY Boats.Bid, Boats.Bname
HAVING COUNT(DISTINCT Reserves.Sid) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(DISTINCT Sid) AS cnt
        FROM Reserves
        GROUP BY Bid
    ) AS counts
);
--CÁCH 2: SỬ DỤNG INNER JOIN
SELECT Bname FROM boats b
	INNER JOIN reserves r ON b.Bid like r.Bid
	GROUP BY Bname
	HAVING COUNT(*) like (SELECT TOP 1 COUNT(*) FROM reserves GROUP BY Bid ORDER BY COUNT(*) DESC);
--CÁCH 3: SỬ DỤNG TRUY VẤN VỚI WHERE THÔNG THƯỜNG
SELECT Bname FROM boats b, reserves r
	WHERE b.Bid like r.Bid
	GROUP BY Bname
	HAVING COUNT(*) like (SELECT TOP 1 COUNT(*) FROM reserves GROUP BY Bid ORDER BY COUNT(*) DESC);

/*Câu 6: Tìm ngày tháng năm có thủy thủ đặt nhiều thuyền buồm nhất*/
SELECT ReservesDate FROM reserves
	GROUP BY ReservesDate
	HAVING COUNT(*) like (SELECT TOP 1 COUNT(*) FROM reserves GROUP BY ReservesDate ORDER BY COUNT(*) DESC);

/*Câu 7: Tìm các loại màu của các thuyền buồm được thủy thủ Dustin đặt.*/
--CÁCH 1: SỬ DỤNG DISTINCT VÀ INNER JOIN
SELECT DISTINCT Color FROM boats b
	INNER JOIN reserves r ON b.Bid like r.Bid
	INNER JOIN sailors s ON r.Sid like s.Sid
	WHERE s.Sname like 'Dustin';

--CÁCH 2: SỬ DỤNG DISTINCT VÀ WHERE
SELECT DISTINCT Color FROM boats b, reserves r, sailors s
	WHERE b.Bid like r.Bid AND r.Sid LIKE s.Sid AND s.Sname like 'Dustin';

/*Câu 8: Tìm tất cả các thủy thủ (Sid) có ít nhất là hạng 8 và có đặt thuyền buồm 103.*/
--CÁCH 1: SỬ DỤNG INNER JOIN
SELECT s.Sid FROM sailors s
	INNER JOIN reserves r ON r.Sid like s.Sid
	WHERE rating >= 8 AND r.Bid like 103;

--CÁCH 2: TRUY VẤN THÔNG THƯỜNG BẰNG WHERE
SELECT s.Sid FROM sailors s, reserves r
	WHERE r.Sid like s.Sid AND rating >= 8 AND r.Bid like 103;

--CÁCH 3:Loại bỏ các bản ghi trùng lặp từ kết quả của câu truy vấn.(DISTINCT) VÀ SỬ DỤNG IN
SELECT DISTINCT Sid
FROM Sailors
WHERE Sid IN (
    SELECT Sid
    FROM Reserves
    WHERE Bid = 103
)
AND rating >= 8;

/*Câu 9: Tìm tên các thủy thủ không đặt một thuyền buồm nào và trong tên (Sname) có chứa chuỗi
‘do’. Sắp xếp tăng dần theo tên thủy thủ (Sname)*/
--CÁCH 1: SỬ DỤNG LEFT JOIN AVF IS NULL
SELECT Sname FROM sailors s
	LEFT JOIN reserves r ON s.Sid like r.Sid
	WHERE r.Sid IS NULL AND Sname LIKE '%do%'
	ORDER BY Sname DESC;
--CÁCH 2: SỬ DỤNG NOT IN
SELECT Sname FROM sailors
	WHERE Sid NOT IN (SELECT DISTINCT Sid FROM reserves) AND Sname LIKE '%do%'
	ORDER BY Sname DESC;

--CÁCH 3: SỬ DỤNG NOT IN VÀ TRUY VẤN LỒNG
SELECT Sname
FROM Sailors
WHERE Sid NOT IN (
    SELECT Sid
    FROM Reserves
)
AND Sname LIKE '%do%'
ORDER BY Sname ASC;

/*Câu 10: Tìm tất cả các thủy thủ (Sid) có tuổi >=20, không đặt thuyền buồm nào.*/
--CÁCH 1: SỬ DỤNG LEFT JOIN
SELECT s.Sid FROM sailors s
	LEFT JOIN reserves r ON s.Sid like r.Sid
	WHERE r.Sid IS NULL AND age >= 20;
--CÁCH 2: SỬ DỤNG NOT IN
SELECT Sid  FROM sailors
	WHERE Sid NOT IN (SELECT DISTINCT Sid FROM reserves) AND age >= 20;

/*Câu 11: Tìm tên các thủy thủ có đặt ít nhất 2 thuyền buồm.*/
--CÁCH 1: SỬ DỤNG INNER JOIN
SELECT Sname FROM sailors s
	INNER JOIN reserves r ON s.Sid like r.Sid
	GROUP BY r.Sid, Sname
	HAVING COUNT(r.Bid) >= 2
--CÁCH 2: SỬ DỤNG IN
SELECT Sname
FROM Sailors
WHERE Sid IN (
    SELECT Sid
    FROM Reserves
    GROUP BY Sid
    HAVING COUNT(*) >= 2
);
--CÁCH 3: SỬ DỤNG WHERE 
SELECT Sname FROM sailors s, reserves r
	WHERE s.Sid like r.Sid
	GROUP BY r.Sid, Sname
	HAVING COUNT(r.Bid) >= 2

/*Câu 12: Tìm tên các thủy thủ có đặt các thuyền buồm trong ngày ‘10/10/2019’*/
--CÁCH 1: INNER JOIN
SELECT DISTINCT Sname FROM sailors s
	INNER JOIN reserves r ON s.Sid like r.Sid
	WHERE ReservesDate like '2019-10-10';
--CÁCH 2: SỬ DỤNG LIKE VÀ DISTINCT
SELECT DISTINCT Sname FROM sailors s, reserves r
	WHERE s.Sid like r.Sid AND ReservesDate like '2019-10-10';

--CÁCH 3: SỬ DỤNG IN
SELECT DISTINCT Sname
FROM Sailors
WHERE Sid IN (
    SELECT Sid
    FROM Reserves
    WHERE ReservesDate = '2019-10-10'
);
