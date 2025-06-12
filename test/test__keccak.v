`ifdef TEST_VARS
    integer test__keccak__in_i;
    integer test__keccak__out_i;
`endif


`ifdef TEST
    `DO_RST("test__keccak_single256")
    fork : test__keccak_single256
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0000, 9'd1, 1'b1})

        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        `TEST_UTIL__SEND(swapBytes64(64'h587cb398fe82ffda)) 
        `TEST_UTIL__SEND_CANT
      end

      begin
        `TEST_UTIL__RECEIVE(swapBytes64(64'h54f5dddb85f62dba))
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    reg [0:1408-1] test__keccak_largeIn256__in = 1408'h3bfa57a5f9f60203059defd501977628908ee42116e4674dc0a52a32c5bac02aeb60c6714cd9c47c5a61558c21648884ccee85f76b637486f3709a698641c54bf5f5eb5b844f0ea0edae628ca73fb2d567710080e8a96c3fe83857fc738ac7b6639f0d8c28bfa617c56a60fd1b8fbdc36afe9ce3151e161fa5e3a71411fb8e123d48762bc093558aea7f950706bb72f8dc7ca3497a2b3ccf345ad3d9eafde10889d76c61d432e3a165d34ad0ee2d9619;
    reg [0:256-1] test__keccak_largeIn256__out = 256'h1a2cfebf3483c33a5eba84121737d892cf8bd6c3ba324fd4ae4c2db42872e54f;
`endif

`ifdef TEST
    `DO_RST("test__keccak_largeIn256")
    fork : test__keccak_largeIn256
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd22})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0001, 9'd2, 1'b1})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak__in_i = 0; test__keccak__in_i < 22; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_largeIn256__in[64*test__keccak__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak__out_i = 0; test__keccak__out_i < 4; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_largeIn256__out[64*test__keccak__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    reg [0:256-1] test__keccak_largeOut256__in = 256'h6ae23f058f0f2264a18cd609acc26dd4dbc00f5c3ee9e13ecaea2bb5a2f0bb6b;
    reg [0:1984-1] test__keccak_largeOut256__out = 1984'hb9b92544fb25cfe4ec6fe437d8da2bbe00f7bdaface3de97b8775a44d753c3adca3f7c6f183cc8647e229070439aa9539ae1f8f13470c9d3527fffdeef6c94f9f0520ff0c1ba8b16e16014e1af43ac6d94cb7929188cce9d7b02f81a2746f52ba16988e5f6d93298d778dfe05ea0ef256ae3728643ce3e29c794a0370e9ca6a8bf3e7a41e86770676ac106f7ae79e67027ce7b7b38efe27d253a52b5cb54d6eb4367a87736ed48cb45ef27f42683da140ed3295dfc575d3ea38cfc2a3697cc92864305407369b4abac054e497378dd9fd0c4b352ea3185ce1178b3dc1599df69db29259d4735320c8e7d33e8226620c9a1d22761f1d35bdf;
`endif

`ifdef TEST
    `DO_RST("test__keccak_largeOut256")
    fork : test__keccak_largeOut256
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0000, 9'd2, 1'b1})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd31})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak__in_i = 0; test__keccak__in_i < 4; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_largeOut256__in[64*test__keccak__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak__out_i = 0; test__keccak__out_i < 31; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_largeOut256__out[64*test__keccak__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    reg [0:128-1] test__keccak_small128__in = 128'hd4d67b00ca51397791b81205d5582c0a;
    reg [0:128-1] test__keccak_small128__out = 128'hd0acfb2a14928caf8c168ae514925e4e;
`endif

`ifdef TEST
    `DO_RST("test__keccak_small128")
    fork : test__keccak_small128
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})
        
        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b1000, 9'd1, 1'b1})

        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd2})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak__in_i = 0; test__keccak__in_i < 2; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_small128__in[64*test__keccak__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak__out_i = 0; test__keccak__out_i < 2; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_small128__out[64*test__keccak__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    reg [0:128-1] test__keccak_splitIO128__in = 128'hb11eac71031f02a11c15a1885fa42898;
    reg [0:128-1] test__keccak_splitIO128__out = 128'hde68027da130663a73980e3525b88c75;
`endif

`ifdef TEST
    `DO_RST("test__keccak_splitIO128")
    fork : test__keccak_splitIO128
      begin
        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b1000, 9'd1, 1'b1})

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
        for(test__keccak__in_i = 0; test__keccak__in_i < 2; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_splitIO128__in[64*test__keccak__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak__out_i = 0; test__keccak__out_i < 2; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_splitIO128__out[64*test__keccak__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    reg [0:256-1] test__keccak_multiple__in = 256'h6ae23f058f0f2264a18cd609acc26dd4dbc00f5c3ee9e13ecaea2bb5a2f0bb6b;
    reg [0:1984-1] test__keccak_multiple__out = 1984'hb9b92544fb25cfe4ec6fe437d8da2bbe00f7bdaface3de97b8775a44d753c3adca3f7c6f183cc8647e229070439aa9539ae1f8f13470c9d3527fffdeef6c94f9f0520ff0c1ba8b16e16014e1af43ac6d94cb7929188cce9d7b02f81a2746f52ba16988e5f6d93298d778dfe05ea0ef256ae3728643ce3e29c794a0370e9ca6a8bf3e7a41e86770676ac106f7ae79e67027ce7b7b38efe27d253a52b5cb54d6eb4367a87736ed48cb45ef27f42683da140ed3295dfc575d3ea38cfc2a3697cc92864305407369b4abac054e497378dd9fd0c4b352ea3185ce1178b3dc1599df69db29259d4735320c8e7d33e8226620c9a1d22761f1d35bdf;
`endif

`ifdef TEST
    `DO_RST("test__keccak_multiple")
    fork : test__keccak_multiple
      begin
        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0000, 9'd2, 1'b1})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd31})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})

        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0000, 9'd2, 1'b1})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd31})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak__in_i = 0; test__keccak__in_i < 4; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_multiple__in[64*test__keccak__in_i+:64]))
        end
        for(test__keccak__in_i = 0; test__keccak__in_i < 4; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_multiple__in[64*test__keccak__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak__out_i = 0; test__keccak__out_i < 31; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_multiple__out[64*test__keccak__out_i+:64]))
        end
        for(test__keccak__out_i = 0; test__keccak__out_i < 31; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_multiple__out[64*test__keccak__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    reg [0:64-1] test__keccak_simpleState1__in = 64'h587cb398fe82ffda;
    reg [1600-1:0] test__keccak_simpleState1__out = 1600'h587cb398fe82ffda_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;
`endif

`ifdef TEST
    `DO_RST("test__keccak_simpleState1")
    fork : test__keccak_simpleState1
      begin
        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0011, 9'd1, 1'b0})  // TODO: BUG: no out & out state

        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b1, `KeccakInCMD_forward})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'd16, 1'b1, `KeccakInCMD_sendZeros})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd25})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        #1
        for(test__keccak__in_i = 0; test__keccak__in_i < 1; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_simpleState1__in[64*test__keccak__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        #1
        for(test__keccak__out_i = 0; test__keccak__out_i < 25; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_simpleState1__out[64*test__keccak__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif


//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    reg [1600-1:0] test__keccak_simpleState2__in = 1600'h587cb398fe82ffda_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000_0000000000000000;
    reg [0:64-1] test__keccak_simpleState2__out =    64'h54f5dddb85f62dba;
`endif

`ifdef TEST
    `DO_RST("test__keccak_simpleState2")
    fork : test__keccak_simpleState2
      begin
        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0100, 9'd1, 1'b1})

        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd25})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'd25, 1'b1, `KeccakInCMD_forward})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'd1, 1'b0, `KeccakInCMD_sendZeros})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak__in_i = 0; test__keccak__in_i < 25; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_simpleState2__in[64*test__keccak__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak__out_i = 0; test__keccak__out_i < 1; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_simpleState2__out[64*test__keccak__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif

//-----------------------------------------------------------------------------------

`ifdef TEST_VARS
    reg [0:1152-1] test__keccak_state__in1 =   1152'h163cf8e89b260a81a3d6e4787587a304b35eab8b84faebcef14c626290a9e15f601d135cf503bc9ad5d23e7f213a6146787053f618c6ee90467e3a8df1e03387928acc375608339f7fa45788077fa82f87e11d3c58ce7cf3f8dad6aeaf3e508b722a2a62075df9fa6af4377c707ffe27aa5a11468c3b1c5fce073dae13eac2d1c9a635c5502b96115e69e741a262ee96;
    reg [1600-1:0] test__keccak_state__state = 1600'hcd004be3a01bc1fe_440a0593ef012607_1af4ea181d4c2b47_cf6c09eeb2ea6368_525d7c58424cc28d_cdb89b2e2d047a88_0b7e757b13c972fe_3d6d099690845fa7_59782e53c474639c_0828bc1b5ebb5bc5_1f3c221f91e5bc08_747d17171975f563_2ff518e44256e4ad_40e842442f7542a7_0f1435c9e00d0ac6_498c20f83990ed80_607cf65bf9d1928b_98b75a158b4d2167_0d4780fc298d995a_c9395d74e939d714_bacb7fa2622b4350_8cff6749017fc2c2_facc8c03915e4b91_7f5fb71252f38403_405c236db1eb6d76;
    reg [0:64-1] test__keccak_state__in2 =       64'ha78336fcfc34573c;
    reg [0:256-1] test__keccak_state__out =     256'h181d10fa5a58ca57_077be52eda539101_35087312ca771108_4e4a5213c81cb4a2;
`endif

`ifdef TEST
    `DO_RST("test__keccak_state")
    fork : test__keccak_state
      begin
        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0011, 9'd2, 1'b0})

        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd18})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b1, `KeccakInCMD_forward})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'd16, 1'b1, `KeccakInCMD_sendZeros})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd25})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})

        // do hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k, 4'b0100, 9'd1, 1'b1})

        // send the data to hash
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd25})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})

        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_in, 15'd1})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_keccak, `CmdHubCMD_outer})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'd1, 1'b1, `KeccakInCMD_sendZeros})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_in, 8'b0, 1'b0, `KeccakInCMD_forward})
        
        // receive hashed data
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_o_out, 15'd4})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_h, `CmdHubCMD_outer, `CmdHubCMD_keccak})
        `TEST_UTIL__CMD_SEND({`MainCoreSerialCMD_wp_k_out, 2'b00})
      end

      begin
        for(test__keccak__in_i = 0; test__keccak__in_i < 18; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_state__in1[64*test__keccak__in_i+:64]))
        end
        for(test__keccak__in_i = 0; test__keccak__in_i < 25; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(test__keccak_state__state[64*test__keccak__in_i+:64])
        end
        for(test__keccak__in_i = 0; test__keccak__in_i < 1; test__keccak__in_i = test__keccak__in_i+1) begin
          `TEST_UTIL__SEND(swapBytes64(test__keccak_state__in2[64*test__keccak__in_i+:64]))
        end
        `TEST_UTIL__SEND_CANT
      end

      begin
        for(test__keccak__out_i = 0; test__keccak__out_i < 25; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(test__keccak_state__state[64*test__keccak__out_i+:64])
        end
        for(test__keccak__out_i = 0; test__keccak__out_i < 4; test__keccak__out_i = test__keccak__out_i+1) begin
          `TEST_UTIL__RECEIVE(swapBytes64(test__keccak_state__out[64*test__keccak__out_i+:64]))
        end
        `TEST_UTIL__RECEIVE_CANT
      end
    join
`endif


