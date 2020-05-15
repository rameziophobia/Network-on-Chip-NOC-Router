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

    SIGNAL X, Y, S, C : BIT;
    COMPONENT genericRegister
        GENERIC (N : INTEGER := 7);
        PORT (
            data_in : IN STD_LOGIC_VECTOR (N DOWNTO 0);
            clk, clk_en, rst : IN STD_LOGIC;
            data_out : OUT STD_LOGIC_VECTOR (N DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT DeMux
        PORT (
            d_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            d_out1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            d_out2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            d_out3 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            d_out4 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            En : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT fifo_module
        GENERIC (
            g_WIDTH : NATURAL := 8;
            g_DEPTH : INTEGER := 16
        );
        PORT (
            rst : IN std_logic;
            rclk : IN std_logic;
            wclk : IN std_logic;
            wr_en : IN std_logic; --wreq
            wr_data : IN std_logic_vector(g_WIDTH - 1 DOWNTO 0); --datain
            full : OUT std_logic;
            rd_en : IN std_logic; -- rreq
            rd_data : OUT std_logic_vector(g_WIDTH - 1 DOWNTO 0); --dataout
            empty : OUT std_logic
        );
    END COMPONENT;

    COMPONENT RR_Schedular IS
        PORT (
            clock : IN STD_LOGIC;
            din1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            din2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            din3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            din4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            dout : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    TYPE DATA_TYPE IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
    TYPE dmux_out_type IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR (7 DOWNTO 0);

    SIGNAL data_in : DATA_TYPE := (datai1, datai2, datai3, datai4);
    SIGNAL data_out : DATA_TYPE := (datao1, datao2, datao3, datao4);
    SIGNAL wr : DATA_TYPE := (wr1, wr2, wr3, wr4);
    SIGNAL input_to_dmux : DATA_TYPE;
    SIGNAL dmux_to_fifo : DATA_TYPE;
    SIGNAL fifo_to_scheduler : DATA_TYPE;

BEGIN
    GEN_INPUT_BUFFER :
    FOR i IN 0 TO 3 GENERATE
        inputBuffer : genericRegister PORT MAP
        (
            data_in => data_in(i),
            clk => wclock, clk_en => wr(i),
            rst => rst, data_out => input_to_dmux(i)
        );
    END GENERATE GEN_INPUT_BUFFER;

    GEN_DeMux :
    FOR i IN 0 TO 3 GENERATE
        demux : DeMux PORT MAP
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
            inputBuffer : fifo_module PORT MAP
            (
                rst => rst,
                rclk => rclock,
                wclk => wclock,
                wr_en => wr(j) AND (to_integer(signed(input_to_dmux(j)(1 DOWNTO 0))) = i), --wreq
                wr_data => dmux_to_fifo(j)(i), --datain
                full => OPEN,
                rd_en => '1', -- rreq -- todo check this
                rd_data => fifo_to_scheduler(i)(j), --dataout
                empty => OPEN
            );
        END GENERATE GEN_FIFO_INNER_LOOP;
    END GENERATE GEN_FIFO_OUTER_LOOP;

    GEN_RR_SCHEDULER :
    FOR i IN 0 TO 3 GENERATE
        scheduler : RR_Schedular PORT MAP
        (
            clock => rclock,
            din1 => fifo_to_scheduler(i)(0),
            din2 => fifo_to_scheduler(i)(1),
            din3 => fifo_to_scheduler(i)(2),
            din4 => fifo_to_scheduler(i)(3),
            dout => data_out(i)
        );
    END GENERATE GEN_INPUT_BUFFER;
END Structural;