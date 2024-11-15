LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        bat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat x position
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        hit_count : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
    CONSTANT bsize : INTEGER := 8; -- ball size in pixels
    SIGNAL bat_w : INTEGER := 40; -- bat width in pixels (adjustable)
    CONSTANT bat_w_start : INTEGER := 40; -- starting bat width
    CONSTANT bat_h : INTEGER := 4; -- bat height in pixels
    -- distance ball moves each frame
    SIGNAL ball_speed : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    SIGNAL bat_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    CONSTANT bat_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(500, 11);
    SIGNAL ball_x_motion, ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL S_hit_counter : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN
    -- Color setup for red ball and cyan bat on white background
    red <= NOT bat_on;
    green <= NOT ball_on;
    blue <= NOT bat_on;

    -- Process to draw the ball
    balldraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0);
    BEGIN
        IF pixel_col <= ball_x THEN vx := ball_x - pixel_col; ELSE vx := pixel_col - ball_x; END IF;
        IF pixel_row <= ball_y THEN vy := ball_y - pixel_row; ELSE vy := pixel_row - ball_y; END IF;
        IF ((vx * vx) + (vy * vy)) < (bsize * bsize) THEN ball_on <= game_on;
        ELSE ball_on <= '0';
        END IF;
    END PROCESS;

    -- Process to draw the bat
    batdraw : PROCESS (bat_x, pixel_row, pixel_col) IS
    BEGIN
        IF ((pixel_col >= bat_x - bat_w) AND pixel_col <= bat_x + bat_w) AND
           pixel_row >= bat_y - bat_h AND pixel_row <= bat_y + bat_h THEN
            bat_on <= '1';
        ELSE
            bat_on <= '0';
        END IF;
    END PROCESS;

    -- Process to move the ball and manage hit/miss detection
    mball : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        ball_speed <= (10 DOWNTO SW'length => '0') & SW;
        WAIT UNTIL rising_edge(v_sync);

        IF serve = '1' AND game_on = '0' THEN
            game_on <= '1';
            ball_y_motion <= (NOT ball_speed) + 2;
        ELSIF ball_y <= bsize THEN
            ball_y_motion <= ball_speed;
        ELSIF ball_y + bsize >= 600 THEN
            ball_y_motion <= (NOT ball_speed) + 2;
            game_on <= '0';
            bat_w <= bat_w_start; -- Reset bat width after miss
            S_hit_counter <= (others => '0');
            hit_count <= S_hit_counter;
 -- Reset hit counter
        END IF;

        IF ball_x + bsize >= 800 THEN
            ball_x_motion <= (NOT ball_speed) + 1;
        ELSIF ball_x <= bsize THEN
            ball_x_motion <= ball_speed;
        END IF;

        IF (ball_x + bsize/2) >= (bat_x - bat_w) AND
           (ball_x - bsize/2) <= (bat_x + bat_w) AND
           (ball_y + bsize/2) >= (bat_y - bat_h) AND
           (ball_y - bsize/2) <= (bat_y + bat_h) THEN
            ball_y_motion <= (NOT ball_speed) + 1;
            
            IF bat_w > 1 THEN bat_w <= bat_w - 1; S_hit_counter <= S_hit_counter + 1; hit_count <= S_hit_counter; END IF; 
            
        END IF;

        temp := ('0' & ball_y) + (ball_y_motion(10) & ball_y_motion);
        IF game_on = '0' THEN
            ball_y <= CONV_STD_LOGIC_VECTOR(440, 11);
        ELSIF temp(11) = '1' THEN
            ball_y <= (OTHERS => '0');
        ELSE
            ball_y <= temp(10 DOWNTO 0);
        END IF;

        temp := ('0' & ball_x) + (ball_x_motion(10) & ball_x_motion);
        IF temp(11) = '1' THEN
            ball_x <= (OTHERS => '0');
        ELSE
            ball_x <= temp(10 DOWNTO 0);
        END IF;
    END PROCESS;
END Behavioral;
