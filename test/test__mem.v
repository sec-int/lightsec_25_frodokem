`ifdef TEST_VARS
    integer test__mem__in_i;
    integer test__mem__out_i;
`endif


`ifdef TEST
    `DO_RST("test__mem_k")
    fork : test__mem_k__p1
      begin
        // store into memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
      end

      begin
        `TEST_UTIL__SEND(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__SEND(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__SEND(64'hA5A5_A5A5_A5A5_A5A5)
        `TEST_UTIL__SEND(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_k__p2
      begin
        // load from memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})

        // load from memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
      end

      begin
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__RECEIVE(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__RECEIVE(64'hA5A5_A5A5_A5A5_A5A5)
        `TEST_UTIL__RECEIVE(64'h5A5A_5A5A_5A5A_5A5A)

        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__RECEIVE(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__RECEIVE(64'hA5A5_A5A5_A5A5_A5A5)
        `TEST_UTIL__RECEIVE(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_u")
    fork : test__mem_u__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd4; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h7000_7400_7800_7C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_u__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd4})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h7000_7400_7800_7C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_pkh")
    fork : test__mem_pkh__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd4; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h6000_6400_6800_6C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_pkh__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd4})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h6000_6400_6800_6C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_salt")
    fork : test__mem_salt__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd8})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd8; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h4000_4400_4800_4C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_salt__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd8})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd8; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h4000_4400_4800_4C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_seedSE")
    fork : test__mem_seedSE__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd8})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd8; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h5000_5400_5800_5C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_seedSE__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd8})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd8; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h5000_5400_5800_5C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_RNGState")
    fork : test__mem_RNGState__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_RNGState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd8})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd8; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h3000_3400_3800_3C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_RNGState__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_RNGState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd8})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd8; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h3000_3400_3800_3C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_CRowFirst")
    fork : test__mem_CRowFirst__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd16})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd16; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h1000_1400_1800_1C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_CRowFirst__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd16})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd16; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h1000_1400_1800_1C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_SSState")
    fork : test__mem_SSState__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SSState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd25})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd25; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h2000_2400_2800_2C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_SSState__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_SSState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd25})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd25; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h2000_2400_2800_2C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_BRowFirst")
    fork : test__mem_BRowFirst__p1
      begin
        // store
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd2688})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd2688; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h0000_0400_0800_0C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_BRowFirst__p2
      begin
        // load
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2688})

        // load transposed
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_BColFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2688})
      end

      begin
        // load
        for(test__mem__out_i = 0; test__mem__out_i < 15'd2688; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0000_0400_0800_0C00 ^ {4{test__mem__out_i[0+:16]}})
        end

        // load transposed
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0000_0000_0000_0000 ^ {test__mem__out_i[0+:16] + 16'd336*16'd0, test__mem__out_i[0+:16] + 16'd336*16'd1, test__mem__out_i[0+:16] + 16'd336*16'd2, test__mem__out_i[0+:16] + 16'd336*16'd3})
          `TEST_UTIL__RECEIVE(64'h0000_0000_0000_0000 ^ {test__mem__out_i[0+:16] + 16'd336*16'd4, test__mem__out_i[0+:16] + 16'd336*16'd5, test__mem__out_i[0+:16] + 16'd336*16'd6, test__mem__out_i[0+:16] + 16'd336*16'd7})
          `TEST_UTIL__RECEIVE(64'h0400_0400_0400_0400 ^ {test__mem__out_i[0+:16] + 16'd336*16'd0, test__mem__out_i[0+:16] + 16'd336*16'd1, test__mem__out_i[0+:16] + 16'd336*16'd2, test__mem__out_i[0+:16] + 16'd336*16'd3})
          `TEST_UTIL__RECEIVE(64'h0400_0400_0400_0400 ^ {test__mem__out_i[0+:16] + 16'd336*16'd4, test__mem__out_i[0+:16] + 16'd336*16'd5, test__mem__out_i[0+:16] + 16'd336*16'd6, test__mem__out_i[0+:16] + 16'd336*16'd7})
          `TEST_UTIL__RECEIVE(64'h0800_0800_0800_0800 ^ {test__mem__out_i[0+:16] + 16'd336*16'd0, test__mem__out_i[0+:16] + 16'd336*16'd1, test__mem__out_i[0+:16] + 16'd336*16'd2, test__mem__out_i[0+:16] + 16'd336*16'd3})
          `TEST_UTIL__RECEIVE(64'h0800_0800_0800_0800 ^ {test__mem__out_i[0+:16] + 16'd336*16'd4, test__mem__out_i[0+:16] + 16'd336*16'd5, test__mem__out_i[0+:16] + 16'd336*16'd6, test__mem__out_i[0+:16] + 16'd336*16'd7})
          `TEST_UTIL__RECEIVE(64'h0C00_0C00_0C00_0C00 ^ {test__mem__out_i[0+:16] + 16'd336*16'd0, test__mem__out_i[0+:16] + 16'd336*16'd1, test__mem__out_i[0+:16] + 16'd336*16'd2, test__mem__out_i[0+:16] + 16'd336*16'd3})
          `TEST_UTIL__RECEIVE(64'h0C00_0C00_0C00_0C00 ^ {test__mem__out_i[0+:16] + 16'd336*16'd4, test__mem__out_i[0+:16] + 16'd336*16'd5, test__mem__out_i[0+:16] + 16'd336*16'd6, test__mem__out_i[0+:16] + 16'd336*16'd7})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_BColFirst")
    fork : test__mem_BColFirst__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BColFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd2688})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd2688; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h9000_9400_9800_9C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_BColFirst__p2
      begin
        // load
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_BColFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2688})

        // load transposed
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2688})
      end

      begin
        // load
        for(test__mem__out_i = 0; test__mem__out_i < 15'd2688; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h9000_9400_9800_9C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        
        // load transpose
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0000_0000_0000_0000 ^ {test__mem__out_i[0+:16] << 3 + 16'd0, test__mem__out_i[0+:16] << 3 + 16'd2, test__mem__out_i[0+:16] << 3 + 16'd4, test__mem__out_i[0+:16] << 3 + 16'd6})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0400_0400_0400_0400 ^ {test__mem__out_i[0+:16] << 3 + 16'd0, test__mem__out_i[0+:16] << 3 + 16'd2, test__mem__out_i[0+:16] << 3 + 16'd4, test__mem__out_i[0+:16] << 3 + 16'd6})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0800_0800_0800_0800 ^ {test__mem__out_i[0+:16] << 3 + 16'd0, test__mem__out_i[0+:16] << 3 + 16'd2, test__mem__out_i[0+:16] << 3 + 16'd4, test__mem__out_i[0+:16] << 3 + 16'd6})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0C00_0C00_0C00_0C00 ^ {test__mem__out_i[0+:16] << 3 + 16'd0, test__mem__out_i[0+:16] << 3 + 16'd2, test__mem__out_i[0+:16] << 3 + 16'd4, test__mem__out_i[0+:16] << 3 + 16'd6})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0000_0000_0000_0000 ^ {test__mem__out_i[0+:16] << 3 + 16'd1 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd3 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd5 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd7 + 16'd1344})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0400_0400_0400_0400 ^ {test__mem__out_i[0+:16] << 3 + 16'd1 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd3 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd5 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd7 + 16'd1344})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0800_0800_0800_0800 ^ {test__mem__out_i[0+:16] << 3 + 16'd1 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd3 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd5 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd7 + 16'd1344})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd336; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0C00_0C00_0C00_0C00 ^ {test__mem__out_i[0+:16] << 3 + 16'd1 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd3 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd5 + 16'd1344, test__mem__out_i[0+:16] << 3 + 16'd7 + 16'd1344})
        end

        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

