`ifdef TEST_VARS
    integer test__mem__in_i;
    integer test__mem__out_i;
`endif


`ifdef TEST
    `DO_RST("test__mem_k2", 16, 2)
    fork : test__mem_k2__p1
      begin
        // store into memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        `TEST_UTIL__SEND(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__SEND(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__SEND(64'hA5A5_A5A5_A5A5_A5A5)
        `TEST_UTIL__SEND(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_k2__p2
      begin
        // load from memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})

        // load from memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_k})
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
    `DO_RST("test__mem_k1", 16, 1)
    fork : test__mem_k1__p1
      begin
        // store into memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        `TEST_UTIL__SEND(64'h1111_2222_3333_4444)
        `TEST_UTIL__SEND(64'h1411_2722_3338_4424)
        `TEST_UTIL__SEND(64'h1711_2022_7333_4454)
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_k1__p2
      begin
        // load from memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
      end

      begin
        `TEST_UTIL__RECEIVE(64'h1111_2222_3333_4444)
        `TEST_UTIL__RECEIVE(64'h1411_2722_3338_4424)
        `TEST_UTIL__RECEIVE(64'h1711_2022_7333_4454)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_k0", 16, 0)
    fork : test__mem_k0__p1
      begin
        // store into memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        `TEST_UTIL__SEND(64'h1171_2822_3353_4844)
        `TEST_UTIL__SEND(64'h1421_2721_3338_4224)
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_k0__p2
      begin
        // load from memory
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
      end

      begin
        `TEST_UTIL__RECEIVE(64'h1171_2822_3353_4844)
        `TEST_UTIL__RECEIVE(64'h1421_2721_3338_4224)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_u2", 16, 2)
    fork : test__mem_u2__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd4; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h7000_7400_7800_7C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_u2__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
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
    `DO_RST("test__mem_u1", 16, 1)
    fork : test__mem_u1__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd3; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h7000_7400_7800_7C00 ^ {4{test__mem__in_i[0+:16] + 16'd1}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_u1__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd3; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h7000_7400_7800_7C00 ^ {4{test__mem__out_i[0+:16] + 16'd1}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_u0", 16, 0)
    fork : test__mem_u0__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd2; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h7000_7400_7800_7C00 ^ {4{test__mem__in_i[0+:16] + 16'd2}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_u0__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd2; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h7000_7400_7800_7C00 ^ {4{test__mem__out_i[0+:16] + 16'd2}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_pkh2", 16, 2)
    fork : test__mem_pkh2__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd4; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h6000_6400_6800_6C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_pkh2__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
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
    `DO_RST("test__mem_pkh1", 16, 1)
    fork : test__mem_pkh1__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd3; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h6000_6400_6800_6C00 ^ {4{test__mem__in_i[0+:16] + 16'd1}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_pkh1__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd3; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h6000_6400_6800_6C00 ^ {4{test__mem__out_i[0+:16] + 16'd1}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif


//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_pkh0", 16, 0)
    fork : test__mem_pkh0__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd2; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h6000_6400_6800_6C00 ^ {4{test__mem__in_i[0+:16] + 16'd2}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_pkh0__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd2; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h6000_6400_6800_6C00 ^ {4{test__mem__out_i[0+:16] + 16'd2}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_salt2", 16, 2)
    fork : test__mem_salt2__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd8; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h4000_4400_4800_4C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_salt2__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
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
    `DO_RST("test__mem_salt1", 16, 1)
    fork : test__mem_salt1__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd6; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h4000_4400_4800_4C00 ^ {4{test__mem__in_i[0+:16] + 16'd1}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_salt1__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd6; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h4000_4400_4800_4C00 ^ {4{test__mem__out_i[0+:16] + 16'd1}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_salt0", 16, 0)
    fork : test__mem_salt0__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd4; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h4000_4400_4800_4C00 ^ {4{test__mem__in_i[0+:16] + 16'd2}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_salt0__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h4000_4400_4800_4C00 ^ {4{test__mem__out_i[0+:16] + 16'd2}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_seedSE2", 16, 2)
    fork : test__mem_seedSE2__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd8; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h5000_5400_5800_5C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_seedSE2__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
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
    `DO_RST("test__mem_seedSE1", 16, 1)
    fork : test__mem_seedSE1__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd6; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h5000_5400_5800_5C00 ^ {4{test__mem__in_i[0+:16] + 16'd1}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_seedSE1__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd6; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h5000_5400_5800_5C00 ^ {4{test__mem__out_i[0+:16] + 16'd1}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_seedSE0", 16, 0)
    fork : test__mem_seedSE0__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd4; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h5000_5400_5800_5C00 ^ {4{test__mem__in_i[0+:16] + 16'd2}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_seedSE0__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h5000_5400_5800_5C00 ^ {4{test__mem__out_i[0+:16] + 16'd2}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_RNGState", 16, 2)
    fork : test__mem_RNGState__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_RNGState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
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
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_RNGState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
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
    `DO_RST("test__mem_CRowFirst", 16, 2)
    fork : test__mem_CRowFirst__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
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
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
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
    `DO_RST("test__mem_SSState", 16, 2)
    fork : test__mem_SSState__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_SSState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
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
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_SSState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
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
    `DO_RST("test__mem_BRowFirst_straight", 16, 2)
    fork : test__mem_BRowFirst_straight__p1
      begin
        // store
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd32; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h0000_0400_0800_0C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_BRowFirst_straight__p2
      begin
        // load
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd32; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0000_0400_0800_0C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_BRowFirst_transposed", 16, 2)
    fork : test__mem_BRowFirst_transposed__p1
      begin
        // store
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd32; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'hF000_E000_D000_C000 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_BRowFirst_transposed__p2
      begin
        // load transposed
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_BColFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'hC000_C000_C000_C000 ^ {test__mem__out_i[0+:16] + 16'd4*16'd3, test__mem__out_i[0+:16] + 16'd4*16'd2, test__mem__out_i[0+:16] + 16'd4*16'd1, test__mem__out_i[0+:16] + 16'd4*16'd0})
          `TEST_UTIL__RECEIVE(64'hC000_C000_C000_C000 ^ {test__mem__out_i[0+:16] + 16'd4*16'd7, test__mem__out_i[0+:16] + 16'd4*16'd6, test__mem__out_i[0+:16] + 16'd4*16'd5, test__mem__out_i[0+:16] + 16'd4*16'd4})
          `TEST_UTIL__RECEIVE(64'hD000_D000_D000_D000 ^ {test__mem__out_i[0+:16] + 16'd4*16'd3, test__mem__out_i[0+:16] + 16'd4*16'd2, test__mem__out_i[0+:16] + 16'd4*16'd1, test__mem__out_i[0+:16] + 16'd4*16'd0})
          `TEST_UTIL__RECEIVE(64'hD000_D000_D000_D000 ^ {test__mem__out_i[0+:16] + 16'd4*16'd7, test__mem__out_i[0+:16] + 16'd4*16'd6, test__mem__out_i[0+:16] + 16'd4*16'd5, test__mem__out_i[0+:16] + 16'd4*16'd4})
          `TEST_UTIL__RECEIVE(64'hE000_E000_E000_E000 ^ {test__mem__out_i[0+:16] + 16'd4*16'd3, test__mem__out_i[0+:16] + 16'd4*16'd2, test__mem__out_i[0+:16] + 16'd4*16'd1, test__mem__out_i[0+:16] + 16'd4*16'd0})
          `TEST_UTIL__RECEIVE(64'hE000_E000_E000_E000 ^ {test__mem__out_i[0+:16] + 16'd4*16'd7, test__mem__out_i[0+:16] + 16'd4*16'd6, test__mem__out_i[0+:16] + 16'd4*16'd5, test__mem__out_i[0+:16] + 16'd4*16'd4})
          `TEST_UTIL__RECEIVE(64'hF000_F000_F000_F000 ^ {test__mem__out_i[0+:16] + 16'd4*16'd3, test__mem__out_i[0+:16] + 16'd4*16'd2, test__mem__out_i[0+:16] + 16'd4*16'd1, test__mem__out_i[0+:16] + 16'd4*16'd0})
          `TEST_UTIL__RECEIVE(64'hF000_F000_F000_F000 ^ {test__mem__out_i[0+:16] + 16'd4*16'd7, test__mem__out_i[0+:16] + 16'd4*16'd6, test__mem__out_i[0+:16] + 16'd4*16'd5, test__mem__out_i[0+:16] + 16'd4*16'd4})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_BColFirst_straight", 16, 2)
    fork : test__mem_BColFirst_straight__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_BColFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd32; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h9000_9400_9800_9C00 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_BColFirst_straight__p2
      begin
        // load
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_BColFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd32; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h9000_9400_9800_9C00 ^ {4{test__mem__out_i[0+:16]}})
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_BColFirst_transposed", 16, 2)
    fork : test__mem_BColFirst_transposed__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_BColFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd32; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'hC000_B000_A000_9000 ^ {4{test__mem__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_BColFirst_transposed__p2
      begin
        // load transposed
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h9000_9000_9000_9000 ^ {(test__mem__out_i[0+:16] << 3) + 16'd6, (test__mem__out_i[0+:16] << 3) + 16'd4, (test__mem__out_i[0+:16] << 3) + 16'd2, (test__mem__out_i[0+:16] << 3) + 16'd0})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'hA000_A000_A000_A000 ^ {(test__mem__out_i[0+:16] << 3) + 16'd6, (test__mem__out_i[0+:16] << 3) + 16'd4, (test__mem__out_i[0+:16] << 3) + 16'd2, (test__mem__out_i[0+:16] << 3) + 16'd0})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'hB000_B000_B000_B000 ^ {(test__mem__out_i[0+:16] << 3) + 16'd6, (test__mem__out_i[0+:16] << 3) + 16'd4, (test__mem__out_i[0+:16] << 3) + 16'd2, (test__mem__out_i[0+:16] << 3) + 16'd0})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'hC000_C000_C000_C000 ^ {(test__mem__out_i[0+:16] << 3) + 16'd6, (test__mem__out_i[0+:16] << 3) + 16'd4, (test__mem__out_i[0+:16] << 3) + 16'd2, (test__mem__out_i[0+:16] << 3) + 16'd0})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h9000_9000_9000_9000 ^ {(test__mem__out_i[0+:16] << 3) + 16'd7, (test__mem__out_i[0+:16] << 3) + 16'd5, (test__mem__out_i[0+:16] << 3) + 16'd3, (test__mem__out_i[0+:16] << 3) + 16'd1})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'hA000_A000_A000_A000 ^ {(test__mem__out_i[0+:16] << 3) + 16'd7, (test__mem__out_i[0+:16] << 3) + 16'd5, (test__mem__out_i[0+:16] << 3) + 16'd3, (test__mem__out_i[0+:16] << 3) + 16'd1})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'hB000_B000_B000_B000 ^ {(test__mem__out_i[0+:16] << 3) + 16'd7, (test__mem__out_i[0+:16] << 3) + 16'd5, (test__mem__out_i[0+:16] << 3) + 16'd3, (test__mem__out_i[0+:16] << 3) + 16'd1})
        end
        for(test__mem__out_i = 0; test__mem__out_i < 15'd4; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'hC000_C000_C000_C000 ^ {(test__mem__out_i[0+:16] << 3) + 16'd7, (test__mem__out_i[0+:16] << 3) + 16'd5, (test__mem__out_i[0+:16] << 3) + 16'd3, (test__mem__out_i[0+:16] << 3) + 16'd1})
        end

        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`define test__mem_SRowFirst__p1__mixer(a)  { a[2]^a[6]^a[9]^a[12], a[1]^a[5]^a[8]^a[11], a[0]^a[4]^a[7]^a[10] }
`define test__mem_SRowFirst__p1__mixer__std(a, l)  { {13{a[3]}}, `test__mem_SRowFirst__p1__mixer(a)^l }
`define test__mem_SRowFirst__p1__mixer__compact(a, l)  { a[3] ? - (`test__mem_SRowFirst__p1__mixer(a)^l) : `test__mem_SRowFirst__p1__mixer(a)^l, a[3] }

`ifdef TEST
    `DO_RST("test__mem_SRowFirst", 16, 2)
    fork : test__mem_SRowFirst__p1
      begin
        // store
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd32; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND({
            `test__mem_SRowFirst__p1__mixer__std(test__mem__in_i, 2'd3),
            `test__mem_SRowFirst__p1__mixer__std(test__mem__in_i, 2'd2),
            `test__mem_SRowFirst__p1__mixer__std(test__mem__in_i, 2'd1),
            `test__mem_SRowFirst__p1__mixer__std(test__mem__in_i, 2'd0)
          })
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_SRowFirst__p2
      begin
        // load
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_SRowFirst_DBG})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd32; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE({
            48'b0,
            `test__mem_SRowFirst__p1__mixer__compact(test__mem__out_i, 2'd3),
            `test__mem_SRowFirst__p1__mixer__compact(test__mem__out_i, 2'd2),
            `test__mem_SRowFirst__p1__mixer__compact(test__mem__out_i, 2'd1),
            `test__mem_SRowFirst__p1__mixer__compact(test__mem__out_i, 2'd0)
          })
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_SRowFirst_largeS", 16, 0)
    fork : test__mem_SRowFirst_largeS__p1
      begin
        // store
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for(test__mem__in_i = 0; test__mem__in_i < 15'd32; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND({
            32'b0,
            { 12'b0, test__mem__in_i[0+:4] },
            -{ 12'b0, test__mem__in_i[0+:4] }
          })
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_SRowFirst_largeS__p2
      begin
        // load
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_SRowFirst_DBG})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__mem__out_i = 0; test__mem__out_i < 15'd32; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE({
            48'b0,
            { 3'b0, test__mem__out_i[0+:4] , 1'b0 },
            { 3'b0, test__mem__out_i[0+:4] , (test__mem__out_i[0+:4] == 0 ? 1'b0 : 1'b1) }
          })
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_noOverlap", 1344, 2)
    fork : test__mem_noOverlap__p1  // store
      begin
        // S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // u
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // pkh
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
        
        // salt
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
        
        // seedSE
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // rngState
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_RNGState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
        
        // c
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
        
        // SSState
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_SSState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
        
        // b
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        // S
        for(test__mem__in_i = 0; test__mem__in_i < 15'd2688; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND({
            `test__mem_SRowFirst__p1__mixer__std(test__mem__in_i, 2'd3),
            `test__mem_SRowFirst__p1__mixer__std(test__mem__in_i, 2'd2),
            `test__mem_SRowFirst__p1__mixer__std(test__mem__in_i, 2'd1),
            `test__mem_SRowFirst__p1__mixer__std(test__mem__in_i, 2'd0)
          })
        end

        // k, u, pkh, salt, seedSE, rngState, c, SSState
        for(test__mem__in_i = 0; test__mem__in_i < 15'd77 + 15'd2688; test__mem__in_i = test__mem__in_i+1) begin
          `TEST_UTIL__SEND(64'h0000_4000_8000_C000 ^ {4{test__mem__in_i[0+:16]}})
        end
        
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_noOverlap__p2 // load
      begin
        // S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_SRowFirst_DBG})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})

        // u
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // pkh
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // salt
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_salt})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // seedSE
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // rngState
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_RNGState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        
        // c
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        
        // SSState
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_SSState})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        
        // b
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        // S
        for(test__mem__out_i = 0; test__mem__out_i < 15'd2688; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE({
            48'b0,
            `test__mem_SRowFirst__p1__mixer__compact(test__mem__out_i, 2'd3),
            `test__mem_SRowFirst__p1__mixer__compact(test__mem__out_i, 2'd2),
            `test__mem_SRowFirst__p1__mixer__compact(test__mem__out_i, 2'd1),
            `test__mem_SRowFirst__p1__mixer__compact(test__mem__out_i, 2'd0)
          })
        end

        // k, u, pkh, salt, seedSE, rngState, c, SSState
        for(test__mem__out_i = 0; test__mem__out_i < 15'd77 + 15'd2688; test__mem__out_i = test__mem__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0000_4000_8000_C000 ^ {4{test__mem__out_i[0+:16]}})
        end
        
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

// TODO  make sure which interpretation of the padding is right, and fix the tests

/*
`ifdef TEST
    `DO_RST("test__mem_pack16", 16, 2)
    fork : test__mem_pack16__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        `TEST_UTIL__SEND(64'h0000_0001_0010_000f)
        `TEST_UTIL__SEND(64'h00ff_3300_0033_ff00)
        `TEST_UTIL__SEND(64'h1000_f000_0000_ffff)
        `TEST_UTIL__SEND(64'h5551_0000_00CC_0000)
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_pack16__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b1, `MemAndMulCMD_out_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        `TEST_UTIL__RECEIVE(64'h0000_8000_0800_f000)
        `TEST_UTIL__RECEIVE(64'hff00_00CC_CC00_00ff)
        `TEST_UTIL__RECEIVE(64'h0008_000f_0000_ffff)
        `TEST_UTIL__RECEIVE(64'h8aaa_0000_3300_0000)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__mem_unpack16", 16, 2)
    fork : test__mem_unpack16__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b1, `MemAndMulCMD_in_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        `TEST_UTIL__SEND(64'h0000_0001_0010_000f)
        `TEST_UTIL__SEND(64'h00ff_3300_0033_ff00)
        `TEST_UTIL__SEND(64'h1000_f000_0000_ffff)
        `TEST_UTIL__SEND(64'h5551_0000_00CC_0000)
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_unpack16__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_pkh})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        `TEST_UTIL__RECEIVE(64'h0000_8000_0800_f000)
        `TEST_UTIL__RECEIVE(64'hff00_00CC_CC00_00ff)
        `TEST_UTIL__RECEIVE(64'h0008_000f_0000_ffff)
        `TEST_UTIL__RECEIVE(64'h8aaa_0000_3300_0000)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    integer test__mem_pack15_i;
    reg [1024-1:0] test__mem_pack15_in;
    reg [960-1:0] test__mem_pack15_out;
`endif

`ifdef TEST
    `DO_RST("test__mem_pack15", 16, 0)    
    for (test__mem_pack15_i = 0; test__mem_pack15_i < 64; test__mem_pack15_i=test__mem_pack15_i+1) begin
      test__mem_pack15_in [test__mem_pack15_i*16+:16] = {test__mem_pack15_i[0+:6], 10'b0};
      test__mem_pack15_out[test__mem_pack15_i*15+:15] = {test__mem_pack15_i[0+:5], 10'b0};
    end
    fork : test__mem_pack15__p1  
      begin  
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for (test__mem_pack15_i = 0; test__mem_pack15_i < 16; test__mem_pack15_i=test__mem_pack15_i+1) begin
          `TEST_UTIL__SEND(test__mem_pack15_in[test__mem_pack15_i*64+:64])
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_pack15__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b1, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for (test__mem_pack15_i = 0; test__mem_pack15_i < 15; test__mem_pack15_i=test__mem_pack15_i+1) begin
          `TEST_UTIL__RECEIVE(test__mem_pack15_out[test__mem_pack15_i*64+:64])
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    integer test__mem_unpack15_i;
    reg [960-1:0] test__mem_unpack15_in;
    reg [1024-1:0] test__mem_unpack15_out;
`endif

`ifdef TEST
    `DO_RST("test__mem_unpack15", 16, 0)
    for (test__mem_unpack15_i = 0; test__mem_unpack15_i < 64; test__mem_unpack15_i=test__mem_unpack15_i+1) begin
      test__mem_unpack15_in [test__mem_unpack15_i*15+:15] = {      test__mem_unpack15_i[0+:5], 10'b0};
      test__mem_unpack15_out[test__mem_unpack15_i*16+:16] = {1'b0, test__mem_unpack15_i[0+:5], 10'b0};
    end
    fork : test__mem_unpack15__p1
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b1, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for (test__mem_unpack15_i = 0; test__mem_unpack15_i < 15; test__mem_unpack15_i=test__mem_unpack15_i+1) begin
          `TEST_UTIL__SEND(test__mem_unpack15_in[test__mem_unpack15_i*64+:64])
        end
       `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_unpack15__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for (test__mem_unpack15_i = 0; test__mem_unpack15_i < 16; test__mem_unpack15_i=test__mem_unpack15_i+1) begin
          `TEST_UTIL__RECEIVE(test__mem_unpack15_out[test__mem_unpack15_i*64+:64])
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif


//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    integer test__mem_nopackThenPack15_i;
    reg [1024-1:0] test__mem_nopackThenPack15_in;
    reg [960-1:0] test__mem_nopackThenPack15_out;
`endif

`ifdef TEST
    `DO_RST("test__mem_nopackThenPack15", 16, 0)
    for (test__mem_nopackThenPack15_i = 0; test__mem_nopackThenPack15_i < 64; test__mem_nopackThenPack15_i=test__mem_nopackThenPack15_i+1) begin
      test__mem_nopackThenPack15_in [test__mem_nopackThenPack15_i*16+:16] = {test__mem_nopackThenPack15_i[0+:6], 10'b0};
      test__mem_nopackThenPack15_out[test__mem_nopackThenPack15_i*15+:15] = {test__mem_nopackThenPack15_i[0+:5], 10'b0};
    end
    fork : test__mem_nopackThenPack15__p1  
      begin  
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
      end

      begin
        for (test__mem_nopackThenPack15_i = 0; test__mem_nopackThenPack15_i < 16; test__mem_nopackThenPack15_i=test__mem_nopackThenPack15_i+1) begin
          `TEST_UTIL__SEND(test__mem_nopackThenPack15_in[test__mem_nopackThenPack15_i*64+:64])
        end
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_nopackThenPack15__p2
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b0, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, 1'b1, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for (test__mem_nopackThenPack15_i = 0; test__mem_nopackThenPack15_i < 16; test__mem_nopackThenPack15_i=test__mem_nopackThenPack15_i+1) begin
          `TEST_UTIL__RECEIVE(test__mem_nopackThenPack15_in[test__mem_nopackThenPack15_i*64+:64])
        end

        for (test__mem_nopackThenPack15_i = 0; test__mem_nopackThenPack15_i < 15; test__mem_nopackThenPack15_i=test__mem_nopackThenPack15_i+1) begin
          `TEST_UTIL__RECEIVE(test__mem_nopackThenPack15_out[test__mem_nopackThenPack15_i*64+:64])
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

*/


// TODO: test fake send and fake receive

