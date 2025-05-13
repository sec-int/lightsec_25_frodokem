`ifdef TEST
    `DO_RST
    fork : test__mem_simple__p1
      test_name <= "test__mem_simple";
      begin
    // { select which destination:`MainCoreCMD_which_SIZE bits, cmd:`MainCoreCMD_SIZE bits }
    // o_in:  { sampledFromStd:1bit, size:`Outer_MaxWordLen bits }
    // o_out: { sampledToStd:1bit, size:`Outer_MaxWordLen bits }
    // k_in:  { byteVal:8bits, skipIsLast:1bit, CMD:1bit }
    // k_out: { skipIsLast:1bit, sample:1bit }
    // k:     { is128else256, inState:1bit, outState:1bit, numInBlocks:16bits, numOutBlocks:16bits }
    // h:     { destination:4bit, source:4bit }  each is: { outer:1bit, keccak:1bit, memAndMul:1bit, seedA:1bit }
    // m:     { only command:5bit }
    // s:     { cmd_startIn:1bit, cmd_startOut:1bit }

        // store into memory
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_m, `MemAndMulCMD_in_k})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_memAndMul, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_in, 1'b0, 15'd4})
      end

      begin
        `TEST_UTIL__SEND(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__SEND(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__SEND(64'hA5A5_A5A5_A5A5_A5A5)
        `TEST_UTIL__SEND(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__SEND_CANT
      end
    join

    fork : test__mem_simple__p2
      begin
        // load from memory
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_m, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})

        // load from memory
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_m, `MemAndMulCMD_out_k})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_memAndMul})
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

