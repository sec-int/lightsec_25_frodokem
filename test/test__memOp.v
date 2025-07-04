`ifdef TEST_VARS
    integer test__memOp__in_i;
    integer test__memOp__out_i;
`endif


`ifdef TEST
    `DO_RST("test__memOp_erase1", 16)
    fork : test__memOp_erase1
      begin
        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // erase
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_Erase1})

        // load S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_SRowFirst_DBG})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0001_0001_0001_0001)
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd32; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0)
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_erase2", 16)
    fork : test__memOp_erase2
      begin
        // store u
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store SeedSE
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})


        // erase
       `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_Erase2})


        // load u
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // load SeedSE
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_seedSE})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // load k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4 + 15'd8 + 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0001_0001_0001_0001)
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd4 + 15'd8 + 15'd4; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0)
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_erase3", 16)
    fork : test__memOp_erase3
      begin
        // store B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})


        // erase
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_Erase3})


        // load B'
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16 + 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0001_0001_0001_0001)
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd16 + 15'd32; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0)
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_addToC", 16)
    fork : test__memOp_addToC
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // add to C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_addCRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h1000_1400_1800_CC00 ^ {4{test__memOp__in_i[0+:16]}})
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h3000_3400_3800_CC00 ^ {4{test__memOp__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd16; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE({
            (16'h1000 ^ test__memOp__out_i[0+:16]) + (16'h3000 ^ test__memOp__out_i[0+:16]),
            (16'h1400 ^ test__memOp__out_i[0+:16]) + (16'h3400 ^ test__memOp__out_i[0+:16]),
            (16'h1800 ^ test__memOp__out_i[0+:16]) + (16'h3800 ^ test__memOp__out_i[0+:16]),
            (16'hCC00 ^ test__memOp__out_i[0+:16]) + (16'hCC00 ^ test__memOp__out_i[0+:16])
          })
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_addToC_del1", 16)
    fork : test__memOp_addToC_del1
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // add to C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_addCRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          #1;
          `TEST_UTIL__SEND(64'h1000_1400_1800_1C00 ^ {4{test__memOp__in_i[0+:16]}})
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          #1;
          `TEST_UTIL__SEND(64'h3000_3400_3800_3C00 ^ {4{test__memOp__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd16; test__memOp__out_i = test__memOp__out_i+1) begin
          #1;
          `TEST_UTIL__RECEIVE({
            (16'h1000 ^ test__memOp__out_i[0+:16]) + (16'h3000 ^ test__memOp__out_i[0+:16]),
            (16'h1400 ^ test__memOp__out_i[0+:16]) + (16'h3400 ^ test__memOp__out_i[0+:16]),
            (16'h1800 ^ test__memOp__out_i[0+:16]) + (16'h3800 ^ test__memOp__out_i[0+:16]),
            (16'h1C00 ^ test__memOp__out_i[0+:16]) + (16'h3C00 ^ test__memOp__out_i[0+:16])
          })
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_addToMinusB", 16)
    fork : test__memOp_addToMinusB
      begin
        // store B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // add to minus B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_BeqInMinB})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // load B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h1000_C400_1800_CC00 ^ {4{test__memOp__in_i[0+:16]}})
        end
        
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h3000_3400_C800_CC00 ^ {4{test__memOp__in_i[0+:16]}})
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd32; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE({
            (16'h3000 ^ test__memOp__out_i[0+:16]) - (16'h1000 ^ test__memOp__out_i[0+:16]),
            (16'h3400 ^ test__memOp__out_i[0+:16]) - (16'hC400 ^ test__memOp__out_i[0+:16]),
            (16'hC800 ^ test__memOp__out_i[0+:16]) - (16'h1800 ^ test__memOp__out_i[0+:16]),
            (16'hCC00 ^ test__memOp__out_i[0+:16]) - (16'hCC00 ^ test__memOp__out_i[0+:16])
          })
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CeqU", 16)
    fork : test__memOp_CeqU
      begin
        // store u
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // assign
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_CeqU})

        // load c
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({4{
            2'h0, test__memOp__in_i[0+:2],
            2'h1, test__memOp__in_i[0+:2],
            2'h2, test__memOp__in_i[0+:2],
            2'h3, test__memOp__in_i[0+:2]
          }})
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd16; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE({
            2'h0, test__memOp__out_i[2+:2], 12'h000,
            2'h1, test__memOp__out_i[2+:2], 12'h000,
            2'h2, test__memOp__out_i[2+:2], 12'h000,
            2'h3, test__memOp__out_i[2+:2], 12'h000
          })
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CeqUminC", 16)
    fork : test__memOp_CeqUminC
      begin
        // store u
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store c
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // assign
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_CeqUminC})

        // load c
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({4{
            2'h0, test__memOp__in_i[0+:2],
            2'h1, test__memOp__in_i[0+:2],
            2'h2, test__memOp__in_i[0+:2],
            2'h3, test__memOp__in_i[0+:2]
          }})
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({
            14'h0000, test__memOp__in_i[0+:2],
            14'h1000, test__memOp__in_i[0+:2],
            14'h2000, test__memOp__in_i[0+:2],
            14'h3000, test__memOp__in_i[0+:2]
          })
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd16; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE({
            {2'h0, test__memOp__out_i[2+:2], 12'h000} - {14'h0000, test__memOp__out_i[0+:2]},
            {2'h1, test__memOp__out_i[2+:2], 12'h000} - {14'h1000, test__memOp__out_i[0+:2]},
            {2'h2, test__memOp__out_i[2+:2], 12'h000} - {14'h2000, test__memOp__out_i[0+:2]},
            {2'h3, test__memOp__out_i[2+:2], 12'h000} - {14'h3000, test__memOp__out_i[0+:2]}
          })
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_selectKey_both0", 16)
    fork : test__memOp_selectKey_both0
      begin
        // store B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // store k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})


        // selectKey
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_selectKey})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})


        // load k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16 + 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0)
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h1111_1111_1111_1111)
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h2222_2222_2222_2222)
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd4; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h1111_1111_1111_1111)
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_selectKey_firstBis1", 16)
    fork : test__memOp_selectKey_firstBis1
      begin
        // store B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // store k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})


        // selectKey
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_selectKey})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})


        // load k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16 + 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(test__memOp__in_i == 0 ? 64'h1 : 64'h0)
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h1111_1111_1111_1111)
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h2222_2222_2222_2222)
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd4; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h2222_2222_2222_2222)
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_selectKey_lastCis1", 16)
    fork : test__memOp_selectKey_lastCis1
      begin
        // store B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // store k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})


        // selectKey
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_selectKey})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})


        // load k
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16 + 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(test__memOp__in_i == 15'd16 + 15'd32 -1 ? 64'h1 : 64'h0)
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h1111_1111_1111_1111)
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h2222_2222_2222_2222)
        end
        `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd4; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h2222_2222_2222_2222)
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CpleqStimesInB_single1", 16)
    fork : test__memOp_CpleqStimesInB_single1
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // op, send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_CpleqStimesInB})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0000_0001_0000_0000)
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0001) end
        for(test__memOp__out_i = 1; test__memOp__out_i < 8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0001) end
        for(test__memOp__out_i = 1; test__memOp__out_i < 8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        end
       `TEST_UTIL__SEND_CANT

        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0004) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CpleqStimesInB_all1", 16)
    fork : test__memOp_CpleqStimesInB_all1
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // op, send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_CpleqStimesInB})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h4000_3000_2000_1000 ^ {4{ {12'b0, test__memOp__in_i[0+:4]} }})
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({4{ 16'b1 }})
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({4{ 16'b1 }})
        end
       `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd2; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__RECEIVE({
              (16'h4000 ^ {12'b0, test__memOp__out_i[0+:3], test__memOp__in_i[0]})  +  16'd16,
              (16'h3000 ^ {12'b0, test__memOp__out_i[0+:3], test__memOp__in_i[0]})  +  16'd16,
              (16'h2000 ^ {12'b0, test__memOp__out_i[0+:3], test__memOp__in_i[0]})  +  16'd16,
              (16'h1000 ^ {12'b0, test__memOp__out_i[0+:3], test__memOp__in_i[0]})  +  16'd16
            })
          end
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CpleqStimesInB_checkResultRowCol", 16)
    fork : test__memOp_CpleqStimesInB_checkResultRowCol
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // op, send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_CpleqStimesInB})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0)
        end

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__SEND({4{ {12'b0, test__memOp__out_i[0+:3]} - 16'd4 }})
          end
        end

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__SEND({4{ {12'b1, test__memOp__out_i[0+:4]} }})
          end
        end
       `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd2; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__RECEIVE({
              16'd16 * ({12'b0, test__memOp__out_i[0+:4]} - 16'd4) * ({13'b10, test__memOp__in_i[0], 2'd3}),
              16'd16 * ({12'b0, test__memOp__out_i[0+:4]} - 16'd4) * ({13'b10, test__memOp__in_i[0], 2'd2}),
              16'd16 * ({12'b0, test__memOp__out_i[0+:4]} - 16'd4) * ({13'b10, test__memOp__in_i[0], 2'd1}),
              16'd16 * ({12'b0, test__memOp__out_i[0+:4]} - 16'd4) * ({13'b10, test__memOp__in_i[0], 2'd0})
            })
          end
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CpleqStimesInB_checkVectorMul", 16)
    fork : test__memOp_CpleqStimesInB_checkVectorMul
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // op, send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_inOp_CpleqStimesInB})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0)
        end

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__SEND({
              ({12'b0, test__memOp__in_i[0], 2'd3} - 16'd4),
              ({12'b0, test__memOp__in_i[0], 2'd2} - 16'd4),
              ({12'b0, test__memOp__in_i[0], 2'd1} - 16'd4),
              ({12'b0, test__memOp__in_i[0], 2'd0} - 16'd4)
             })
          end
        end

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__SEND({
              1'b0, test__memOp__in_i[0+:13], 2'd3,
              1'b0, test__memOp__in_i[0+:13], 2'd2,
              1'b0, test__memOp__in_i[0+:13], 2'd1,
              1'b0, test__memOp__in_i[0+:13], 2'd0
            })
          end
        end
       `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd16; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0018_0018_0018_0018)
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CpleqStimesBT_single1", 16)
    fork : test__memOp_CpleqStimesBT_single1
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // op
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_CpleqStimesBT})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0000_0001_0000_0000)
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0001) end
        for(test__memOp__out_i = 1; test__memOp__out_i < 8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0001) end
        for(test__memOp__out_i = 1; test__memOp__out_i < 8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        end
       `TEST_UTIL__SEND_CANT

        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0004) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000) `TEST_UTIL__RECEIVE(64'h0000_0001_0000_0000)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CpleqStimesBT_all1", 16)
    fork : test__memOp_CpleqStimesBT_all1
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // op
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_CpleqStimesBT})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h4000_3000_2000_1000 ^ {4{ {12'b0, test__memOp__in_i[0+:4]} }})
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({4{ 16'b1 }})
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({4{ 16'b1 }})
        end
       `TEST_UTIL__SEND_CANT


        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd2; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__RECEIVE({
              (16'h4000 ^ {12'b0, test__memOp__out_i[0+:3], test__memOp__in_i[0]})  +  16'd16,
              (16'h3000 ^ {12'b0, test__memOp__out_i[0+:3], test__memOp__in_i[0]})  +  16'd16,
              (16'h2000 ^ {12'b0, test__memOp__out_i[0+:3], test__memOp__in_i[0]})  +  16'd16,
              (16'h1000 ^ {12'b0, test__memOp__out_i[0+:3], test__memOp__in_i[0]})  +  16'd16
            })
          end
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CpleqStimesBT_checkResultRowCol", 16)
    fork : test__memOp_CpleqStimesBT_checkResultRowCol
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // op
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_CpleqStimesBT})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0)
        end

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__SEND({4{ {12'b0, test__memOp__out_i[0+:3]} - 16'd4 }})
          end
        end

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__SEND({4{ {12'b1, test__memOp__out_i[0+:4]} }})
          end
        end
       `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd2; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__RECEIVE({
              16'd16 * ({12'b0, test__memOp__out_i[0+:4]} - 16'd4) * ({13'b10, test__memOp__in_i[0], 2'd3}),
              16'd16 * ({12'b0, test__memOp__out_i[0+:4]} - 16'd4) * ({13'b10, test__memOp__in_i[0], 2'd2}),
              16'd16 * ({12'b0, test__memOp__out_i[0+:4]} - 16'd4) * ({13'b10, test__memOp__in_i[0], 2'd1}),
              16'd16 * ({12'b0, test__memOp__out_i[0+:4]} - 16'd4) * ({13'b10, test__memOp__in_i[0], 2'd0})
            })
          end
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_CpleqStimesBT_checkVectorMul", 16)
    fork : test__memOp_CpleqStimesBT_checkVectorMul
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // op
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_CpleqStimesBT})

        // load C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND(64'h0)
        end

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__SEND({
              ({12'b0, test__memOp__in_i[0], 2'd3} - 16'd4),
              ({12'b0, test__memOp__in_i[0], 2'd2} - 16'd4),
              ({12'b0, test__memOp__in_i[0], 2'd1} - 16'd4),
              ({12'b0, test__memOp__in_i[0], 2'd0} - 16'd4)
             })
          end
        end

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd8; test__memOp__out_i = test__memOp__out_i+1) begin
          for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin
            `TEST_UTIL__SEND({
              1'b0, test__memOp__in_i[0+:13], 2'd3,
              1'b0, test__memOp__in_i[0+:13], 2'd2,
              1'b0, test__memOp__in_i[0+:13], 2'd1,
              1'b0, test__memOp__in_i[0+:13], 2'd0
            })
          end
        end
       `TEST_UTIL__SEND_CANT

        for(test__memOp__out_i = 0; test__memOp__out_i < 15'd16; test__memOp__out_i = test__memOp__out_i+1) begin
          `TEST_UTIL__RECEIVE(64'h0018_0018_0018_0018)
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_UeqCminBtimesS_checkDecoder", 16)
    fork : test__memOp_UeqCminBtimesS_checkDecoder
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // op
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_UeqCminBtimesS})

        // load U
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd16; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({
            test__memOp__in_i[0+:4], 2'd3, 10'b0,
            test__memOp__in_i[0+:4], 2'd2, 10'b0,
            test__memOp__in_i[0+:4], 2'd1, 10'b0,
            test__memOp__in_i[0+:4], 2'd0, 10'b0
          })
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({4{ 16'b0 }})
        end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd32; test__memOp__in_i = test__memOp__in_i+1) begin
          `TEST_UTIL__SEND({4{ 16'b0 }})
        end
       `TEST_UTIL__SEND_CANT

        `TEST_UTIL__RECEIVE(64'h4433_3322_2211_1100)
        `TEST_UTIL__RECEIVE(64'h8877_7766_6655_5544)
        `TEST_UTIL__RECEIVE(64'hCCBB_BBAA_AA99_9988)
        `TEST_UTIL__RECEIVE(64'h00FF_FFEE_EEDD_DDCC)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__memOp_UeqCminBtimesS_simple", 16)
    fork : test__memOp_UeqCminBtimesS_simple
      begin
        // store C
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_CRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // store S
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_SRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})

        // send B
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_in_BRowFirst})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})

        // op
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_op_UeqCminBtimesS})

        // load U
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_m, `MemAndMulCMD_out_u})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
      end

      begin
        `TEST_UTIL__SEND(64'h0000_0000_0000_0000) `TEST_UTIL__SEND(64'h0000_0000_0000_0000)
        `TEST_UTIL__SEND(64'h0000_0000_0000_0000) `TEST_UTIL__SEND(64'h0000_0000_0000_0000)
        `TEST_UTIL__SEND(64'h0000_0000_9E00_0000) `TEST_UTIL__SEND(64'h0000_0000_0000_0000)
        `TEST_UTIL__SEND(64'h0000_0000_0000_0000) `TEST_UTIL__SEND(64'h0000_0000_0000_0000)
        `TEST_UTIL__SEND(64'h0000_0000_A100_0000) `TEST_UTIL__SEND(64'h0000_0000_0000_0000)
        `TEST_UTIL__SEND(64'h0000_0000_A200_0000) `TEST_UTIL__SEND(64'h0000_0000_0000_0000)
        `TEST_UTIL__SEND(64'h0000_0000_0000_0000) `TEST_UTIL__SEND(64'h0000_0000_0000_0000)
        `TEST_UTIL__SEND(64'h0000_0000_0000_0000) `TEST_UTIL__SEND(64'h0000_0000_0000_0000)

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0001_0002_0004_0004) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end

        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h02A0_0150_00A8_00A8) end // Multiply those values by 1344/4
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h02A0_0150_00A8_00A8) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h02A0_0150_00A8_00A8) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h02A0_0150_00A8_00A8) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
        for(test__memOp__in_i = 0; test__memOp__in_i < 15'd4; test__memOp__in_i = test__memOp__in_i+1) begin `TEST_UTIL__SEND(64'h0000_0000_0000_0000) end
       `TEST_UTIL__SEND_CANT

        `TEST_UTIL__RECEIVE(64'h0000_0000_0000_00D0)
        `TEST_UTIL__RECEIVE(64'h0000_00D0_0000_00A0)
        `TEST_UTIL__RECEIVE(64'h0000_0080_0000_0070)
        `TEST_UTIL__RECEIVE(64'h0000_0000_0000_0000)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif



//`define MemAndMulCMD_inOp_BpleqStimesInAT 6'd7 /* BRAM.B' = BRAM.B'+ BRAM.S' *' _A^T */
//`define MemAndMulCMD_inOp_BpleqStimesInA  6'd8 /* BRAM.B' = BRAM.B' + BRAM.S' *'' _A */

