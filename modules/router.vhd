LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY router IS
    GENERIC (N : INTEGER := 7);
    PORT (
        datai1, datai2, datai3, datai4 : IN STD_LOGIC_VECTOR (N DOWNTO 0);
        wr1, wr2, wr3, wr4 : IN STD_LOGIC;
        wclock, rclock, rst : IN STD_LOGIC;
        datao1, datao2, datao3, datao4 : OUT STD_LOGIC_VECTOR (N DOWNTO 0));
END router;

ARCHITECTURE Structural OF router IS

    TYPE ARRAY4x8 IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
    TYPE ARRAY4x4x8 IS ARRAY (0 TO 3) OF ARRAY4x8;
    TYPE ARRAY4x4 IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (0 TO 3);
    TYPE dmux_out_type IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (7 DOWNTO 0);

    SIGNAL data_in : ARRAY4x8;
    SIGNAL data_out : ARRAY4x8;
    SIGNAL wr : STD_LOGIC_VECTOR (0 TO 3);
    SIGNAL input_to_dmux : ARRAY4x8;
    SIGNAL dmux_to_fifo : ARRAY4x4x8;
    SIGNAL fifo_to_scheduler : ARRAY4x4x8;
    SIGNAL fifo_empty : ARRAY4x4;
    SIGNAL fifo_full : ARRAY4x4;
    SIGNAL fifo_equal : ARRAY4x4;
    SIGNAL fifo_wr_en : ARRAY4x4;

    SIGNAL current_fifo_state : std_logic_vector(3 downto 0) := "1000";
    SIGNAL next_fifo_state : std_logic_vector(3 downto 0) := "0100";

BEGIN
    GEN_INPUT_BUFFER :
    FOR i IN 0 TO 3 GENERATE
        inputBuffer : ENTITY work.genericRegister PORT MAP
            (
            data_in => data_in(i),
            clk => wclock, clk_en => wr(i),
            rst => rst, data_out => input_to_dmux(i)
            );
    END GENERATE GEN_INPUT_BUFFER;

    GEN_DeMux :
    FOR i IN 0 TO 3 GENERATE
        demux : ENTITY work.demux PORT MAP
            (
            d_in => input_to_dmux(i),
            d_out1 => dmux_to_fifo(i)(0),
            d_out2 => dmux_to_fifo(i)(1),
            d_out3 => dmux_to_fifo(i)(2),
            d_out4 => dmux_to_fifo(i)(3),
            Sel => input_to_dmux(i)(1 DOWNTO 0), -- todo check this -- todo typo?
            En => wr(i) -- todo check this
            );
    END GENERATE GEN_DeMux;

    GEN_FIFO_OUTER_LOOP :
    FOR i IN 0 TO 3 GENERATE -- for each output buffer
        GEN_FIFO_INNER_LOOP :
        FOR j IN 0 TO 3 GENERATE -- for each fifo per buffer  
            SIGNAL equal : STD_LOGIC;
            SIGNAL wr_en : STD_LOGIC;
            SIGNAL rreq : STD_LOGIC;
        BEGIN
            equal <= '1' WHEN (to_integer(signed(input_to_dmux(j)(1 DOWNTO 0))) = i) ELSE
                '0';
            wr_en <= '1' AND equal AND NOT fifo_full(i)(j) AND wclock;
            rreq <= "NOT"(fifo_empty(i)(j)) AND current_fifo_state(j);
            fifo : ENTITY work.module_fifo PORT MAP
                (
                reset => rst,
                wclk => wclock,
                rclk => rclock,
                rreq => rreq, -- todo check this
                wreq => wr_en,
                datain => dmux_to_fifo(j)(i),
                dataout => fifo_to_scheduler(i)(j),
                empty => fifo_empty(i)(j),
                full => fifo_full(i)(j)
                );
        END GENERATE GEN_FIFO_INNER_LOOP;
    END GENERATE GEN_FIFO_OUTER_LOOP;

    GEN_RR_SCHEDULER :
    FOR i IN 0 TO 3 GENERATE
        scheduler : ENTITY work.RR_Schedular PORT MAP
            (
            clock => rclock,
            din1 => fifo_to_scheduler(i)(0),
            din2 => fifo_to_scheduler(i)(1),
            din3 => fifo_to_scheduler(i)(2),
            din4 => fifo_to_scheduler(i)(3),
            dout => data_out(i)
            );
    END GENERATE GEN_RR_SCHEDULER;

    current_fifo_state_proc : PROCESS (wclock)
    BEGIN
        IF rst = '1' THEN
            current_fifo_state <= "0001";
        ELSIF falling_edge(wclock) THEN
            current_fifo_state <= next_fifo_state;
        END IF;
    END PROCESS;

    next_fifo_state_proc : PROCESS (current_fifo_state)
    BEGIN
        CASE current_fifo_state IS
            WHEN "1000" =>
                next_fifo_state <= "0100";
            WHEN "0100" =>
                next_fifo_state <= "0010";
            WHEN "0010" =>
                next_fifo_state <= "0001";
            WHEN "0001" =>
                next_fifo_state <= "1000";
            WHEN OTHERS =>
                next_fifo_state <= "1000";
        END CASE;
    END PROCESS;

    datao1 <= data_out(0);
    datao2 <= data_out(1);
    datao3 <= data_out(2);
    datao4 <= data_out(3);
    data_in <= (datai1, datai2, datai3, datai4);
    wr <= (wr1, wr2, wr3, wr4);
END Structural;