`ifdef TEST
    `DO_RST("test__io_simple", 0, 2)
    fork : test__io_simple
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_outer})
      end

      begin : hglishsld
        `TEST_UTIL__SEND(64'hA5A5_A5A5_A5A5_A5A5)
        `TEST_UTIL__SEND(64'h4B1D_DEAD_F00D_BEEF)
        `TEST_UTIL__SEND(64'hBABE_BA5E_C001_C0DE)
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'hA5A5_A5A5_A5A5_A5A5)
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_F00D_BEEF)
        `TEST_UTIL__RECEIVE(64'hBABE_BA5E_C001_C0DE)
        `TEST_UTIL__RECEIVE_CANT
      end

      begin
        #0.40;
        while(~out_isReady) @(posedge clk) #0.4;
        if(cmd_hasAny !== 1'b0) begin
          $display("%t: Shouldn't be able to send messages before all commands have been sent!", $time);
          done_fail <= 1'b1;
        end
      end
    join
`endif

//-----------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__io_withPause", 0, 2)
    fork : test__io_withPause
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_outer})
      end

      begin : hglishsld
        `TEST_UTIL__SEND(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__SEND_CANT
        `TEST_UTIL__SEND(64'h4B1D_DEAD_F00D_BEEF)
        `TEST_UTIL__SEND_DONT
        `TEST_UTIL__SEND(64'hBABE_BA5E_C001_C0DE)
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__RECEIVE_DONT
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_F00D_BEEF)
        `TEST_UTIL__RECEIVE_CANT
        `TEST_UTIL__RECEIVE(64'hBABE_BA5E_C001_C0DE)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__io_noOutCounter", 0, 2)
    fork : test__io_noOutCounter
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_outer})
      end

      begin : hglishsld
        `TEST_UTIL__SEND(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__SEND_CANT
        `TEST_UTIL__SEND(64'h4B1D_DEAD_F00D_BEEF)
        `TEST_UTIL__SEND_DONT
        `TEST_UTIL__SEND(64'hBABE_BA5E_C001_C0DE)
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__RECEIVE_DONT
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_F00D_BEEF)
        `TEST_UTIL__RECEIVE_CANT
        `TEST_UTIL__RECEIVE(64'hBABE_BA5E_C001_C0DE)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------

`ifdef TEST
    `DO_RST("test__io_noInCounter", 0, 2)
    fork : test__io_noInCounter
      begin
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd0})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_outer})
      end

      begin : hglishsld
        `TEST_UTIL__SEND(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__SEND_CANT
        `TEST_UTIL__SEND(64'h4B1D_DEAD_F00D_BEEF)
        `TEST_UTIL__SEND_DONT
        `TEST_UTIL__SEND(64'hBABE_BA5E_C001_C0DE)
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'h5A5A_5A5A_5A5A_5A5A)
        `TEST_UTIL__RECEIVE_DONT
        `TEST_UTIL__RECEIVE(64'h4B1D_DEAD_F00D_BEEF)
        `TEST_UTIL__RECEIVE_CANT
        `TEST_UTIL__RECEIVE(64'hBABE_BA5E_C001_C0DE)
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif
