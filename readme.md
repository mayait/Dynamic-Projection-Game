# Dynamic Projection Game
### Prototype concept game using small projectors Processing, wiimote and OSC
#### A novel interactive approach with virtual content in a physical world using small projectors and sensors
![Kidsprojecting](https://github.com/mayait/Dynamic-Projection-Game-Processing/blob/master/images/readme/childs_projecting.png)
- - - -

###  Authors

* _Julian Maya_ julian.maya@gmail.com
* _Maria Santos_ msantosbaranco@gmail.com 
* _Guillermo Marin_ guillermo.marin.g@gmail.com  

##### Acknowledgements

* Martí Sànchez.
* Universitat Pompeu Fabra, Barcelona. _Department of Information and Communication Technologies_ https://www.upf.edu/csim/

- - - -  

###  Requirements

* Processing 3.2.2 		
  https://processing.org/	
  			
* OScP5 (OSX only) 				
  https://doi.org/10.5281/zenodo.16308		
  An Open Sound Control (OSC) implementation for Java and Processing
  
* OSculator 3.0			
  https://osculator.net/						
  OSX Wiimote - OSC mesage Broker

- - - -  

###  Get Started

1. Clone or download github master
2. Install requirements
3. Create infra-red light emitter. You can use the wii sensor bar as well
  * You need at least two IR emitter spots on the wal
  * We made two light spots with four IR leds each one.
  * wiimote built-in infrared camera tracks x,y position of up to 4 IR light blobs  
  ![wiisensor](https://github.com/mayait/Dynamic-Projection-Game-Processing/blob/master/images/readme/wiisensor.png)
4. Pair wiimote with Osculator
5. Load osculator config file /OSCulator_Presets.oscd (just double click it)
6. Open DynamicProjection.pde file on processing
 By default it runs full screen in a second display, you can change this behavior searching the line fullScreen(P3D, 1);
7. Have fun, fork it
8. Game arts and animation sprites sources are included in .psd photohop files in /images/invader/masters/*.psd

- - - -  

### MIT License

Copyright (c) 2016 Marín, Guillermo. Maya, Julián. Santos, Maria. 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and ***this permission notice shall be included*** in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
