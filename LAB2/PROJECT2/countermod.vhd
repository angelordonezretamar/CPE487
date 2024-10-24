-- counter.vhd --

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter IS
    PORT (
        clk, x : IN STD_LOGIC;
        count : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 
        mpx : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        Y : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        Z : OUT STD_LOGIC);
END counter;

ARCHITECTURE Behavioral OF counter IS
    SIGNAL cnt : STD_LOGIC_VECTOR (38 DOWNTO 0);  -- 39-bit counter
    SIGNAL direction : STD_LOGIC := '1';         
    SIGNAL z_int : STD_LOGIC := '0';              
    TYPE state_type IS (A, B, C, D, E);
    SIGNAL PS, NS : state_type;

BEGIN
    -- Clock process: handles counter and state updating
    PROCESS (clk)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN  
            IF direction = '1' THEN
                cnt <= cnt + 1;  
            ELSE
                cnt <= cnt - 1;  
            END IF;
            PS <= NS;  
        END IF;
    END PROCESS;

    
    count <= cnt(38 DOWNTO 23);  -- 16-bit output
    mpx <= cnt(19 DOWNTO 17);    -- 3-bit output

    -- FSM logic process
    stateAndOutputLogic: PROCESS(PS, cnt(28))
    BEGIN
        CASE PS IS
            WHEN A =>
                IF (cnt(28) = '1') THEN 
                    z_int <= '0'; 
                    NS <= B;
                ELSE 
                    z_int <= '0'; 
                    NS <= A;
                END IF;
            WHEN B =>
                IF (cnt(28) = '1') THEN 
                    z_int <= '0'; 
                    NS <= C;
                ELSE 
                    z_int <= '0'; 
                    NS <= A;
                END IF;
            WHEN C =>
                IF (cnt(28) = '1') THEN 
                    z_int <= '0'; 
                    NS <= D;
                ELSE 
                    z_int <= '0'; 
                    NS <= A;
                END IF;
            WHEN D =>
                IF (cnt(28) = '1') THEN 
                    z_int <= '0'; 
                    NS <= D;
                ELSE 
                    z_int <= '0'; 
                    NS <= E;
                END IF;
            WHEN E =>
                IF (cnt(28) = '1') THEN 
                    z_int <= '0'; 
                    NS <= B;
                ELSE 
                    z_int <= '1';  
                    NS <= A;
                END IF;
        END CASE;
    END PROCESS stateAndOutputLogic;

    -- Output Y based on the state
    WITH PS SELECT
        Y <= "000" WHEN A,
             "001" WHEN B,
             "010" WHEN C,
             "011" WHEN D,
             "100" WHEN E,
             "000" WHEN OTHERS;

    
    PROCESS (clk)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF z_int = '1' THEN
                direction <= NOT direction;  
            END IF;
        END IF;
    END PROCESS;

    
    Z <= z_int;
END Behavioral;
