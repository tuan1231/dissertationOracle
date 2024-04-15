/*
Thêm 2 cột DIEMTB và XLOAI vào Table SV_DETAI:
Dùng cursor cập nhật điểm đề tài và xếp loại theo quy tắc:

(DIEMHD+DIEMPB+3*DIEMUV)/5
9<=DIEMTB<=10 XLOAI: Giỏi
7<=DIEMTB<9 XLOAI: Khá
5<=DIEMTB<7 XLOAI: Trung bình
DIEMTB<5 XLOAI: Không đạt
*/
ALTER TABLE SV_DETAI ADD DTB FLOAT;
ALTER TABLE SV_DETAI ADD XLOAI NVARCHAR2 (20);

CREATE OR REPLACE PROCEDURE PR_5553
AS
   -- A. Declare cursor
   CURSOR teo IS SELECT MSSV, MSDT FROM SV_DETAI;

   P_MSSV SV_DETAI.MSSV%TYPE;
   P_MSDT SV_DETAI.MSDT%TYPE;
BEGIN
   -- C. Open cursor
   OPEN teo;

   -- D. Fetch data from the cursor and process
   LOOP
      FETCH teo INTO P_MSSV, P_MSDT;
      EXIT WHEN teo%NOTFOUND=TRUE;
        UPDATE SV_DETAI
      -- Call function F_552_CAU1 to calculate average score
      SET   DTB = F_552_CAU1(P_MSDT),
            XLOAI = F_552_CAU2(P_MSDT)

    WHERE MSSV=P_MSSV AND MSDT=P_MSDT;
   END LOOP;
   -- E. Close cursor
   CLOSE teo;
END PR_5553;
/
execute PR_5553;
SELECT * FROM SV_DETAI