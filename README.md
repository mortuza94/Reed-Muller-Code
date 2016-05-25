# Synopsis
This is an implementation of the maximum likelihood decoding of Reed Muller codes based on their trellis structure resulting from the sqaring construction. For details about the decoding algorithm see:
* Forney Jr, G. David. "Coset codes. I. Introduction and geometrical classification." Information Theory, IEEE Transactions on 34.5 (1988): 1123-1151.
* Forney Jr, G. David. "Coset codes. II. Binary lattices and related codes." Information Theory, IEEE Transactions on 34.5 (1988): 1152-1187.

## Code Example
RM(1,3) is the (8,4,4) linear block code.
* Instantiatiate the objecct `obj = RM(1,3)`
* Construct a vector `v = [0 1 0 0]`
* Encode the vector v to get the codeword `x = encode(obj,v)`
* Construct an error vector `e = [0 0 0 1 0 0 0.25]`
* Add the error vector e with codeword to get the received vector `r=x+e`
* Decode the received vector r to the codeword `y = decode(obj,r)`


## Motivation
As compared to bounded distance decoding, maximum likelihood soft-decoding decoding algorithm is much more efficient in terms of (i) error correcting capability and (ii) complexity. The decoding algorithm, using the trellis structure, takes the dynamic programming approach to reduce the computational complexity significantly.


## Tests
The test cases can be founded in accomapaning file mainTest.m

## Limitations
The decoding algorithm relies on the trellis structure of the code. The trellis structures of Reed Muller codes of dimenstion upto 32 is simpler and thus can be solved using the dynamic programming approach. However, for dimention greater than 32, the corresponding trellises contain enormous number of nodes which makes the decoding infeasible.

## Contact
For feedback and bug reporting please contact mortuza.ali@federation.edu.au

## License
Copyright (c) 2016 Mortuza Ali

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.