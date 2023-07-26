CREATE TRIGGER UPDATE_INTERNAMENTOS AFTER
INSERT ON TERMINO
FOR EACH ROW

BEGIN 
  UPDATE TEMP SET col2 = new.duracao,
  (message1, message2) IN (
    SELECT U.nome, I.especialidade 
    FROM INTERNAMENTO I, UTENTE U
    WHERE I.codUtente = U.codUtente
    AND I.codIntern = new.I.codIntern
    WHEN col2 < 0
  );
END;