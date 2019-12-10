

xmlconfig = 'pgconfig.xml';
configFIle= xml2struct(xmlconfig);
config = configFIle.config;
input = config.input;
hks = config.hks;
pkt = config.format;

input_field = fieldnames(input);
for i=1:numel(input_field)
    try
        value = eval(input.(input_field{i}).Text);
    catch
        value = input.(input_field{i}).Text;
    end
    eval([input_field{i} '= value;']);
end

hk_field = fieldnames(hks);
for i=1:numel(hk_field)
    try
        value = eval(hks.(hk_field{i}).Text);
    catch
        value = hks.(hk_field{i}).Text;
    end
    if i == 1
        hk = value;
    else
        hk = [hk;value];
    end
end

pktname = fieldnames(pkt);
for i=1:numel(pktname)
    type = pktname{i};
    try
        value = eval(pkt.(pktname{i}).Text);
    catch
        value = pkt.(pktname{i}).Text;
    end
    
    if i == 1
        dataPacket = struct(type, value);
    else
        input_struct = struct(type, value);
        names = [fieldnames(dataPacket); fieldnames(input_struct)];
        dataPacket = cell2struct([struct2cell(dataPacket);...
                            struct2cell(input_struct)], names, 1);
    end
end