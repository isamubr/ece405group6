%%%%%%%%%%%%%%%%%
%Send and receive over the air using team 4 physical Layer
% Point to Point communication
% Course Design Project of ECE4305: Software-Defined Radio Systems and Analysis
% Developed by Team 6
%       Renato Iida rfiida@wpi.edu
%       Le Wang lewang@wpi.edu
%       Rebecca Cooper rrcooper@wpi.edu

Numdata=0;
Numwrongdata=0;
Numrightdata=0;
Numack=0;
Numpoll=0;
Numinvalidframe=0;
ackToTransmit =0 ;
status = 0;
frameOut = 0;
%sim('FinalProjectTestRx_team4','StopTime', '25');
set_param('FinalProjectTestRx_team4', 'SimulationCommand','start');
pause(30);
set_param('FinalProjectTestRx_team4', 'SimulationCommand','stop');
pause(10);
for line=1:size(rcv,1)
    
    frame_array=rcv(line,:);
    
 
    receivedFrame = FrameObj(frame_array');
    if(receivedFrame.frameType == FrameObj.DATAFRAME)
        Numdata=Numdata+1;
        hDetect = comm.CRCDetector([8 7 6 4 2 0]);
        receivedFrame.sndID;
        [~, err] = step(hDetect, receivedFrame.data);
        if(err == 0)
            %create ACK packege
            %switch the role of send and received of the received package
            % the recevied ID is now the send ID
            if(ackToTransmit == 0)
                
                frameOut = FrameObj(FrameObj.ACKFRAME,receivedFrame.sndID,receivedFrame.rcvID,0);
                ackToTransmit = 1;
                status = FrameObj.CRCOK;
            end
            
            Numrightdata=Numrightdata+1;
        else
            frameOut = 0;
            status = FrameObj.CRCFAIL;
            Numwrongdata=Numwrongdata+1;
        end
    elseif (receivedFrame.frameType == FrameObj.ACKFRAME)
        
        frameOut =0 ;
        status = FrameObj.ACKRECEIVED ;
        Numack=Numack+1;
    elseif (receivedFrame.frameType == FrameObj.INVALID)
        Numinvalidframe=Numinvalidframe+1;
    end
end
totalFrameReceived = size(rcv,1);

h=msgbox(['Number of frame Received:',num2str(totalFrameReceived),' Sucess: ', num2str(Numdata)]);

if(ackToTransmit == 1)
    
    packetToTransmit =zeros(1,987);
    
    
    bits = zeros(1,64);
    ackFrame= frameOut.frameArray;
    bits(1:length(ackFrame)) = ackFrame;
    
    
    a = zeros(length(bits)*4,1);
    %sim('modulator');
    for i = 0:length(bits)-1
        a(i*4+1:i*4+4) = repmat(bits(i+1), 4, 1);
    end
    
    b = zeros(length(a),1);
    temp = zeros(length(bits),1);
    for i = 0:length(b)/length(bits)-1
        temp(1:length(bits)) = reshape(a(i*length(bits)+1:i*length(bits)+length(bits)), [length(bits)/8 8])';
        b(i*length(bits)+1: i*length(bits)+length(bits)) = temp';
    end
    packetToTransmit(1,1:length(b)) = b;
    
    set_param('TestTx_Team4_Mod', 'SimulationCommand','start');
    pause(60);
    set_param('TestTx_Team4_Mod', 'SimulationCommand','stop');
    pause(10);
    
    
    
    
end




