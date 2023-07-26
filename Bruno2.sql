-----------------------------TESTE PL/SQL TREINO-----------------------------------------
CREATE FUNCTION DURACAO_ULTIMO_INTERNAMENTO (utNIF IN NUMBER, intEspec IN VARCHAR2, ano IN NUMBER)
RETURN NUMBER AS

intDuracao NUMBER;

BEGIN 
  BEGIN
  ---SELECT da existência de um NIF do utente---
  SELECT nif from utente 
  where nif = utNIF; 
  IF utNIF IS NULL THEN
    RAISE_APPLICATION_ERROR(-20203,'Utente com o nif '  || utNIF || 'inexistente'); 
  END IF;
  END;
  
  BEGIN
  --- SELECT para verificar a especialidade onde o utente esteve num determinado ano--- 
  SELECT *
  FROM INTERNAMENTO I, UTENTE U
  WHERE I.codUtente = U.codUtente AND I.Especialidade = intEspec 
  AND U.nif = utNIF AND TO_CHAR(I.dataIntern,'YYYY') = ano;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20201, 'Utente com o nif ' || utNIF || 'não esteve internado na especialidade de ' || intEspec || ' nesse ano.');
  END;
  
  BEGIN
  ---SELECT para verificar se o internamento ja acabou--- 
  SELECT duracao INTO intDuracao
  FROM INTERNAMENTO I, TERMINO T, UTENTE U
  WHERE I.codUtente = u.codUtente AND I.codIntern = T.codIntern 
  AND I.Especialidade = intEspec AND U.nif = utNIF AND UPPER(T.tipoTermino) = 'TERMINADO'
  ORDER BY I.dataIntern DESC;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20202, 'O último internamento do utente com o nif '|| utNIF || 'nesse ano , na especialidade de ' || intEsp || ' ainda não terminou.');
  END;
  
  RETURN intDuracao;
END;