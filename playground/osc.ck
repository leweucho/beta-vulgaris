/*
  --- MIT License --------------------------------------------------------------

  Copyright (c) 2018 Lewe Ucho

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

  ------------------------------------------------------------------------------

  OSC PLAYGROUND

  A sandbox for easy prototyping OSC communication.

  $ node runner.js playground/osc

*/

OscIn oscListener;
7400 => oscListener.port;

oscListener.addAddress("/test, i f s");
oscListener.addAddress("/csv, s");

OscMsg msg;

<<< ">>>", "Listening on localhost:7400" >>>;
<<< ">>>", "Endpoints:" >>>;
<<< ">>>", " - /test, i f s" >>>;
<<< ">>>", " - /csv, s" >>>;
<<< ">>>", "-----------------------------" >>>;

while (true) {
	oscListener => now;

	while (oscListener.recv(msg) != 0) {
		<<< ">>>", msg.address >>>;

		if (msg.address == "/test") {
			<<< ">>>", msg.getInt(0), msg.getFloat(1), msg.getString(2) >>>;
		}

		if (msg.address == "/csv") {
			OSCUtils.atofa(msg.getString(0)) @=> float dataPoints[];

			for(0 => int i; i < dataPoints.cap(); i++) {
				<<< ">>>", "[", i, "]", dataPoints[i] >>>;
			}
		}

		<<< ">>>", "-----------------------------" >>>;
  }
}
