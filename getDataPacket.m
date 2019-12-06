function outputPacket = getDataPacket(dataPacket, tempPacket, dataOffset)
    index_start = 0;
    index_end = 0;
    afterindex_start=0;
    afterindex_end =0;
    pktname = fieldnames(dataPacket);
    afterset = dataOffset + 100*12;
    for i=1:numel(pktname)
        type = class(dataPacket.(pktname{i}));
        fieldName = pktname{i};
        fieldSize = size(dataPacket.(pktname{i}),2);
        
        if(fieldSize == 1)
            if(strcmp(type,'uint8')||strcmp(type,'int8'))
                if(contains(fieldName,'reserved')||strcmp(fieldName, 'etx'))
                    afterindex_start = afterindex_end+1;
                    afterindex_end = afterindex_start;
                    outputPacket.(fieldName) = typecast(tempPacket(afterset+afterindex_start), 'uint8');
                else
                    index_start = index_end+1;
                    index_end = index_start;
                    outputPacket.(fieldName) = tempPacket(index_start:index_end);
                end
            elseif(strcmp(type, 'uint16')||strcmp(type,'int16'))
                if(strcmp(fieldName, 'boardid') ...
                        || strcmp(fieldName, 'sensorid') ...
                        || strcmp(fieldName, 'crc'))
                    afterindex_start = afterindex_end+1;
                    afterindex_end = afterindex_start+1;
                    outputPacket.(fieldName) = swapbytes(typecast...
                        (tempPacket...
                        (afterset+afterindex_start:afterset+afterindex_end), 'uint16'));
                else
                    index_start = index_end+1;
                    index_end = index_start+1;
                    outputPacket.(fieldName) = swapbytes(typecast...
                            (tempPacket(index_start:index_end), 'uint16'));
                end
            elseif(strcmp(type, 'uint32')||strcmp(type,'int32'))
                index_start = index_end+1;
                index_end = index_start+3;
                outputPacket.(fieldName) = swapbytes(typecast...
                    (tempPacket(index_start:index_end), 'uint32'));
            end
        else
            for j = 1:fieldSize  
                if(strcmp(type,'uint8')||strcmp(type,'int8'))
                    index_start = index_end+1;
                    index_end = index_start;
                    outputPacket.(fieldName)(j) = tempPacket(index_start:index_end);
                elseif(strcmp(type, 'uint16')||strcmp(type,'int16'))
                    if(strcmp(fieldName, 'xdac'))
                         outputPacket.(fieldName)(j) = typecast(swapbytes(typecast(tempPacket(dataOffset + (j-1)*12 + 1:dataOffset + (j-1)*12 + 2), 'uint16') ), 'int16' );
                    elseif(strcmp(fieldName, 'ydac'))
                         outputPacket.(fieldName)(j) = typecast(swapbytes(typecast(tempPacket(dataOffset + (j-1)*12 + 5:dataOffset + (j-1)*12 + 6), 'uint16') ), 'int16' );
                    elseif(strcmp(fieldName, 'zdac'))
                         outputPacket.(fieldName)(j) = typecast(swapbytes(typecast(tempPacket(dataOffset + (j-1)*12 + 9:dataOffset + (j-1)*12 + 10), 'uint16') ), 'int16' );    
                    elseif(strcmp(fieldName, 'xadc'))
                         outputPacket.(fieldName)(j) = typecast(swapbytes(typecast(tempPacket(dataOffset + (j-1)*12 + 3:dataOffset + (j-1)*12 + 4), 'uint16') ), 'int16' );
                    elseif(strcmp(fieldName, 'yadc'))
                         outputPacket.(fieldName)(j) = typecast(swapbytes(typecast(tempPacket(dataOffset + (j-1)*12 + 7:dataOffset + (j-1)*12 + 8), 'uint16') ), 'int16' );             
                    elseif(strcmp(fieldName, 'zadc'))
                         outputPacket.(fieldName)(j) = typecast(swapbytes(typecast(tempPacket(dataOffset + (j-1)*12 + 11:dataOffset + (j-1)*12 + 12), 'uint16') ), 'int16' );
                    end
                        
                    if(strcmp(fieldName, 'hk'))
                        index_start = index_end+1;
                        index_end = index_start+1;
                        outputPacket.(fieldName)(j) = swapbytes(typecast...
                            (tempPacket(index_start:index_end), 'int16'));
                    end
                end
            end
        end
    end
end