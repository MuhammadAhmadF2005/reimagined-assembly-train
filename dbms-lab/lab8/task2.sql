CREATE OR REPLACE FUNCTION get_actor_count(p_movie_id INT) 
RETURNS INT 
LANGUAGE plpgsql
AS $$
DECLARE
    v_actor_count INT;
BEGIN
    SELECT COUNT(actor_id) INTO v_actor_count
    FROM movie_actor
    WHERE movie_id = p_movie_id;
    
    RETURN v_actor_count;
END;
$$;