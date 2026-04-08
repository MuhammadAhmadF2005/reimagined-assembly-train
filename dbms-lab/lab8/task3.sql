CREATE TABLE movie_update_log (
    log_id SERIAL PRIMARY KEY,
    movie_id INT,
    old_release_year INT,
    new_release_year INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--first we create a table to store the logs ...

CREATE OR REPLACE PROCEDURE update_movie_year(p_movie_id INT, p_new_year INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_year INT;
BEGIN
    SELECT release_year INTO v_old_year
    FROM movies
    WHERE movie_id = p_movie_id;

    IF NOT FOUND THEN
        RAISE NOTICE 'Movie with ID % not found.', p_movie_id;
        RETURN;
    END IF;

    UPDATE movies
    SET release_year = p_new_year
    WHERE movie_id = p_movie_id;

    INSERT INTO movie_update_log (movie_id, old_release_year, new_release_year)
    VALUES (p_movie_id, v_old_year, p_new_year);
    
    RAISE NOTICE 'Movie ID % updated successfully from % to %.', p_movie_id, v_old_year, p_new_year;
END;
$$;