`ifdef TEST

    `DO_RST
    fork : test__io_simple
      test_name <= "test__io_simple";
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
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_in, 1'b0, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_outer})
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

//-----------------------------------------------------------------------------

    `DO_RST
    fork : test__io_withPause
      test_name <= "test__io_withPause";
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
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_in, 1'b0, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd3})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_outer})
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

//-----------------------------------------------------------------------------

    `DO_RST
    fork : test__io_toStd
      test_name <= "test__io_toStd";
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
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_in, 1'b0, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b1, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_outer})
      end

      begin
        `TEST_UTIL__SEND(64'h0000_0000_0000_0123)
        `TEST_UTIL__SEND(64'h0000_0000_0000_4567)
        `TEST_UTIL__SEND(64'h0000_0000_0000_89AB)
        `TEST_UTIL__SEND(64'h0000_0000_0000_CDEF)
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'h0000_0001_0002_0003)
        `TEST_UTIL__RECEIVE(64'h0004_0005_0006_0007)
        `TEST_UTIL__RECEIVE(64'h0000_FFFF_FFFE_FFFD)
        `TEST_UTIL__RECEIVE(64'hFFFC_FFFB_FFFA_FFF9)
        `TEST_UTIL__RECEIVE_CANT
        end
    join

//-----------------------------------------------------------------------------

    `DO_RST
    fork : test__io_fromStd
      test_name <= "test__io_fromStd";
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
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_in, 1'b1, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_o_out, 1'b0, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_outer})
      end

      begin
        `TEST_UTIL__SEND(64'h0000_0001_0002_0003)
        `TEST_UTIL__SEND(64'h0004_0005_0006_0007)
        `TEST_UTIL__SEND(64'h0000_FFFF_FFFE_FFFD)
        `TEST_UTIL__SEND(64'hFFFC_FFFB_FFFA_FFF9)
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'h0000_0000_0000_0123)
        `TEST_UTIL__RECEIVE(64'h0000_0000_0000_4567)
        `TEST_UTIL__RECEIVE(64'h0000_0000_0000_09AB)
        `TEST_UTIL__RECEIVE(64'h0000_0000_0000_CDEF)
        `TEST_UTIL__RECEIVE_CANT
        end
    join


`endif
