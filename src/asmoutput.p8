; This handles the actual output of the machine code bytes.
; This is mostly ran in phase 2 of the assembler.
; (phase 1 just tracks the programcounter)

%import textio
%import errors

output {
    uword program_counter = $ffff
    uword pc_min = $ffff
    uword pc_max = $0000
    ubyte start_output_bank
    ubyte next_output_bank
    uword bank_output_addr

    sub init(ubyte phase) {
        ; nothing special yet
        ; if phase==2, pc_min and pc_max have been set in phase1 to indicate the block of memory
        ; that is going to be filled with the output, this info could be useful for something

        when phase {
            1 -> {
                ubyte numbanks = cx16.numbanks()
                if numbanks<10 {
                    err.print("too few ram banks (needs 10 or more)")
                    sys.exit(1)
                }
                start_output_bank = numbanks-8        ; 8 top banks = 64 kilobyte output size
            }
            2 -> {
                next_output_bank = start_output_bank
                bank_output_addr = $c000    ; trigger immediate bank select at first emit()
            }
        }
    }

    sub set_pc(uword addr) {
        program_counter = addr
        if program_counter<pc_min
            pc_min = program_counter
        if program_counter>pc_max
            pc_max = program_counter
    }

    sub inc_pc(ubyte num_operand_bytes) {
        program_counter++
        program_counter += num_operand_bytes
    }

    sub emit(ubyte value) {
        if msb(bank_output_addr) == $c0 {
            ; address has reached $c000, switch to next output ram bank
            cx16.rambank(next_output_bank)
            bank_output_addr = $a000        ; start address of 8kb banked ram
            next_output_bank++
        }

        @(bank_output_addr) = value
        program_counter++
        bank_output_addr++
    }

    sub done() {
        if program_counter>pc_max
            pc_max = program_counter
    }
}
