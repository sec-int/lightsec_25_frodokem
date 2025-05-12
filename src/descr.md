
// BRAM contains 8 brams. 16b x 8 x ...
//   1344 for B' // 16b x 8 x 1344
//    336 for S' //  4b x 8 x 1344
//     13 for ss_state // 1600b
//      8 for C // 16b x 8 x 8
//      4 for RNG_state // 512b
//      4 for salt : 512b
//      4 for seedSE : 512b
//      2 for pkh : 256b
//      2 for u : 256b | 4b x 8 x 8
//      2 for k : 256b
//    329 free

// needs to:
// B':
//   r/w 16b x 4 x 1
//   r/w 16b x 8 x 1
//   r/w 16b x 1 x 4
//   r/w 16b x 8 x 4
//   8 brams in parallel, each a row, each stores 4 vals in a cell
// C:
//   r/w 16b x 1 x 4
//   r/w 16b x 8 x 1
//   r 16b x 1 x 8
//   8 brams in parallel, each a row, each stores 4 vals in a cell
// S'
//   w 4b x 1 x 4
//   r 4b x 8 x 4
//   r 4b x 8 x 1
//   8 brams in parallel, each a row, each stores 16 vals in a cell
// u
//   r/w 4b x 2 x 8
//   w 4b x 1 x 8
//   4 brams in parallel, each two rows, each stores 8 bytes. The first 4b of each are the first row, the second 4b are the second row
// *
//   r/w 64b
//   8 brams in parallel, each column of cells stores 64b

// FF
//   1600 for state SHA3
//   1344 for i/o buffer of SHA3
//    720 for state of multiplication
//    128 seedA
//   3792 tot
//   4397 tot with margin

// *' is the multiplication 4b8x4 * 16b4x1 = 16b8x1 matrices. Changes L and R, accumulates out.
// *" is the multiplication 4b8x1 * 16b1x4 = 16b8x4 matrices. It keeps L and changes R and out.


## keygen

if(!test)
  OUT(sk.s) : 256b | BRAM.seedSE | seedA : 128b /*=z/* <- SHAKE256(0 : 8b | BRAM.RNG_state)
  BRAM.RNG_state <- SHAKE256(1 : 8b | BRAM.RNG_state)

_r <- SHAKE256(0x5F | BRAM.seedSE)
BRAM.S' <- SampleMatrix(_r) // =S^T
OUT(S^T) <- BRAM.S' // while it's being generated
BRAM.B' <- SampleMatrix(_r)^T // =E^T

seedA <- SHAKE256(seedA)
OUT(seedA) <- seedA // can out while being generated

_A = GEN(seedA)
BRAM.B' += BRAM.S' *' _A^T // =B^T

OUT(B) <- BRAM.B'^T
OUT(pkh) : 256b <- SHAKE256(seedA | BRAM.B'^T)

test = false


## encaps

if(!test)
  BRAM.u | BRAM.salt <- SHAKE256(0 : 8b | BRAM.RNG_state)

seedA : 128b <- IN(seedA)
BRAM.B' = IN(pk.b)^T // =B^T
BRAM.pkh = SHAKE256(seedA|BRAM.B'^T) // while streaming

if(!test)
  BRAM.RNG_state <- SHAKE256(1 : 8b | BRAM.RNG_state | BRAM.pkh)

BRAM.seedSE | BRAM.k = SHAKE256(BRAM.pkh | BRAM.u | BRAM.salt) // end of pkh
BRAM.C = Encode(BRAM.u) // =U // end of u

_r = SHAKE256(0x96 | seedSE) // end of seedSE
BRAM.S' = SampleMatrix(_r) // =S'
BRAM.C += BRAM.S' *' BRAM.B'^T // =C-E'' // end of B
BRAM.B' = SampleMatrix(_r) // =E'
BRAM.C += SampleMatrix(_r) // =C

_A = GEN(seedA) // end of seedA
BRAM.B' += BRAM.S' *" _A // =B' // on-the-fly multiplication.

OUT(c1) <- BRAM.B'
OUT(c2) <- BRAM.C
OUT(salt) <- BRAM.salt
OUT(ss) : 256b <- SHAKE(BRAM.B' | BRAM.C | BRAM.salt | BRAM.k) // can be done on-the-fly with the output

test = false


## decaps

BRAM.S' <- IN(sk.S^T) // =S^T

BRAM.B' <- IN(c.c1)
BRAM.C <- IN(c.c2)
BRAM.salt <- IN(c.salt)
BRAM.ss_state = SHAKE_partial(BRAM.B' | BRAM.C | BRAM.salt) // they can be streamed into here

BRAM.u = decode(( BRAM.C^T - BRAM.S' *' BRAM.B'^T )^T)

BRAM.pkh <- IN(sk.pkh)

if(!test)
  BRAM.RNG_state <- SHAKE256(BRAM.RNG_state | BRAM.ss_state | BRAM.pkh)

BRAM.seedSE | BRAM.k = SHAKE256(BRAM.pkh | BRAM.u | BRAM.salt) // end pkh, salt
BRAM.C = Encode(BRAM.u) - BRAM.C // end of u

_r = SHAKE256(0x96 | BRAM.seedSE) // end of seedSE
BRAM.S' = SampleMatrix(_r)
_B : 16b x 1344 x 8 <- IN(sk.b)
BRAM.C += BRAM.S' *' _B // can partially overlap with the generation of S', and the input of B
BRAM.B' = SampleMatrix(_r) - BRAM.B'
BRAM.C += SampleMatrix(_r)

seedA : 128b <- IN(sk.seedA)

_A = GEN(seedA)  // end of seedA
BRAM.B' += BRAM.S' *" _A

corr = BRAM.B' == 0 && BRAM.C == 0

_s : 256b <- IN(sk.s)
BRAM.k = corr ? BRAM.k : _s

OUT(ss) <- SHAKE_finish(ss_state, BRAM.k) 

test = false


## set up for test

BRAM.seedSE | BRAM.u | BRAM.salt | seedA <- IN
test = true


## add entropy

BRAM.RNG_state <- SHAKE256(BRAM.RNG_state | IN : 1024b)

