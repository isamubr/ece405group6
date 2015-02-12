classdef FrameObj
    %FRAMEOBJ Summary of this class goes here
    %   Frame object to hold the heade and the payload to be used in the
    %   network
    % contastante to be used to identfy those roles inside the code
    % Channel 1  UE 1 to BS1
    %Channel 2 UE2 to BS1
    %Channel 3 BS1 to BS2
    %Channel 4 BS2 to UE3
    %ID# UE1 101
    %ID# UE2 102
    %ID# BS1 100
    %ID# BS2 200
    %ID# UE3 203
    properties (Constant)
        IDBS1 = 100;
        IDUE1 = 101;
        IDUE2 = 102;
        IDUE3 =203;
        IDBS2 = 200;
        CHUE1BS1 = 1;
        CHUE2BS1 = 2;
        CHBS1BS2 = 3;
        CHUE3BS2 = 4;
        FRAMEDATA = 1;
        FRAMEACK = 2;
        CRCOK = 1;
        CRCFAIL = 2;
        ACKRECEIVED = 3;
        TIMEOUT = 4;
    end
    properties
        frameType %When sending messages we will use at least two types of frames, the Data frame, and ACK frame
        rcvID %The identification number of the destination receiver
        %nexthopID %The identification number of the next reception hop %%%may or may not be necessary
        sndID %The identification number of the sender.
        sn %The sequence number is optional if it is necessary to deal with the situation when ACK is corrupt or lost.
        data  %data field
        
    end
    properties (Dependent)
        dataSize %Indicates the length of the payload.
        CRC8 % crc-8 code verfication of the data field
        frameSerial %why is this not working?
    end
    methods
        %function obj = FrameObj(inputframeType,inputrcvID,inputnexthopID,inputsndID,inputData)
        function obj = FrameObj(inputframeType,inputrcvID,inputsndID,inputData)
            
            %create a sequence number from 0 to 255
            obj.sn = uint8(randi([0 255],1,1));
            % create intial packetge with 4 all the input information
            if nargin == 4
                %test if the frame type is valid
                obj.frameType = inputframeType;
                %receiver verfication
                obj.rcvID = inputrcvID;
                %ADD if we need next hop
                %obj.nexthopID = inputnexthopID;
                %sender verfication
                obj.sndID = inputsndID;
                obj.data = inputData;
            else
                obj.frameType = 1;
                %receiver verfication
                obj.rcvID = 0101;
                %ADD if we need next hop &come up number
                %obj.nexthopID = ????;
                %sender verfication
                obj.sndID = 0102;
                obj.data = 'hello';
            end
        end
        function obj = set.frameType(obj,inputframeType)
            switch inputframeType
                case FrameObj.FRAMEDATA %DATA
                    obj.frameType = uint8(inputframeType);
                case FrameObj.FRAMEACK %ACK
                    obj.frameType = uint8(inputframeType);
                otherwise
                    error('Not a supported frame type')
            end
        end
        
        function obj = set.rcvID(obj,inputrcvID)
            obj.rcvID = uint8(inputrcvID);
        end
        
        %IF we need next hop
%         function obj = set.nexthopID(obj,inputnexthopID)
%             obj.nexthopID = uint8(inputnexthopID);
%         end
        
        function obj = set.sndID(obj,inputsndID)
            obj.sndID = uint8(inputsndID);
        end
        
        %data actually refers to the data and the CRC8 number ??
        function obj = set.data(obj,inputdata)
            temp_bin = reshape(dec2bin(inputdata,8)',1,[]);
            % note the <'> after the dec2bin, to transpose the matrix
            for j=1:size(temp_bin,2)
                temp_data(1,j) = str2num(temp_bin(1,j));
            end
            crcGen = comm.CRCGenerator([8 7 6 4 2 0]);
            obj.data =  step(crcGen, temp_data');
        end
        
        function value = get.dataSize(obj)
            value = uint8(lenght(obj.data)-8);
        end
        
        function value = get.CRC8(obj)
            [m, ~] = size(obj.data);
            length(obj.data)
            for j=1:8
                value(j,1) = obj.data(m-8+j,1);
            end
        end
        
        function value = get.frameSerial(obj)
            type = reshape(dec2bin(obj.frameType,8)',1,[]);
            for j=1:size(type,2)
                type_array(1,j) = str2num(type(1,j));
            end
            
            rcvid = reshape(dec2bin(obj.rcvID,8)',1,[]);
            for j=1:size(recid,2)
                rcvid_array(1,j) = str2num(recid(1,j));
            end
            
            sendid = reshape(dec2bin(obj.sndID,8)',1,[]);
            for j=1:size(sendid,2)
                sendid_array(1,j) = str2num(sendid(1,j));
            end
      
            %%%%If we need a next hop 
            %nhid =  = reshape(dec2bin(obj.nexthopID,8)',1,[]);
            %for j=1:size(nhid,2)
                %nhid_array(1,j) = str2num(nhid(1,j));
            %end
            
            % value = [type_array rcvid_array nhid_array sendid_array obj.data'];
            
            value = [type_array rcvid_array sendid_array obj.data'];
        end
    end
end

