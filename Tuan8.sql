/*CAU 5.4.1*/
CREATE OR REPLACE PROCEDURE PR_5541(
p_TENHV IN HOCVI.TENHV%TYPE, 
p_SLGV OUT INT
)
AS
BEGIN
    SELECT COUNT (DISTINCT MSGV) INTO p_SLGV
    FROM GV_HV_CN
    WHERE MSHV =(
                SELECT MSHV
                FROM HOCVI
                WHERE TENHV = p_TENHV
                )
    GROUP BY MSHV;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('Học vị' || p_TENHV || 'không có trong bảng học vị...huhuhu.');
END PR_5541;
/
SET SERVEROUTPUT ON;
DECLARE
    v_TENHV HOCVI.TENHV%TYPE:=&Nhập_Tênhọcvị;
    v_SLGV INT;
BEGIN
    PR_5541 (v_TENHV, v_SLGV);
        IF v_SLGV>=1 THEN
            DBMS_OUTPUT.PUT_LINE('Học vị' || v_TENHV || ' này có' || v_SLGV || ' giáo viên.');
END IF;
END;
------------------------------------------------------------------------------------------------
/*CAU 5.4.2*/
CREATE OR REPLACE PROCEDURE PR_5542
(
p_TENDT IN DETAI.TENDT%TYPE,
p_DTB OUT FLOAT 
)
AS
    p_MSDT DETAI.MSDT%TYPE;
BEGIN
    SELECT MSDT INTO p_MSDT
    FROM DETAI
    WHERE TENDT = p_TENDT;
    p_DTB:= F_552_CAU1 (p_MSDT);
EXCEPTION
WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('Đề tài ' || p_TENDT || ' không tồn tại.');
END PR_5542;
/
SET SERVEROUTPUT ON;
DECLARE
    v_TENDT DETAI.TENDT%TYPE:=&Nhập_TênDT;
    v_DTB float;
BEGIN
PR_5542 (v_TENDT, v_DTB);
IF v_DTB>=1 THEN
    DBMS_OUTPUT.PUT_LINE('Đề tài ' || V_TENDT || ' này có điểm trung bình ' || V_DTB || ' điểm.');
END IF;
END;
------------------------------------------------------------------------------------------------------
/*CAU 5.4.3*/
CREATE OR REPLACE PROCEDURE P_554_CAU3
(
	p_TENGV		IN		GIAOVIEN.TENGV%TYPE,
	p_SDT		OUT		GIAOVIEN.SODT%TYPE
)
AS
BEGIN
	SELECT SODT INTO p_SDT
	FROM GIAOVIEN
	WHERE TENGV LIKE '%' || p_TENGV || '%'; -- Sửa lỗi ở đây: Phải ghép chuỗi p_TENGV vào mẫu tìm kiếm
	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Ten GV: '|| p_TENGV ||' khong ton tai');
END P_554_CAU3;
/
DECLARE
	p_TENCTHD		GIAOVIEN.TENGV%TYPE;
	p_SDT			GIAOVIEN.SODT%TYPE;
BEGIN
	P_554_CAU3('HIU PHAN', p_SDT);
	DBMS_OUTPUT.PUT_LINE('Số điện thoại của ' || 'HIU PHAN' || ' là: ' || p_SDT);
END;



SELECT * FROM GIAOVIEN