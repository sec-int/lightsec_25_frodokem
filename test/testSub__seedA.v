`ifdef TEST
    `DO_RST("test__seedA_simple", 0)
    fork : test__seedA_simple
      begin
        // store seedA
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_seedA, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_s, 1'b1})

        // load seedA
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_s, 1'b0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_seedA})

        // load seedA
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_s, 1'b0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_seedA})
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
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__seedA_withPause", 0)
    fork : test__seedA_withPause
      begin
        // store seedA
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_seedA, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_s, 1'b1})

        // load seedA
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_s, 1'b0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_seedA})

        // load seedA
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_s, 1'b0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_seedA})
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
