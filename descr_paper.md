
# previous HW implementation

https://eprint.iacr.org/2018/686 First HW implementation. Security parameters: 640, 976.

https://eprint.iacr.org/2021/155 Second HW implementation. Security parameters: 640, 976. Uses the non-standard Trivium instead of Shake, making the design largely uncomparable.

https://eprint.iacr.org/2024/195 A Software implementation. Our multiplier's mode 2 works in the same way as the AMX accelerator they describe.

# Overall

It's an implementation of FrodoKEM with parameters: 1344 and using SHAKE to generate the A matrix.


8 brams used in parallel, they store every value that is stored. The following matrixes:
 - B'  16b x 8 x 1344  // also stores B^T, E^T, E', ...
 - S'   4b x 8 x 1344  // also stores S^T
 - C   16b x 8 x 8     // also stores C-E'', ...
 - u    4b x 8 x 8     // the paper represents it as a 256b value
each row is stored in a different bram
 - salt       512b
 - seedSE     512b
 - pkh        256b
 - k          256b
 - ss_state  1600b  (in the decapsulation, the first part of the calculation of ss by keccak is done at the start, and the keccak state is stored. This saves us from storing a much bigger amount of data.
 - RNG_state  512b  (for the generation of random data required by the specification)

The matrix A is used as it is generated, row-by-row.

There are the following multiplications in Frodo specification:
 - keygen:  A  * S    it's a  16b x 1344 x 1344 *  4b x 1344 x    8.  Executed as S^T * A*T  using the multiplication mode 1, A is streamed from keccak
 - encaps:  S' * B    it's a   4b x    8 x 1344 * 16b x 1344 x    8.  Executed as S'  * B    using the multiplication mode 1
 - en/decaps: S' * A  it's a   4b x    8 x 1344 * 16b x 1344 x 1344.  Executed as S'  * A    using the multiplication mode 2, A is streamed from the keccak
 - decaps:  B' * S    it's a  16b x    8 x 1344 *  4b x 1344 x    8.  Executed as (S^T * B'^T)^T using the multiplication mode 1
 - decaps:  S' * B    it's a   4b x    8 x 1344 * 16b x 1344 x    8.  Executed as S'  * B    using the multiplication mode 1, A is streamed from input


We have two modes of operation of out multiplication module:
 1.  4b x 8 x 4 * 16b x 4 x 1 = 16b x 8 x 1.   Changes L and R, accumulates out.
     Executed as: for(j) B'_{*,j} = E'_{*,j} + \sum_i S_{*,i} * A_{i,j}
 2.  4b x 8 x 1 * 16b x 1 x 4 = 16b x 8 x 4. It keeps L and changes R and out.
     Executed as: for(i) for(j)  B'_{i,j} = B'_{i,j} + S_{*,i} * A{i,j}.

Note that the multiplication is always between 16 bit value, and a 4 bit value in the range [-6, 6], and so it's a single sum with two optional shifts.

The bus is a 64 bits full-duplex bus. For the input to the keccak module, it has a control wire to specify if a single byte is used.

The keccak module is a parallel implementation of the keccak function, with a single buffer to do the i/o to the bus in parallel to the keccak function executing.


# modes of operation of the overall hardware

I used this to design the hardware module, it should be up-to-date. I think.

## keygen

if(!test)
  OUT(sk.s) : 256b | BRAM.seedSE | seedA : 128b /*=z/* <- SHAKE256(0 : 64b | BRAM.RNG_state)
  BRAM.RNG_state <- SHAKE256(1 : 64b | BRAM.RNG_state)

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
  BRAM.u | BRAM.salt <- SHAKE256(0 : 64b | BRAM.RNG_state)

seedA : 128b <- IN(seedA)
BRAM.B' = IN(pk.b)^T // =B^T
BRAM.pkh = SHAKE256(seedA|BRAM.B'^T) // while streaming

if(!test)
  BRAM.RNG_state <- SHAKE256(1 : 64b | BRAM.RNG_state | BRAM.pkh)

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

BRAM.RNG_state <- SHAKE256(BRAM.RNG_state | IN)

