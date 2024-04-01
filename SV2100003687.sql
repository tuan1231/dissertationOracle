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