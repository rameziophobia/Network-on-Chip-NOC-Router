# Dual Port Ram

> Dual-Port Block RAM with Different Clocks

## Behavior

> Port A (write) is synchronized with CLKA and port B (read) is synchronized with CLKB.

## Pin Definitions

| IO Pin      | In/Out | Description                |
| ----------- | ------ | -------------------------- |
| d_in [7:0]  | In     | Data Input                 |
| d_out [7:0] | Out    | Data Output                |
| WEA         | In     | Write enable (active high) |
| REA         | In     | Read enable (active high)  |
| ADDRA [2:0] | In     | Write port (A) address bus |
| ADDRB [2:0] | In     | Read port (B) address bus  |
| CLKA        | In     | Clock signal for port A    |
| CLKB        | In     | Clock signal for port B    |

## Testbench

| Test case # | addr_a | addr_b | wea | rea | d_out         |
| :---------: | ------ | ------ | --- | --- | ------------- |
|      1      | 000    | 000    | 1   | 1   | d_in          |
