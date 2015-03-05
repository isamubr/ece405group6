% this script tests that the frame is working
clear all
clc
import FrameObj

%% Section 1:
disp('Section 1: Compare both methods of frame creation')
str = [' abcdefghijklmnopqrstuvwxyz' char(10)];
str = [str str str]; % str is 28*3= 84 char long
%create the instance of FrameObj 'fromconst'
%adds 2000 zeros to the end of the bits 'fromconst'
fromconst = FrameObj(FrameObj.DATAFRAME,FrameObj.IDUE1,FrameObj.IDUE2,str);
receivedfrombits = [fromconst.frameArray; zeros(2000, 1)];

%create the instance of FrameObj 'frombits' which should be identical to
%'fromconst' 
%all trace of zero padding is gone
frombits = FrameObj(receivedfrombits);

disp('   Do all the fields of "fromconst" and "frombits" match?')
    %they should all match despite the zero padding in receivedfrombits
if fromconst.frameType == frombits.frameType
    disp('    -frameType matches')
else
    disp('    -frameType DOES NOT match')
end
if fromconst.header == frombits.header
    disp('    -header matches')
else
    disp('    -header DOES NOT match')
end
if fromconst.rcvID == frombits.rcvID
    disp('    -rcvID matches')
else
    disp('    -rcvID DOES NOT match')
end
if fromconst.sndID == frombits.sndID
    disp('    -sndID matches')
else
    disp('    -sndID DOES NOT match')
end
if fromconst.dataSize == frombits.dataSize
    disp('    -dataSize matches')
else
    disp('    -dataSize DOES NOT match')
end
if fromconst.hCRC8 == frombits.hCRC8
    disp('    -hCRC8 matches')
else
    disp('    -hCRC8 DOES NOT match')
end
if fromconst.data == frombits.data
    disp('    -data matches')
else
    disp('    -data DOES NOT match')
end
if fromconst.dCRC8 == frombits.dCRC8
    disp('    -dCRC8 matches')
else
    disp('    -dCRC8 DOES NOT match')
end
disp('   Do both the message of "fromconst" and "frombits" match str?')
    %both messages should match str
if(DataMessage(fromconst.data) == str)==(DataMessage(frombits.data) == str)
    disp('    -messages matches')
else
    disp('    -messages DOES NOT match')
end
%% Section 2:
disp([10 'Section 2: Test ACKFRAME frameType'])
%createACK
ACKtype = FrameObj(FrameObj.ACKFRAME,FrameObj.IDUE1,FrameObj.IDUE2, str);

disp('   What type of frame will "ACKtype" be?')
    %obvously it shold be an ACK
switch  ACKtype.frameType
    case FrameObj.INVALID
        disp('    -INVALID')
    case FrameObj.DATAFRAME
        disp('    -DATAFRAME')
    case FrameObj.ACKFRAME
        disp('    -ACKFRAME')
    otherwise
        disp('    -There is a problem with frameType')
end
disp(['   The size of "ACKtype": ' num2str(length(ACKtype.frameArray))])
    %should be 40
disp(['   The size of the data in "ACKtype": ' num2str(ACKtype.dataSize)])
    %should be 0
%% Section 3:
disp([10 'Section 3: Test INVALID frameType'])
%create the instance of FrameObj 'correct'
%adds 2000 zeros to the end of the bits 'correct'
%change the sender to IDUE3
correct= FrameObj(FrameObj.DATAFRAME, FrameObj.IDUE1, FrameObj.IDUE2, str);
receivedcbits = [correct.frameArray; zeros(2000, 1)];
receivedcbits(2*8+1:3*8) = FrameObj.IDUE3;
wrong = FrameObj(receivedcbits);

%nonsense frameType
INVALIDtype = FrameObj(20 , FrameObj.IDUE1, FrameObj.IDUE2, str);

% cut off the number of bits
receivedshort = receivedfrombits(1:39);
shorttype = FrameObj(receivedshort);

disp('   What type of frame will "wrong" be?')
    %should be INVALID
switch wrong.frameType
    case FrameObj.INVALID
        disp('    -INVALID')
    case FrameObj.DATAFRAME
        disp('    -DATAFRAME')
    case FrameObj.ACKFRAME
        disp('    -ACKFRAME')
    otherwise
        disp('    -There is a problem with frameType')
end
disp('   What type of frame will "INVALIDtype" be?')
    %should be INVALID
switch  INVALIDtype.frameType
    case FrameObj.INVALID
        disp('    -INVALID')
    case FrameObj.DATAFRAME
        disp('    -DATAFRAME')
    case FrameObj.ACKFRAME
        disp('    -ACKFRAME')
    otherwise
        disp('    -There is a problem with frameType')
end
disp('   What type of frame will "shorttype" be?')
    %should be INVALID
switch  shorttype.frameType
    case FrameObj.INVALID
        disp('    -INVALID')
    case FrameObj.DATAFRAME
        disp('    -DATAFRAME')
    case FrameObj.ACKFRAME
        disp('    -ACKFRAME')
    otherwise
        disp('    -There is a problem with frameType')
end
%% Section 4:
disp([10 'Section 4: Test the data field maximum'])
%increase the size of str
str = [str str str]; % str is 84*3 = 252 char long (over max size)
%create the instance of FrameObj 'long'
%adds 2000 zeros to the end of the bits 'long'
long= FrameObj(FrameObj.DATAFRAME, FrameObj.IDUE1, FrameObj.IDUE2, str);
disp('   Does the data field of "long" stay within the max?')
    %should be at the maximum
if long.dataSize ==234
    disp('    -dataSize is at the maximum')
else
    disp('    -dataSize is not at the maximum')
end

disp('   Does the message length of "long" match str?')
    %should not match str
if length(DataMessage(long.data)) == length(str)
    disp('    -message matches')
else
    disp('    -message DOES NOT match')
end
%% Section 5:
disp([10 'Section 5: Test whether a high dataSize will create an error'])
% an error would completely halt the program 

% create frankenstein's frame (so the we won't make an INVALID frame)
receivedbits1 = [long.header; fromconst.data];
DScheck1 = FrameObj(receivedbits1);

disp('   Will "DScheck1" be a DATAFRAME or INVALID?')
    %should be DATAFRAME
if FrameObj.INVALID ==  DScheck1.frameType
    disp('    -INVALID')
elseif FrameObj.DATAFRAME ==  DScheck1.frameType
    disp('    -DATAFRAME')
end

disp('   Does the dataSize of "fromconst" and "DScheck1" match?')
    %should be match
if fromconst.dataSize == DScheck1.dataSize
    disp('    -dataSize matches')
    %for data, we can only compare if they are the same size
    disp('    Do the data fields of "fromconst" and "DScheck1" match?')
    %should all match
    if fromconst.data == DScheck1.data
        disp('     -data matches')
    else
        disp('     -data DOES NOT match')
    end
    if fromconst.dCRC8 == DScheck1.dCRC8
        disp('      -dCRC8 matches')
    else
        disp('      -dCRC8 DOES NOT match')
    end
    if DataMessage(fromconst.data) == DataMessage(DScheck1.data)
        disp('      -message matches')
    else
        disp('      -message DOES NOT match')
    end
else
    disp('    -dataSize DOES NOT match')
end

%% Section 6:
disp([10 'Section 6: Show that the functionality of section 5 was a lie'])
% once neither the dataSize or the number of bits reflect the size of the
% data field the data cannot be recovered

% create frankenstein's frame (with zeros)
receivedbits2 = [long.header; fromconst.data; 0 ];
DScheck2 = FrameObj(receivedbits2);

disp('   Will "DScheck2" be a DATAFRAME or INVALID?')
if  FrameObj.INVALID ==  DScheck2.frameType
    disp('    -INVALID')
elseif FrameObj.DATAFRAME ==  DScheck2.frameType
    disp('    -DATAFRAME')
end
disp('   Does the dataSize of "fromconst" and "DScheck2" match?')
    %should be match
if fromconst.dataSize == DScheck2.dataSize
    disp('    -dataSize matches')
    %for data, we can only compare if they are the same size
    disp('    Do the data fields of "fromconst" and "DScheck2" match?')
    %should all match
    if fromconst.data == DScheck2.data
        disp('     -data matches')
    else
        disp('     -data DOES NOT match')
    end
    if fromconst.dCRC8 == DScheck2.dCRC8
        disp('      -dCRC8 matches')
    else
        disp('      -dCRC8 DOES NOT match')
    end
    if DataMessage(fromconst.data) == DataMessage(DScheck2.data)
        disp('      -message matches')
    else
        disp('      -message DOES NOT match')
    end
else
    disp('    -dataSize DOES NOT match')
end
%% Section 7:
disp([10 'Section 7: Test if low data size will result in valid data'])
%the dCRC8 will (almost) never be the same

% create frankenstein's frame
receivedbits3 = [fromconst.header; long.data];
DScheck3 = FrameObj(receivedbits3);

disp('   Will "DScheck3" be a DATAFRAME or INVALID?')
if FrameObj.INVALID ==  DScheck3.frameType
    disp('    -INVALID')
elseif FrameObj.DATAFRAME ==  DScheck3.frameType
    disp('    -DATAFRAME')
end

disp('   Does the dataSize of "fromconst" and "DScheck?3 match?')
% should match
if fromconst.dataSize == DScheck3.dataSize
    disp('    -dataSize matches')
    disp('    Do the data fields of "fromconst" and "DScheck3" match?')
        % only the message should match, the dCRC will be off as will the
        % data which depends on it
    if fromconst.data == DScheck3.data
        disp('     -data matches')  
    else
        disp('     -data DOES NOT match')   
    end
    if DataMessage(DScheck3.data) == DataMessage(fromconst.data)
        disp('      -message matches')
    else
        disp('      -message DOES NOT match')
    end
    if fromconst.dCRC8 == DScheck3.dCRC8
        disp('      -dCRC8 matches')
    else
        disp('      -dCRC8 DOES NOT match')
    end
else
    disp('    -dataSize DOES NOT match')
end


