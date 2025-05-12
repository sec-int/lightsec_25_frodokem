`ifdef TEST

    `DO_RST
    fork : test__seedA_simple
      test_name <= "test__seedA_simple";
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

        // store seedA
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_in, 1'b0, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_seedA, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_s, 2'b10})

        // load seedA
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_s, 2'b01})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_seedA})

        // load seedA
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_s, 2'b01})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_seedA})
      end

      begin
        `TEST_UTIL__SEND(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__SEND(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__RECEIVE(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__RECEIVE(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__RECEIVE_CANT
      end
    join

//-----------------------------------------------------------------------------------

    `DO_RST
    fork : test__seedA_withPause
      test_name <= "test__seedA_withPause";
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

        // store seedA
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_in, 1'b0, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_seedA, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_s, 2'b10})

        // load seedA
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_s, 2'b01})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_seedA})

        // load seedA
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_s, 2'b01})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_seedA})
      end

      begin
        `TEST_UTIL__SEND(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__SEND_DONT
        `TEST_UTIL__SEND_DONT
        `TEST_UTIL__SEND(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__RECEIVE_DONT
        `TEST_UTIL__RECEIVE_DONT
        `TEST_UTIL__RECEIVE(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__RECEIVE_DONT
        `TEST_UTIL__RECEIVE_DONT
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_BEEF_F00D)
        `TEST_UTIL__RECEIVE(64'hC0DE_BA5E_C001_BABE)
        `TEST_UTIL__RECEIVE_CANT
      end
    join

`endif
