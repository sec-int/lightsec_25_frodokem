
`ifdef TEST
    `DO_RST
    fork : test__keccak_single256
      test_name <= "test__keccak_single256";
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0000, 16'd1, 1'b1})

        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        `TEST_UTIL__SEND(64'hDAFF_82FE_98B3_7C58) // 587cb398fe82ffda
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(64'hBA2D_F685_DBDD_F554) // 54f5dddb85f62dba
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    integer test__keccak_largeIn256__in_i;
    reg [0:1408-1] test__keccak_largeIn256__in = 1408'h3bfa57a5f9f60203059defd501977628908ee42116e4674dc0a52a32c5bac02aeb60c6714cd9c47c5a61558c21648884ccee85f76b637486f3709a698641c54bf5f5eb5b844f0ea0edae628ca73fb2d567710080e8a96c3fe83857fc738ac7b6639f0d8c28bfa617c56a60fd1b8fbdc36afe9ce3151e161fa5e3a71411fb8e123d48762bc093558aea7f950706bb72f8dc7ca3497a2b3ccf345ad3d9eafde10889d76c61d432e3a165d34ad0ee2d9619;
    integer test__keccak_largeIn256__out_i;
    reg [0:256-1] test__keccak_largeIn256__out = 256'h1a2cfebf3483c33a5eba84121737d892cf8bd6c3ba324fd4ae4c2db42872e54f;
`endif

`ifdef TEST
    `DO_RST
    fork : test__keccak_largeIn256
      test_name <= "test__keccak_largeIn256";
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd22})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0001, 16'd2, 1'b1})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak_largeIn256__in_i = 0; test__keccak_largeIn256__in_i < 22; test__keccak_largeIn256__in_i = test__keccak_largeIn256__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_largeIn256__in[64*test__keccak_largeIn256__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak_largeIn256__out_i = 0; test__keccak_largeIn256__out_i < 4; test__keccak_largeIn256__out_i = test__keccak_largeIn256__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_largeIn256__out[64*test__keccak_largeIn256__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    integer test__keccak_largeOut256__in_i;
    reg [0:256-1] test__keccak_largeOut256__in = 256'h6ae23f058f0f2264a18cd609acc26dd4dbc00f5c3ee9e13ecaea2bb5a2f0bb6b;
    integer test__keccak_largeOut256__out_i;
    reg [0:1984-1] test__keccak_largeOut256__out = 1984'hb9b92544fb25cfe4ec6fe437d8da2bbe00f7bdaface3de97b8775a44d753c3adca3f7c6f183cc8647e229070439aa9539ae1f8f13470c9d3527fffdeef6c94f9f0520ff0c1ba8b16e16014e1af43ac6d94cb7929188cce9d7b02f81a2746f52ba16988e5f6d93298d778dfe05ea0ef256ae3728643ce3e29c794a0370e9ca6a8bf3e7a41e86770676ac106f7ae79e67027ce7b7b38efe27d253a52b5cb54d6eb4367a87736ed48cb45ef27f42683da140ed3295dfc575d3ea38cfc2a3697cc92864305407369b4abac054e497378dd9fd0c4b352ea3185ce1178b3dc1599df69db29259d4735320c8e7d33e8226620c9a1d22761f1d35bdf;
`endif

`ifdef TEST
    `DO_RST
    fork : test__keccak_largeOut256
      test_name <= "test__keccak_largeOut256";
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0000, 16'd2, 1'b1})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd31})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak_largeOut256__in_i = 0; test__keccak_largeOut256__in_i < 4; test__keccak_largeOut256__in_i = test__keccak_largeOut256__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_largeOut256__in[64*test__keccak_largeOut256__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak_largeOut256__out_i = 0; test__keccak_largeOut256__out_i < 31; test__keccak_largeOut256__out_i = test__keccak_largeOut256__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_largeOut256__out[64*test__keccak_largeOut256__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    integer test__keccak_splitIO128__in_i;
    reg [0:128-1] test__keccak_splitIO128__in = 128'hb11eac71031f02a11c15a1885fa42898;
    integer test__keccak_splitIO128__out_i;
    reg [0:128-1] test__keccak_splitIO128__out = 128'hde68027da130663a73980e3525b88c75;
`endif

`ifdef TEST
    `DO_RST
    fork : test__keccak_splitIO128
      test_name <= "test__keccak_splitIO128";
      begin
        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b1000, 16'd1, 1'b1})

        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'h43, 1'b1, `KeccakInCMD_sendByte})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'hbd, 1'b1, `KeccakInCMD_sendByte})

        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b1, `KeccakInCMD_forward})

        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b10})

        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak_splitIO128__in_i = 0; test__keccak_splitIO128__in_i < 2; test__keccak_splitIO128__in_i = test__keccak_splitIO128__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_splitIO128__in[64*test__keccak_splitIO128__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak_splitIO128__out_i = 0; test__keccak_splitIO128__out_i < 2; test__keccak_splitIO128__out_i = test__keccak_splitIO128__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_splitIO128__out[64*test__keccak_splitIO128__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    integer test__keccak_multiple__in_i;
    reg [0:256-1] test__keccak_multiple__in = 256'h6ae23f058f0f2264a18cd609acc26dd4dbc00f5c3ee9e13ecaea2bb5a2f0bb6b;
    integer test__keccak_multiple__out_i;
    reg [0:1984-1] test__keccak_multiple__out = 1984'hb9b92544fb25cfe4ec6fe437d8da2bbe00f7bdaface3de97b8775a44d753c3adca3f7c6f183cc8647e229070439aa9539ae1f8f13470c9d3527fffdeef6c94f9f0520ff0c1ba8b16e16014e1af43ac6d94cb7929188cce9d7b02f81a2746f52ba16988e5f6d93298d778dfe05ea0ef256ae3728643ce3e29c794a0370e9ca6a8bf3e7a41e86770676ac106f7ae79e67027ce7b7b38efe27d253a52b5cb54d6eb4367a87736ed48cb45ef27f42683da140ed3295dfc575d3ea38cfc2a3697cc92864305407369b4abac054e497378dd9fd0c4b352ea3185ce1178b3dc1599df69db29259d4735320c8e7d33e8226620c9a1d22761f1d35bdf;
`endif

`ifdef TEST
    `DO_RST
    fork : test__keccak_multiple
      test_name <= "test__keccak_multiple";
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0000, 16'd2, 1'b1})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd31})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})

        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0000, 16'd2, 1'b1})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd31})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak_multiple__in_i = 0; test__keccak_multiple__in_i < 4; test__keccak_multiple__in_i = test__keccak_multiple__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_multiple__in[64*test__keccak_multiple__in_i+:64]))
        end
        for(test__keccak_multiple__in_i = 0; test__keccak_multiple__in_i < 4; test__keccak_multiple__in_i = test__keccak_multiple__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_multiple__in[64*test__keccak_multiple__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak_multiple__out_i = 0; test__keccak_multiple__out_i < 31; test__keccak_multiple__out_i = test__keccak_multiple__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_multiple__out[64*test__keccak_multiple__out_i+:64]))
        end
        for(test__keccak_multiple__out_i = 0; test__keccak_multiple__out_i < 31; test__keccak_multiple__out_i = test__keccak_multiple__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_multiple__out[64*test__keccak_multiple__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif



