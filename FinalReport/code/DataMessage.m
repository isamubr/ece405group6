function datastr = DataMessage( datacrc )
%Prints the message found in the data field of the frame array

% Chop off the CRC
databits = datacrc(1:end-8);
% isolate the bytes
databytes = reshape(databits',  8, []);
% convert each byte into the decimal ascii codes
dataascii = bi2de(databytes','left-msb');
% convert to character
datastr = char(dataascii'); 

end

