------------------------------------------------------------------------------------
/*cau 5.2.3*/
create or replace FUNCTION FU_5523
(
    P_MSDT IN DETAI.MSDT%TYPE
)
RETURN INT
AS
    SL INT;
BEGIN
    SELECT COUNT (MSSV) INTO SL
    FROM SV_DETAI
    WHERE MSDT = P_MSDT
    GROUP BY MSDT;
    RETURN SL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        BEGIN
            DBMS_OUTPUT.PUT_LINE('?? t�i' || P_MSDT || ' kh�ng t?n t?i.');
        RETURN -1;
        END;
END FU_5523;
------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PR_5531 (
    P_MSGV IN NUMBER,
    P_TENGV IN NVARCHAR2,
    P_DIACHI IN NVARCHAR2,
    P_SODT IN CHAR,
    P_MSHHAM IN NUMBER,
    P_NAMHH IN NUMBER   
) 
AS
    FK_MSHHAM EXCEPTION;
    PRAGMA EXCEPTION_INIT(FK_MSHHAM, -2291); -- S? d?ng m� l?i ?�ng (-2291)
BEGIN
    INSERT INTO GIAOVIEN (MSGV, TENGV, DIACHI, SODT, MSHHAM, NAMHH)
    VALUES (P_MSGV, P_TENGV, P_DIACHI, P_SODT, P_MSHHAM, P_NAMHH);
EXCEPTION
    WHEN FK_MSHHAM THEN
    BEGIN
        DBMS_OUTPUT.PUT_LINE('M� s? h?c h�m ' || P_MSHHAM || ' n�y kh�ng t?n t?i.');
    END;
END PR_5531;

------------------------------------------------------------------------------------
/*cau 5.3.2*/
CREATE OR REPLACE PROCEDURE PR_5532 (
    P_MSGV IN NUMBER,
    P_TENGV IN NVARCHAR2,
    P_DIACHI IN NVARCHAR2,
    P_SODT IN CHAR,
    P_MSHHAM IN NUMBER,
    P_NAMHH IN NUMBER   
) 
AS
    FK_MSGV EXCEPTION;
    PRAGMA EXCEPTION_INIT(FK_MSGV, -00001); 
BEGIN
    INSERT INTO GIAOVIEN (MSGV, TENGV, DIACHI, SODT, MSHHAM, NAMHH)
    VALUES (P_MSGV, P_TENGV, P_DIACHI, P_SODT, P_MSHHAM, P_NAMHH);
EXCEPTION
    WHEN FK_MSGV THEN
    BEGIN
        DBMS_OUTPUT.PUT_LINE('M� s? GV ' || P_MSGV || ' ?� t?n t?i.');
    END;
END PR_5532;
------------------------------------------------------------------------------------
/*cau 5.3.3*/
CREATE OR REPLACE PROCEDURE PR_5533 (
    P_MSGV IN NUMBER,
    P_TENGV IN NVARCHAR2,
    P_DIACHI IN NVARCHAR2,
    P_SODT IN CHAR,
    P_MSHHAM IN NUMBER,
    P_NAMHH IN NUMBER   
) 
AS
    FK_MSGV EXCEPTION;
    PRAGMA EXCEPTION_INIT(FK_MSGV, -00001); 
    FK_MSHHAM EXCEPTION;
    PRAGMA EXCEPTION_INIT(FK_MSHHAM, -2291);
BEGIN
    INSERT INTO GIAOVIEN (MSGV, TENGV, DIACHI, SODT, MSHHAM, NAMHH)
    VALUES (P_MSGV, P_TENGV, P_DIACHI, P_SODT, P_MSHHAM, P_NAMHH);
    DBMS_OUTPUT.PUT_LINE('THEM THANH CONG!');
EXCEPTION
    WHEN FK_MSHHAM THEN
    BEGIN
        DBMS_OUTPUT.PUT_LINE('M� s? h?c h�m ' || P_MSHHAM || ' n�y kh�ng t?n t?i.');
    END;
    WHEN FK_MSGV THEN
    BEGIN
        DBMS_OUTPUT.PUT_LINE('M� s? GV ' || P_MSGV || ' ?� t?n t?i.');
    END;
END PR_5533;
