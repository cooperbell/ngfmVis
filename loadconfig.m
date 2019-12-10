
config = [];
fid = fopen('config.txt');
line = fgetl(fid);
words = strsplit(line, ' ');
index = str2num(string(words(2)));
line = fgetl(fid);
words = strsplit(line, ' ');
hkindex = str2num(string(words(2)));
while ischar(line)
    line = fgetl(fid);
    if line == -1
        break;
    end
    words = strsplit(line, ' ');
    type = string(words(1));
    value = string(words(2));
    input = [type, value];
    config = [config; input];
end

N = length(config);
for i = 1:index+hkindex+1
    type = config(i,1);
    value = config(i,2);

    switch i
        case 1
            if eval(value) == 1
                %input is a device
                device = 1;
            else
                %input is a file
                device = 0;
            end
        case 2
            input_file_path = value;
        case 3
            bandwith = eval(value);
        case 4
            source = value;
        case 5
            destination = value;
        case 6
            optionalA = value;
        case 7
            optionalB = value;
        case 8
            optionalC = value;
        case 9
            optionalD = value;
        case 10
            inputOffset = eval(value);
        case 11
            hk = eval(value);
        otherwise
            hk = [hk; eval(value)];
    end
end

for i = index+hkindex+2:N
    type = config(i,1);
    value = config(i,2);

    switch i
        case index+hkindex+2
            dataPacket = struct(type, eval(value));
        otherwise   
            input_struct = struct(type, eval(value));
            names = [fieldnames(dataPacket); fieldnames(input_struct)];
            dataPacket = cell2struct([struct2cell(dataPacket);...
                            struct2cell(input_struct)], names, 1);
    end
end
