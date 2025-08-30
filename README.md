
## ⚙️ Flow Steps
1. RTL design (`async_fifo.v`)  
2. Testbench simulation (`async_fifo_tb.v`)  
3. Synthesis with Yosys  
4. Floorplanning, Placement, CTS, Routing with OpenLane  
5. DRC/LVS checks and GDSII generation  

## 🖥️ Simulation
To run the testbench:
```bash
iverilog -o async_fifo_tb async_fifo.v async_fifo_tb.v
vvp async_fifo_tb
gtkwave async_fifo_tb.vcd
```
![FIFO Layout](async_gtkwaveform.png)

### Run RTL-to-GDSII Flow with OpenLane

Use the following command to launch the OpenLane Docker container and run the flow:

```bash
cd /home/USER/OpenLane && \
docker run --rm \
  -v /home/USER:/home/USER \
  -v /home/USER/OpenLane:/openlane \
  -v /home/USER/.volare:/home/USER/.volare \
  -e PDK_ROOT=/home/USER/.volare \
  -e PDK=sky130A \
  --user $(id -u):$(id -g) \
  efabless/openlane:e73fb3c57e687a0023fcd4dcfd1566ecd478362a-amd64 \
  sh -c "./flow.tcl -design async_fifo -overwrite"
```

![GDS Layout](async_fifo.png)

