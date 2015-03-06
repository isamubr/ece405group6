    tempString =   strcat('Hi');
    frame = FrameObj(FrameObj.DATAFRAME,receiversIDS,sendersIDS,tempString);
    packetToTransmit = [frame.frameArray;0; 0; 0; 0; 0; 0; 0; 0; 0 ;0;0; 0; 0; 0; 0; 0; 0; 0; 0 ;0;0;0;0];