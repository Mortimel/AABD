CREATE PROCEDURE INTERNAMENTOS_CIDADE (vcidade IN VARCHAR2, vano IN NUMBER)
IS 
---Criação de Cursores para o utente e especialidade mediante a morada---
 
  CURSOR c1 IS
  SELECT nif
  FROM UTENTES
  WHERE UPPER(morada) = UPPER(vcidade);
  
  CURSOR c2 IS
  SELECT DISTINCT especialidade
  FROM MEDICO
  WHERE UPPER(morada) = UPPER(vcidade);
  
  vduracao NUMBER;
  
---Declarar a Excepção tratada na função anterior---
NAO_TERMINOU EXCEPTION;
  PRAGMA EXCEPTION_INIT (NAO_TERMINOU,-20202);

BEGIN
      DELETE FROM TEMP;
FOR Esp in c2
  LOOP
    FOR Ut in c1
      LOOP   
  ---Chama a funçao e trata das excepções---
       BEGIN
        vduracao := DURACAO_ULTIMO_INTERNAMENTO (utNIF, Esp , vano);
    
        EXCEPTION 
          WHEN EXCEPTION THEN 
          INSERT INTO TEMP (col1, col2, message1, message2)
          VALUES (vano, NAO_TERMINOU, Ut.nome, Esp.especialidade);
    
       END;
     END LOOP;
  END LOOP;
  
  INSERT INTO TEMP (col1, col2, message1, message2)
  VALUES (vano, vduracao, Ut.nome, Esp.especialidade);
END;