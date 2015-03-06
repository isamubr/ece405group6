    case FrameObj.CHUE2BS1
        if(originNode == FrameObj.IDUE2)
            finalDestination = getReceiverFromArray(frame_Array);
            switch finalDestination
                case FrameObj.IDUE1
                    status = sendReceive( FrameObj.CHUE1BS1,frame_Array, FrameObj.IDBS1 );
                 case FrameObj.IDUE3
                    status = sendReceive( FrameObj.CHBS1BS2,frame_Array, FrameObj.IDBS2 );
                otherwise
                    error('Not valid final destination BS1');
            end
        else
            %UE receiving
            [status,frameOut] = receiveFrameUE( frame_Array );
            switch status
                case FrameObj.CRCOK
                    status = sendReceive( FrameObj.CHUE2BS1,frameOut.frameArray, FramObj.IDUE2 );
                otherwise
                %Do nothing
            end
        end