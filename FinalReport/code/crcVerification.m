if(receivedFrame.frameType == FrameObj.DATAFRAME)
    
    hDetect = comm.CRCDetector([8 7 6 4 2 0]);
    [~, err] = step(hDetect, receivedFrame.data);
    if(err == 0)
        frameOut = FrameObj(FrameObj.ACKFRAME,receivedFrame.sndID,receivedFrame.rcvID,0);
        status = FrameObj.CRCOK;
    else
        frameOut = 0;
        status = FrameObj.CRCFAIL;
    end