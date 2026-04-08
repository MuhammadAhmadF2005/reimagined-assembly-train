DO $$
DECLARE
    movie_actor_cursor CURSOR FOR 
        SELECT m.title, a.name AS actor_name
        FROM movies m
        JOIN movie_actor ma ON m.movie_id = ma.movie_id
        JOIN actors a ON ma.actor_id = a.actor_id
        ORDER BY m.title;
    
    record_data RECORD;
BEGIN
    OPEN movie_actor_cursor;
    
    RAISE NOTICE '--- Movie and Actor List ---';
    
    LOOP
        FETCH movie_actor_cursor INTO record_data;
        
        EXIT WHEN NOT FOUND;
        
        RAISE NOTICE 'Movie: %, Actor: %', record_data.title, record_data.actor_name;
    END LOOP;
    
    CLOSE movie_actor_cursor;
END $$;